import { v } from "convex/values";
import { mutation, query } from "./_generated/server";
import { Id } from "./_generated/dataModel";

/**
 * PrivacyGuard VPN - ICR Rewards & Missions
 *
 * Handles:
 * - ICR balance queries
 * - Transaction history
 * - Mission management
 * - Referral rewards
 */

// ==========================================
// QUERIES (Read Operations)
// ==========================================

/**
 * Get user's ICR balance
 */
export const getBalance = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const balance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    return balance ?? {
      userId: args.userId,
      balance: 0,
      lifetimeEarnings: 0,
      pendingRewards: 0,
      updatedAt: Date.now(),
    };
  },
});

/**
 * Get user's transaction history
 */
export const getTransactions = query({
  args: {
    userId: v.id("users"),
    limit: v.optional(v.number()),
    type: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const limit = args.limit ?? 50;

    let query = ctx.db
      .query("icr_transactions")
      .withIndex("by_user_created", (q) => q.eq("userId", args.userId))
      .order("desc");

    const transactions = await query.take(limit);

    // Filter by type if specified
    if (args.type) {
      return transactions.filter((t) => t.type === args.type);
    }

    return transactions;
  },
});

/**
 * Get available missions
 */
export const getMissions = query({
  args: {
    userId: v.id("users"),
    isPremium: v.optional(v.boolean()),
  },
  handler: async (ctx, args) => {
    const now = Date.now();

    // Get all active missions
    let missions = await ctx.db
      .query("missions")
      .withIndex("by_active", (q) => q.eq("isActive", true))
      .collect();

    // Filter premium missions if not premium user
    if (!args.isPremium) {
      missions = missions.filter((m) => !m.isPremiumOnly);
    }

    // Filter expired missions
    missions = missions.filter((m) => !m.endDate || m.endDate > now);

    // Get user's progress for each mission
    const missionsWithProgress = await Promise.all(
      missions.map(async (mission) => {
        const userMission = await ctx.db
          .query("user_missions")
          .withIndex("by_user_status", (q) =>
            q.eq("userId", args.userId).eq("status", "active")
          )
          .filter((q) => q.eq(q.field("missionId"), mission._id))
          .first();

        return {
          ...mission,
          progress: userMission?.progress ?? 0,
          status: userMission?.status ?? "available",
          startedAt: userMission?.startedAt,
          expiresAt: userMission?.expiresAt,
        };
      })
    );

    return missionsWithProgress;
  },
});

/**
 * Get user's active missions
 */
export const getUserMissions = query({
  args: {
    userId: v.id("users"),
    status: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const statusFilter = args.status ?? "active";

    const userMissions = await ctx.db
      .query("user_missions")
      .withIndex("by_user_status", (q) =>
        q.eq("userId", args.userId).eq("status", statusFilter)
      )
      .collect();

    // Enrich with mission details
    const enriched = await Promise.all(
      userMissions.map(async (um) => {
        const mission = await ctx.db.get(um.missionId);
        return {
          ...um,
          mission,
        };
      })
    );

    return enriched;
  },
});

/**
 * Get leaderboard (top earners)
 */
export const getLeaderboard = query({
  args: {
    limit: v.optional(v.number()),
    timeframe: v.optional(v.string()), // "all", "month", "week"
  },
  handler: async (ctx, args) => {
    const limit = args.limit ?? 100;
    const timeframe = args.timeframe ?? "all";

    const balances = await ctx.db.query("icr_balances").collect();

    // Sort by lifetime earnings
    balances.sort((a, b) => b.lifetimeEarnings - a.lifetimeEarnings);

    // Get user info for top users
    const leaderboard = await Promise.all(
      balances.slice(0, limit).map(async (balance, index) => {
        const user = await ctx.db.get(balance.userId);
        return {
          rank: index + 1,
          userId: balance.userId,
          username: user?.username ?? "Unknown",
          avatarUrl: user?.avatarUrl,
          lifetimeEarnings: balance.lifetimeEarnings,
          isPremium: user?.isPremium ?? false,
        };
      })
    );

    return leaderboard;
  },
});

// ==========================================
// MUTATIONS (Write Operations)
// ==========================================

/**
 * Start a mission
 */
export const startMission = mutation({
  args: {
    userId: v.id("users"),
    missionId: v.id("missions"),
  },
  handler: async (ctx, args) => {
    // Check if mission exists and is active
    const mission = await ctx.db.get(args.missionId);
    if (!mission) throw new Error("Mission not found");
    if (!mission.isActive) throw new Error("Mission is not active");

    // Check if user already has this mission
    const existing = await ctx.db
      .query("user_missions")
      .withIndex("by_user_status", (q) =>
        q.eq("userId", args.userId).eq("status", "active")
      )
      .filter((q) => q.eq(q.field("missionId"), args.missionId))
      .first();

    if (existing) {
      throw new Error("Mission already started");
    }

    const now = Date.now();
    const expiresAt = mission.duration ? now + mission.duration * 1000 : undefined;

    const userMissionId = await ctx.db.insert("user_missions", {
      userId: args.userId,
      missionId: args.missionId,
      progress: 0,
      status: "active",
      startedAt: now,
      expiresAt,
    });

    return {
      success: true,
      userMissionId,
      expiresAt,
    };
  },
});

/**
 * Claim mission reward (manual claim if auto-reward fails)
 */
export const claimMissionReward = mutation({
  args: {
    userMissionId: v.id("user_missions"),
  },
  handler: async (ctx, args) => {
    const userMission = await ctx.db.get(args.userMissionId);
    if (!userMission) throw new Error("Mission not found");
    if (userMission.status !== "completed") {
      throw new Error("Mission not completed");
    }

    const mission = await ctx.db.get(userMission.missionId);
    if (!mission) throw new Error("Mission details not found");

    // Check if already rewarded
    const existingTransaction = await ctx.db
      .query("icr_transactions")
      .filter((q) =>
        q.and(
          q.eq(q.field("userId"), userMission.userId),
          q.eq(q.field("source"), "mission"),
          q.eq(q.field("sourceId"), userMission.missionId)
        )
      )
      .first();

    if (existingTransaction) {
      throw new Error("Reward already claimed");
    }

    const now = Date.now();

    // Award reward
    const balance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", userMission.userId))
      .first();

    if (!balance) throw new Error("Balance not found");

    const newBalance = balance.balance + mission.rewardAmount;

    await ctx.db.patch(balance._id, {
      balance: newBalance,
      lifetimeEarnings: balance.lifetimeEarnings + mission.rewardAmount,
      updatedAt: now,
    });

    await ctx.db.insert("icr_transactions", {
      userId: userMission.userId,
      type: "earn",
      amount: mission.rewardAmount,
      source: "mission",
      sourceId: userMission.missionId,
      description: `Mission completed: ${mission.title}`,
      balanceAfter: newBalance,
      createdAt: now,
    });

    return {
      success: true,
      reward: mission.rewardAmount,
      newBalance,
    };
  },
});

/**
 * Withdraw ICR to wallet
 */
export const withdrawToWallet = mutation({
  args: {
    userId: v.id("users"),
    amount: v.number(),
    walletAddress: v.string(),
  },
  handler: async (ctx, args) => {
    const balance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    if (!balance) throw new Error("Balance not found");
    if (balance.balance < args.amount) {
      throw new Error("Insufficient balance");
    }

    const now = Date.now();
    const newBalance = balance.balance - args.amount;

    await ctx.db.patch(balance._id, {
      balance: newBalance,
      walletAddress: args.walletAddress,
      updatedAt: now,
    });

    await ctx.db.insert("icr_transactions", {
      userId: args.userId,
      type: "withdraw",
      amount: -args.amount,
      source: "wallet_withdrawal",
      description: `Withdrawal to ${args.walletAddress.substring(0, 10)}...`,
      balanceAfter: newBalance,
      createdAt: now,
    });

    // TODO: In production, integrate with blockchain
    // - Transfer ICR tokens to wallet address
    // - Wait for confirmation
    // - Update transaction with blockchain tx hash

    return {
      success: true,
      newBalance,
      message: "Withdrawal initiated (blockchain integration pending)",
    };
  },
});

/**
 * Create referral code
 */
export const createReferralCode = mutation({
  args: {
    userId: v.id("users"),
  },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) throw new Error("User not found");

    // Generate referral code from username
    const code = `${user.username.toUpperCase()}_${Math.random()
      .toString(36)
      .substring(2, 8)
      .toUpperCase()}`;

    return {
      code,
      shareUrl: `https://privacyguard.app/ref/${code}`,
    };
  },
});

/**
 * Apply referral code
 */
export const applyReferralCode = mutation({
  args: {
    userId: v.id("users"),
    referralCode: v.string(),
  },
  handler: async (ctx, args) => {
    // Check if user already used a referral
    const existing = await ctx.db
      .query("referrals")
      .filter((q) => q.eq(q.field("referredUserId"), args.userId))
      .first();

    if (existing) {
      throw new Error("Referral code already used");
    }

    // Find referrer by code (simplified - in production, store codes)
    // For now, extract username from code
    const username = args.referralCode.split("_")[0].toLowerCase();
    const referrer = await ctx.db
      .query("users")
      .withIndex("by_username", (q) => q.eq("username", username))
      .first();

    if (!referrer) {
      throw new Error("Invalid referral code");
    }

    if (referrer._id === args.userId) {
      throw new Error("Cannot refer yourself");
    }

    const now = Date.now();
    const rewardAmount = 50; // 50 ICR for successful referral

    // Create referral record
    const referralId = await ctx.db.insert("referrals", {
      referrerId: referrer._id,
      referredUserId: args.userId,
      referralCode: args.referralCode,
      status: "completed",
      rewardAmount,
      createdAt: now,
      completedAt: now,
    });

    // Reward referrer
    const referrerBalance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", referrer._id))
      .first();

    if (referrerBalance) {
      const newBalance = referrerBalance.balance + rewardAmount;

      await ctx.db.patch(referrerBalance._id, {
        balance: newBalance,
        lifetimeEarnings: referrerBalance.lifetimeEarnings + rewardAmount,
        updatedAt: now,
      });

      await ctx.db.insert("icr_transactions", {
        userId: referrer._id,
        type: "earn",
        amount: rewardAmount,
        source: "referral",
        sourceId: referralId,
        description: `Referral bonus: ${username}`,
        balanceAfter: newBalance,
        createdAt: now,
      });
    }

    // Reward referred user
    const userBalance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    if (userBalance) {
      const bonusAmount = 25; // 25 ICR for being referred
      const newBalance = userBalance.balance + bonusAmount;

      await ctx.db.patch(userBalance._id, {
        balance: newBalance,
        lifetimeEarnings: userBalance.lifetimeEarnings + bonusAmount,
        updatedAt: now,
      });

      await ctx.db.insert("icr_transactions", {
        userId: args.userId,
        type: "earn",
        amount: bonusAmount,
        source: "referral",
        sourceId: referralId,
        description: "Referral bonus: Welcome!",
        balanceAfter: newBalance,
        createdAt: now,
      });
    }

    return {
      success: true,
      message: `You earned ${25} ICR! Your referrer earned ${rewardAmount} ICR.`,
    };
  },
});

/**
 * Get user's referral stats
 */
export const getReferralStats = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const referrals = await ctx.db
      .query("referrals")
      .withIndex("by_referrer", (q) => q.eq("referrerId", args.userId))
      .collect();

    const totalReferrals = referrals.length;
    const completedReferrals = referrals.filter(
      (r) => r.status === "completed"
    ).length;
    const totalEarned = referrals.reduce(
      (sum, r) => sum + (r.rewardAmount ?? 0),
      0
    );

    return {
      totalReferrals,
      completedReferrals,
      totalEarned,
      referrals: referrals.slice(0, 50), // Limit to 50 most recent
    };
  },
});

/**
 * Create default missions (admin)
 */
export const createDefaultMissions = mutation({
  handler: async (ctx) => {
    const now = Date.now();

    const missions = [
      {
        title: "First Connection",
        description: "Connect to VPN for the first time",
        type: "sessionDuration",
        targetValue: 1,
        rewardAmount: 5,
        isPremiumOnly: false,
        isActive: true,
        createdAt: now,
      },
      {
        title: "Privacy Warrior",
        description: "Block 100 trackers",
        type: "trackersBlocked",
        targetValue: 100,
        rewardAmount: 10,
        isPremiumOnly: false,
        isActive: true,
        createdAt: now,
      },
      {
        title: "Ad-Free Explorer",
        description: "Block 50 ads",
        type: "adsBlocked",
        targetValue: 50,
        rewardAmount: 8,
        isPremiumOnly: false,
        isActive: true,
        createdAt: now,
      },
      {
        title: "VPN Marathon",
        description: "Stay connected for 60 minutes",
        type: "sessionDuration",
        targetValue: 60,
        rewardAmount: 15,
        isPremiumOnly: false,
        isActive: true,
        createdAt: now,
      },
      {
        title: "Premium Explorer",
        description: "Block 500 trackers (Premium only)",
        type: "trackersBlocked",
        targetValue: 500,
        rewardAmount: 50,
        isPremiumOnly: true,
        isActive: true,
        createdAt: now,
      },
    ];

    const ids = await Promise.all(
      missions.map((mission) => ctx.db.insert("missions", mission))
    );

    return {
      success: true,
      created: ids.length,
    };
  },
});
