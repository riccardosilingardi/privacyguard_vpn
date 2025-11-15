import { v } from "convex/values";
import { mutation, query } from "./_generated/server";

/**
 * Log blocked tracker from browser extension
 */
export const logBlockedTracker = mutation({
  args: {
    userId: v.id("users"),
    sessionId: v.string(),
    domain: v.string(),
    category: v.string(),
    timestamp: v.number(),
    wasBlocked: v.boolean(),
  },
  handler: async (ctx, args) => {
    await ctx.db.insert("tracker_logs", {
      userId: args.userId,
      sessionId: null,
      domain: args.domain,
      category: args.category,
      timestamp: args.timestamp,
      wasBlocked: args.wasBlocked,
    });

    const today = new Date(args.timestamp).toISOString().split('T')[0];

    let score = await ctx.db
      .query("privacy_scores")
      .withIndex("by_user_date", (q) =>
        q.eq("userId", args.userId).eq("date", today)
      )
      .first();

    const now = Date.now();

    if (!score) {
      await ctx.db.insert("privacy_scores", {
        userId: args.userId,
        date: today,
        score: 50,
        trackersBlocked: 1,
        adsBlocked: 0,
        vpnUsageMinutes: 0,
        dataProtected: 0,
        updatedAt: now,
      });
    } else {
      const newTrackersBlocked = score.trackersBlocked + 1;
      const newScore = Math.min(100, score.score + 0.1);

      await ctx.db.patch(score._id, {
        trackersBlocked: newTrackersBlocked,
        score: newScore,
        updatedAt: now,
      });
    }

    return { success: true };
  },
});

/**
 * Get browser tracking stats
 */
export const getBrowserStats = query({
  args: {
    userId: v.id("users"),
    days: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const days = args.days ?? 7;
    const cutoffTime = Date.now() - days * 24 * 60 * 60 * 1000;

    const trackerLogs = await ctx.db
      .query("tracker_logs")
      .withIndex("by_user_timestamp", (q) =>
        q.eq("userId", args.userId).gte("timestamp", cutoffTime)
      )
      .filter((q) => q.eq(q.field("sessionId"), null))
      .collect();

    const totalBlocked = trackerLogs.filter((t) => t.wasBlocked).length;

    const byCategory = trackerLogs.reduce((acc, t) => {
      acc[t.category] = (acc[t.category] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    return {
      totalBlocked,
      byCategory,
      recent: trackerLogs.slice(0, 50),
    };
  },
});