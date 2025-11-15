import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

/**
 * PrivacyGuard VPN - Convex Database Schema
 *
 * This schema defines all database tables for the app:
 * - users: User accounts and authentication
 * - vpn_servers: Available VPN server locations
 * - vpn_sessions: VPN connection sessions and stats
 * - icr_balances: User ICR token balances
 * - icr_transactions: ICR earning/spending history
 * - missions: Available missions for users
 * - user_missions: User progress on missions
 * - tracker_logs: Blocked trackers log
 */

export default defineSchema({
  // ==========================================
  // USERS & AUTHENTICATION
  // ==========================================

  users: defineTable({
    email: v.string(),
    username: v.string(),
    passwordHash: v.string(), // bcrypt hashed
    avatarUrl: v.optional(v.string()),
    isPremium: v.boolean(),
    premiumExpiresAt: v.optional(v.number()), // timestamp
    createdAt: v.number(), // timestamp
    updatedAt: v.number(), // timestamp
    lastLoginAt: v.optional(v.number()), // timestamp
  })
    .index("by_email", ["email"])
    .index("by_username", ["username"]),

  // ==========================================
  // VPN SERVERS
  // ==========================================

  vpn_servers: defineTable({
    name: v.string(), // "Amsterdam, Netherlands"
    countryCode: v.string(), // "NL"
    countryName: v.string(), // "Netherlands"
    cityName: v.string(), // "Amsterdam"
    ipAddress: v.string(), // "185.232.23.45"
    port: v.number(), // 51820
    protocol: v.string(), // "wireguard", "openvpn", "ikev2"
    publicKey: v.string(), // WireGuard server public key
    load: v.number(), // 0-100 (percentage)
    latency: v.number(), // milliseconds
    isPremium: v.boolean(),
    status: v.string(), // "active", "maintenance", "offline"
    maxUsers: v.number(),
    currentUsers: v.number(),
    createdAt: v.number(),
    updatedAt: v.number(),
  })
    .index("by_country", ["countryCode"])
    .index("by_status", ["status"])
    .index("by_premium", ["isPremium"]),

  // ==========================================
  // VPN SESSIONS
  // ==========================================

  vpn_sessions: defineTable({
    userId: v.id("users"),
    serverId: v.id("vpn_servers"),
    startedAt: v.number(), // timestamp
    endedAt: v.optional(v.number()), // timestamp
    bytesIn: v.number(),
    bytesOut: v.number(),
    trackersBlocked: v.number(),
    adsBlocked: v.number(),
    icrEarned: v.number(),
    status: v.string(), // "active", "completed", "error"
  })
    .index("by_user", ["userId"])
    .index("by_server", ["serverId"])
    .index("by_user_active", ["userId", "status"])
    .index("by_started_at", ["startedAt"]),

  // VPN user keys (for WireGuard)
  vpn_user_keys: defineTable({
    userId: v.id("users"),
    serverId: v.id("vpn_servers"),
    privateKey: v.string(), // Client private key (encrypted at rest)
    publicKey: v.string(), // Client public key
    assignedIP: v.string(), // e.g., "10.8.0.45/24"
    createdAt: v.number(),
    lastUsedAt: v.optional(v.number()),
  })
    .index("by_user", ["userId"])
    .index("by_user_server", ["userId", "serverId"]),

  // ==========================================
  // ICR REWARDS & ECONOMY
  // ==========================================

  icr_balances: defineTable({
    userId: v.id("users"),
    balance: v.number(), // Current balance
    lifetimeEarnings: v.number(), // Total ever earned
    pendingRewards: v.number(), // Pending confirmation
    walletAddress: v.optional(v.string()), // Blockchain wallet
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"]),

  icr_transactions: defineTable({
    userId: v.id("users"),
    type: v.string(), // "earn", "spend", "withdraw", "bonus"
    amount: v.number(), // Positive or negative
    source: v.string(), // "vpn_session", "mission", "referral", "purchase"
    sourceId: v.optional(v.string()), // ID of related entity
    description: v.string(),
    balanceAfter: v.number(),
    createdAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_user_created", ["userId", "createdAt"])
    .index("by_type", ["type"]),

  // ==========================================
  // MISSIONS & GAMIFICATION
  // ==========================================

  missions: defineTable({
    title: v.string(),
    description: v.string(),
    type: v.string(), // "trackersBlocked", "sessionDuration", "adsBlocked", "dailyStreak", "referral"
    targetValue: v.number(),
    rewardAmount: v.number(), // ICR reward
    duration: v.optional(v.number()), // Duration in seconds (for timed missions)
    isPremiumOnly: v.boolean(),
    isActive: v.boolean(),
    startDate: v.optional(v.number()),
    endDate: v.optional(v.number()),
    createdAt: v.number(),
  })
    .index("by_active", ["isActive"])
    .index("by_type", ["type"]),

  user_missions: defineTable({
    userId: v.id("users"),
    missionId: v.id("missions"),
    progress: v.number(),
    status: v.string(), // "active", "completed", "expired"
    startedAt: v.number(),
    completedAt: v.optional(v.number()),
    expiresAt: v.optional(v.number()),
  })
    .index("by_user", ["userId"])
    .index("by_user_status", ["userId", "status"])
    .index("by_mission", ["missionId"]),

  // ==========================================
  // PRIVACY & TRACKING
  // ==========================================

  tracker_logs: defineTable({
    userId: v.id("users"),
    sessionId: v.union(v.id("vpn_sessions"), v.null()), // VPN sessions or null for browser,
    domain: v.string(), // "tracker.example.com"
    category: v.string(), // "advertising", "analytics", "social", "unknown"
    timestamp: v.number(),
    wasBlocked: v.boolean(),
  })
    .index("by_user", ["userId"])
    .index("by_session", ["sessionId"])
    .index("by_domain", ["domain"])
    .index("by_user_timestamp", ["userId", "timestamp"]),

  privacy_scores: defineTable({
    userId: v.id("users"),
    date: v.string(), // YYYY-MM-DD
    score: v.number(), // 0-100
    trackersBlocked: v.number(),
    adsBlocked: v.number(),
    vpnUsageMinutes: v.number(),
    dataProtected: v.number(), // bytes
    updatedAt: v.number(),
  })
    .index("by_user", ["userId"])
    .index("by_user_date", ["userId", "date"]),

  // ==========================================
  // REFERRALS & SOCIAL
  // ==========================================

  referrals: defineTable({
    referrerId: v.id("users"),
    referredUserId: v.id("users"),
    referralCode: v.string(),
    status: v.string(), // "pending", "completed", "rewarded"
    rewardAmount: v.number(),
    createdAt: v.number(),
    completedAt: v.optional(v.number()),
  })
    .index("by_referrer", ["referrerId"])
    .index("by_code", ["referralCode"])
    .index("by_status", ["status"]),

  // ==========================================
  // ADMIN & MONITORING
  // ==========================================

  system_config: defineTable({
    key: v.string(),
    value: v.string(),
    updatedAt: v.number(),
  })
    .index("by_key", ["key"]),
});
