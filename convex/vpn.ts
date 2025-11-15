import { v } from "convex/values";
import { mutation, query } from "./_generated/server";
import { Id } from "./_generated/dataModel";

/**
 * PrivacyGuard VPN - VPN Management Functions
 *
 * Handles:
 * - Server listing and selection
 * - VPN session tracking
 * - Stats recording
 * - WireGuard config generation
 */

// ==========================================
// QUERIES (Read Operations)
// ==========================================

/**
 * Get all available VPN servers
 */
export const getServers = query({
  args: {
    countryCode: v.optional(v.string()),
    isPremiumUser: v.optional(v.boolean()),
  },
  handler: async (ctx, args) => {
    let serversQuery = ctx.db.query("vpn_servers");

    const servers = await serversQuery.collect();

    // Filter by status
    let filtered = servers.filter((s) => s.status === "active");

    // Filter by country if specified
    if (args.countryCode) {
      filtered = filtered.filter((s) => s.countryCode === args.countryCode);
    }

    // Filter by premium if not premium user
    if (!args.isPremiumUser) {
      filtered = filtered.filter((s) => !s.isPremium);
    }

    // Sort by load and latency
    filtered.sort((a, b) => {
      const scoreA = (100 - a.load) * 0.6 + (100 - a.latency / 10) * 0.4;
      const scoreB = (100 - b.load) * 0.6 + (100 - b.latency / 10) * 0.4;
      return scoreB - scoreA;
    });

    return filtered;
  },
});

/**
 * Get server by ID
 */
export const getServer = query({
  args: { serverId: v.id("vpn_servers") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.serverId);
  },
});

/**
 * Get best server for user
 */
export const getBestServer = query({
  args: {
    countryCode: v.optional(v.string()),
    isPremiumUser: v.optional(v.boolean()),
  },
  handler: async (ctx, args) => {
    const servers = await ctx.db
      .query("vpn_servers")
      .withIndex("by_status", (q) => q.eq("status", "active"))
      .collect();

    let filtered = servers;

    // Filter by country
    if (args.countryCode) {
      filtered = filtered.filter((s) => s.countryCode === args.countryCode);
    }

    // Filter by premium
    if (!args.isPremiumUser) {
      filtered = filtered.filter((s) => !s.isPremium);
    }

    if (filtered.length === 0) {
      throw new Error("No servers available");
    }

    // Find best server (lowest load + lowest latency)
    filtered.sort((a, b) => {
      const scoreA = (100 - a.load) * 0.6 + (100 - a.latency / 10) * 0.4;
      const scoreB = (100 - b.load) * 0.6 + (100 - b.latency / 10) * 0.4;
      return scoreB - scoreA;
    });

    return filtered[0];
  },
});

/**
 * Get user's VPN sessions
 */
export const getUserSessions = query({
  args: {
    userId: v.id("users"),
    limit: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const limit = args.limit ?? 50;

    const sessions = await ctx.db
      .query("vpn_sessions")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .order("desc")
      .take(limit);

    return sessions;
  },
});

/**
 * Get active session for user
 */
export const getActiveSession = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const session = await ctx.db
      .query("vpn_sessions")
      .withIndex("by_user_active", (q) =>
        q.eq("userId", args.userId).eq("status", "active")
      )
      .first();

    return session;
  },
});

/**
 * Get WireGuard configuration for user
 */
export const getVpnConfig = query({
  args: {
    userId: v.id("users"),
    serverId: v.id("vpn_servers"),
  },
  handler: async (ctx, args) => {
    // Check if user already has keys for this server
    let userKeys = await ctx.db
      .query("vpn_user_keys")
      .withIndex("by_user_server", (q) =>
        q.eq("userId", args.userId).eq("serverId", args.serverId)
      )
      .first();

    if (!userKeys) {
      // Generate new keys
      // TODO: In production, generate real WireGuard keys
      const privateKey = `TEMP_PRIVATE_KEY_${args.userId}_${Date.now()}`;
      const publicKey = `TEMP_PUBLIC_KEY_${args.userId}_${Date.now()}`;

      // Assign IP from pool (simple sequential allocation)
      const existingKeys = await ctx.db.query("vpn_user_keys").collect();
      const nextIP = `10.8.0.${existingKeys.length + 2}`;

      const keysId = await ctx.db.insert("vpn_user_keys", {
        userId: args.userId,
        serverId: args.serverId,
        privateKey,
        publicKey,
        assignedIP: `${nextIP}/24`,
        createdAt: Date.now(),
      });

      userKeys = await ctx.db.get(keysId);
    }

    // Get server info
    const server = await ctx.db.get(args.serverId);
    if (!server) throw new Error("Server not found");

    // Return config in format expected by Flutter
    return {
      privateKey: userKeys!.privateKey,
      address: userKeys!.assignedIP,
      dns: ["1.1.1.1", "1.0.0.1"],
      peer: {
        publicKey: server.publicKey,
        endpoint: `${server.ipAddress}:${server.port}`,
        allowedIPs: ["0.0.0.0/0"],
      },
    };
  },
});

// ==========================================
// MUTATIONS (Write Operations)
// ==========================================

/**
 * Start VPN session
 */
export const startSession = mutation({
  args: {
    userId: v.id("users"),
    serverId: v.id("vpn_servers"),
  },
  handler: async (ctx, args) => {
    // Check if user already has active session
    const existingSession = await ctx.db
      .query("vpn_sessions")
      .withIndex("by_user_active", (q) =>
        q.eq("userId", args.userId).eq("status", "active")
      )
      .first();

    if (existingSession) {
      throw new Error("User already has an active session");
    }

    const now = Date.now();

    const sessionId = await ctx.db.insert("vpn_sessions", {
      userId: args.userId,
      serverId: args.serverId,
      startedAt: now,
      bytesIn: 0,
      bytesOut: 0,
      trackersBlocked: 0,
      adsBlocked: 0,
      icrEarned: 0,
      status: "active",
    });

    // Update server load
    const server = await ctx.db.get(args.serverId);
    if (server) {
      await ctx.db.patch(args.serverId, {
        currentUsers: server.currentUsers + 1,
        load: Math.min(100, Math.round((server.currentUsers + 1) / server.maxUsers * 100)),
        updatedAt: now,
      });
    }

    return sessionId;
  },
});

/**
 * End VPN session and calculate rewards
 */
export const endSession = mutation({
  args: {
    sessionId: v.id("vpn_sessions"),
    bytesIn: v.number(),
    bytesOut: v.number(),
    trackersBlocked: v.optional(v.number()),
    adsBlocked: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const session = await ctx.db.get(args.sessionId);
    if (!session) throw new Error("Session not found");

    const now = Date.now();
    const durationMinutes = Math.floor((now - session.startedAt) / 60000);

    // Calculate ICR earnings
    const baseReward = durationMinutes * 0.1; // 0.1 ICR per minute
    const trackerBonus = (args.trackersBlocked ?? 0) * 0.01; // 0.01 ICR per tracker
    const adBonus = (args.adsBlocked ?? 0) * 0.01; // 0.01 ICR per ad
    const totalReward = baseReward + trackerBonus + adBonus;

    // Update session
    await ctx.db.patch(args.sessionId, {
      endedAt: now,
      bytesIn: args.bytesIn,
      bytesOut: args.bytesOut,
      trackersBlocked: args.trackersBlocked ?? 0,
      adsBlocked: args.adsBlocked ?? 0,
      icrEarned: totalReward,
      status: "completed",
    });

    // Update server load
    const server = await ctx.db.get(session.serverId);
    if (server && server.currentUsers > 0) {
      await ctx.db.patch(session.serverId, {
        currentUsers: server.currentUsers - 1,
        load: Math.max(0, Math.round((server.currentUsers - 1) / server.maxUsers * 100)),
        updatedAt: now,
      });
    }

    // Update user ICR balance
    const balance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", session.userId))
      .first();

    if (balance) {
      const newBalance = balance.balance + totalReward;
      const newLifetime = balance.lifetimeEarnings + totalReward;

      await ctx.db.patch(balance._id, {
        balance: newBalance,
        lifetimeEarnings: newLifetime,
        updatedAt: now,
      });

      // Record transaction
      await ctx.db.insert("icr_transactions", {
        userId: session.userId,
        type: "earn",
        amount: totalReward,
        source: "vpn_session",
        sourceId: args.sessionId,
        description: `VPN session: ${durationMinutes}min, ${args.trackersBlocked ?? 0} trackers blocked`,
        balanceAfter: newBalance,
        createdAt: now,
      });

      // Update mission progress
      await updateMissionProgress(ctx, session.userId, {
        sessionDuration: durationMinutes,
        trackersBlocked: args.trackersBlocked ?? 0,
        adsBlocked: args.adsBlocked ?? 0,
      });
    }

    return {
      duration: durationMinutes,
      reward: totalReward,
      bytesTransferred: args.bytesIn + args.bytesOut,
    };
  },
});

/**
 * Update session stats (called periodically while connected)
 */
export const updateSessionStats = mutation({
  args: {
    sessionId: v.id("vpn_sessions"),
    bytesIn: v.number(),
    bytesOut: v.number(),
    trackersBlocked: v.optional(v.number()),
    adsBlocked: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    await ctx.db.patch(args.sessionId, {
      bytesIn: args.bytesIn,
      bytesOut: args.bytesOut,
      trackersBlocked: args.trackersBlocked ?? 0,
      adsBlocked: args.adsBlocked ?? 0,
    });

    return { success: true };
  },
});

/**
 * Add VPN server (admin)
 */
export const addServer = mutation({
  args: {
    name: v.string(),
    countryCode: v.string(),
    countryName: v.string(),
    cityName: v.string(),
    ipAddress: v.string(),
    port: v.number(),
    protocol: v.string(),
    publicKey: v.string(),
    isPremium: v.boolean(),
    maxUsers: v.number(),
  },
  handler: async (ctx, args) => {
    const now = Date.now();

    const serverId = await ctx.db.insert("vpn_servers", {
      ...args,
      load: 0,
      latency: 50, // Default latency
      status: "active",
      currentUsers: 0,
      createdAt: now,
      updatedAt: now,
    });

    return serverId;
  },
});

/**
 * Update server stats (called by server monitoring)
 */
export const updateServerStats = mutation({
  args: {
    serverId: v.id("vpn_servers"),
    load: v.optional(v.number()),
    latency: v.optional(v.number()),
    currentUsers: v.optional(v.number()),
    status: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const { serverId, ...updates } = args;

    await ctx.db.patch(serverId, {
      ...updates,
      updatedAt: Date.now(),
    });

    return { success: true };
  },
});

// ==========================================
// HELPER FUNCTIONS
// ==========================================

/**
 * Update mission progress based on session activity
 */
async function updateMissionProgress(
  ctx: any,
  userId: Id<"users">,
  activity: {
    sessionDuration?: number;
    trackersBlocked?: number;
    adsBlocked?: number;
  }
) {
  // Get active missions for user
  const userMissions = await ctx.db
    .query("user_missions")
    .withIndex("by_user_status", (q) =>
      q.eq("userId", userId).eq("status", "active")
    )
    .collect();

  const now = Date.now();

  for (const userMission of userMissions) {
    const mission = await ctx.db.get(userMission.missionId);
    if (!mission) continue;

    let progressDelta = 0;

    // Calculate progress based on mission type
    switch (mission.type) {
      case "sessionDuration":
        progressDelta = activity.sessionDuration ?? 0;
        break;
      case "trackersBlocked":
        progressDelta = activity.trackersBlocked ?? 0;
        break;
      case "adsBlocked":
        progressDelta = activity.adsBlocked ?? 0;
        break;
    }

    if (progressDelta > 0) {
      const newProgress = userMission.progress + progressDelta;

      // Check if mission completed
      if (newProgress >= mission.targetValue && userMission.status === "active") {
        await ctx.db.patch(userMission._id, {
          progress: mission.targetValue,
          status: "completed",
          completedAt: now,
        });

        // Award mission reward
        const balance = await ctx.db
          .query("icr_balances")
          .withIndex("by_user", (q) => q.eq("userId", userId))
          .first();

        if (balance) {
          const newBalance = balance.balance + mission.rewardAmount;

          await ctx.db.patch(balance._id, {
            balance: newBalance,
            lifetimeEarnings: balance.lifetimeEarnings + mission.rewardAmount,
            updatedAt: now,
          });

          await ctx.db.insert("icr_transactions", {
            userId,
            type: "earn",
            amount: mission.rewardAmount,
            source: "mission",
            sourceId: userMission.missionId,
            description: `Mission completed: ${mission.title}`,
            balanceAfter: newBalance,
            createdAt: now,
          });
        }
      } else {
        await ctx.db.patch(userMission._id, {
          progress: newProgress,
        });
      }
    }
  }
}
