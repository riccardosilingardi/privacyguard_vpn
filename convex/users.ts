import { v } from "convex/values";
import { mutation, query } from "./_generated/server";
import { Id } from "./_generated/dataModel";

/**
 * PrivacyGuard VPN - User Management Functions
 *
 * IMPORTANT: In production, use proper authentication:
 * - Convex Auth: https://docs.convex.dev/auth
 * - Clerk: https://clerk.com
 * - Auth0: https://auth0.com
 *
 * This is a simplified implementation for MVP.
 * Passwords should be hashed with bcrypt on the backend.
 */

// ==========================================
// QUERIES (Read Operations)
// ==========================================

/**
 * Get user by ID
 */
export const getUser = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) return null;

    // Don't expose password hash
    const { passwordHash, ...safeUser } = user;
    return safeUser;
  },
});

/**
 * Get user by email
 */
export const getUserByEmail = query({
  args: { email: v.string() },
  handler: async (ctx, args) => {
    const user = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    if (!user) return null;

    const { passwordHash, ...safeUser } = user;
    return safeUser;
  },
});

/**
 * Get user profile with stats
 */
export const getUserProfile = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) return null;

    // Get ICR balance
    const balance = await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .first();

    // Get total sessions
    const sessions = await ctx.db
      .query("vpn_sessions")
      .withIndex("by_user", (q) => q.eq("userId", args.userId))
      .collect();

    const totalSessions = sessions.length;
    const totalBytesTransferred = sessions.reduce(
      (sum, s) => sum + s.bytesIn + s.bytesOut,
      0
    );
    const totalTrackersBlocked = sessions.reduce(
      (sum, s) => sum + s.trackersBlocked,
      0
    );

    const { passwordHash, ...safeUser } = user;

    return {
      ...safeUser,
      icrBalance: balance?.balance ?? 0,
      lifetimeEarnings: balance?.lifetimeEarnings ?? 0,
      stats: {
        totalSessions,
        totalBytesTransferred,
        totalTrackersBlocked,
      },
    };
  },
});

/**
 * Check if email exists
 */
export const emailExists = query({
  args: { email: v.string() },
  handler: async (ctx, args) => {
    const user = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    return !!user;
  },
});

/**
 * Check if username exists
 */
export const usernameExists = query({
  args: { username: v.string() },
  handler: async (ctx, args) => {
    const user = await ctx.db
      .query("users")
      .withIndex("by_username", (q) => q.eq("username", args.username))
      .first();

    return !!user;
  },
});

// ==========================================
// MUTATIONS (Write Operations)
// ==========================================

/**
 * Register new user
 *
 * SECURITY NOTE: In production, hash password with bcrypt on backend:
 * const bcrypt = require('bcryptjs');
 * const passwordHash = await bcrypt.hash(password, 10);
 */
export const register = mutation({
  args: {
    email: v.string(),
    username: v.string(),
    password: v.string(), // In production, send already hashed
  },
  handler: async (ctx, args) => {
    // Check if email exists
    const existingEmail = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    if (existingEmail) {
      throw new Error("Email already exists");
    }

    // Check if username exists
    const existingUsername = await ctx.db
      .query("users")
      .withIndex("by_username", (q) => q.eq("username", args.username))
      .first();

    if (existingUsername) {
      throw new Error("Username already exists");
    }

    // TODO: Hash password properly in production
    const passwordHash = args.password; // TEMPORARY - should be hashed!

    const now = Date.now();

    // Create user
    const userId = await ctx.db.insert("users", {
      email: args.email,
      username: args.username,
      passwordHash,
      isPremium: false,
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
    });

    // Create ICR balance
    await ctx.db.insert("icr_balances", {
      userId,
      balance: 0,
      lifetimeEarnings: 0,
      pendingRewards: 0,
      updatedAt: now,
    });

    // Give welcome bonus
    await ctx.db.insert("icr_transactions", {
      userId,
      type: "bonus",
      amount: 10, // Welcome bonus: 10 ICR
      source: "welcome_bonus",
      description: "Welcome to PrivacyGuard VPN!",
      balanceAfter: 10,
      createdAt: now,
    });

    // Update balance
    await ctx.db.patch((await ctx.db
      .query("icr_balances")
      .withIndex("by_user", (q) => q.eq("userId", userId))
      .first())!._id, {
      balance: 10,
      lifetimeEarnings: 10,
      updatedAt: now,
    });

    const user = await ctx.db.get(userId);
    const { passwordHash: _, ...safeUser } = user!;

    return {
      user: safeUser,
      message: "Registration successful! You earned 10 ICR as welcome bonus.",
    };
  },
});

/**
 * Login user
 *
 * SECURITY NOTE: In production, verify password with bcrypt:
 * const isValid = await bcrypt.compare(password, user.passwordHash);
 */
export const login = mutation({
  args: {
    email: v.string(),
    password: v.string(),
  },
  handler: async (ctx, args) => {
    const user = await ctx.db
      .query("users")
      .withIndex("by_email", (q) => q.eq("email", args.email))
      .first();

    if (!user) {
      throw new Error("Invalid email or password");
    }

    // TODO: Use bcrypt.compare in production
    if (user.passwordHash !== args.password) {
      throw new Error("Invalid email or password");
    }

    // Update last login
    await ctx.db.patch(user._id, {
      lastLoginAt: Date.now(),
      updatedAt: Date.now(),
    });

    const { passwordHash, ...safeUser } = user;

    return {
      user: safeUser,
      message: "Login successful",
    };
  },
});

/**
 * Update user profile
 */
export const updateProfile = mutation({
  args: {
    userId: v.id("users"),
    username: v.optional(v.string()),
    avatarUrl: v.optional(v.string()),
  },
  handler: async (ctx, args) => {
    const { userId, ...updates } = args;

    // If username changed, check availability
    if (updates.username) {
      const existing = await ctx.db
        .query("users")
        .withIndex("by_username", (q) => q.eq("username", updates.username!))
        .first();

      if (existing && existing._id !== userId) {
        throw new Error("Username already taken");
      }
    }

    await ctx.db.patch(userId, {
      ...updates,
      updatedAt: Date.now(),
    });

    const user = await ctx.db.get(userId);
    const { passwordHash, ...safeUser } = user!;

    return safeUser;
  },
});

/**
 * Upgrade to premium
 */
export const upgradeToPremium = mutation({
  args: {
    userId: v.id("users"),
    durationMonths: v.number(), // 1, 6, 12
  },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) throw new Error("User not found");

    const now = Date.now();
    const currentExpiry = user.premiumExpiresAt ?? now;
    const expiresAt = Math.max(currentExpiry, now) +
                      args.durationMonths * 30 * 24 * 60 * 60 * 1000;

    await ctx.db.patch(args.userId, {
      isPremium: true,
      premiumExpiresAt: expiresAt,
      updatedAt: now,
    });

    return {
      success: true,
      expiresAt,
      message: `Premium activated for ${args.durationMonths} months`,
    };
  },
});

/**
 * Delete user account
 */
export const deleteAccount = mutation({
  args: {
    userId: v.id("users"),
    password: v.string(),
  },
  handler: async (ctx, args) => {
    const user = await ctx.db.get(args.userId);
    if (!user) throw new Error("User not found");

    // Verify password
    if (user.passwordHash !== args.password) {
      throw new Error("Invalid password");
    }

    // Delete user data
    await ctx.db.delete(args.userId);

    // Note: In production, you might want to:
    // - Soft delete instead of hard delete
    // - Cascade delete related data
    // - Archive data for audit purposes

    return {
      success: true,
      message: "Account deleted successfully",
    };
  },
});
