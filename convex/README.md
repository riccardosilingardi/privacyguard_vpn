# PrivacyGuard VPN - Convex Backend

This directory contains the Convex backend implementation for PrivacyGuard VPN.

## 📁 Structure

```
convex/
├── schema.ts          # Database schema (tables, indexes)
├── users.ts           # User authentication & management
├── vpn.ts             # VPN servers & sessions
├── rewards.ts         # ICR rewards, missions, referrals
├── tsconfig.json      # TypeScript configuration
└── README.md          # This file
```

## 🚀 Setup

### 1. Install Convex CLI

```bash
npm install -g convex
```

### 2. Login to Convex

```bash
npx convex login
```

### 3. Link Project

```bash
npx convex dev
```

This will:
- Deploy your schema and functions
- Generate TypeScript types in `convex/_generated/`
- Watch for changes and auto-redeploy

### 4. Seed Data (Optional)

Add some test VPN servers:

```bash
npx convex run vpn:addServer \
  --name "Amsterdam, Netherlands" \
  --countryCode "NL" \
  --countryName "Netherlands" \
  --cityName "Amsterdam" \
  --ipAddress "185.232.23.45" \
  --port 51820 \
  --protocol "wireguard" \
  --publicKey "SERVER_PUBLIC_KEY_HERE" \
  --isPremium false \
  --maxUsers 100
```

Create default missions:

```bash
npx convex run rewards:createDefaultMissions
```

## 📊 Database Schema

### Users
- **users**: User accounts and authentication
- **icr_balances**: ICR token balances
- **icr_transactions**: ICR transaction history

### VPN
- **vpn_servers**: Available VPN server locations
- **vpn_sessions**: VPN connection sessions and stats
- **vpn_user_keys**: WireGuard keypairs for users

### Rewards
- **missions**: Available missions
- **user_missions**: User progress on missions
- **referrals**: Referral tracking

### Privacy
- **tracker_logs**: Blocked trackers log
- **privacy_scores**: Daily privacy scores

## 🔧 Functions

### Authentication (users.ts)

**Queries:**
- `getUser(userId)` - Get user by ID
- `getUserByEmail(email)` - Get user by email
- `getUserProfile(userId)` - Get user profile with stats
- `emailExists(email)` - Check if email is taken
- `usernameExists(username)` - Check if username is taken

**Mutations:**
- `register(email, username, password)` - Register new user
- `login(email, password)` - Login user
- `updateProfile(userId, ...)` - Update user profile
- `upgradeToPremium(userId, durationMonths)` - Upgrade to premium
- `deleteAccount(userId, password)` - Delete user account

### VPN (vpn.ts)

**Queries:**
- `getServers(countryCode?, isPremiumUser?)` - Get available servers
- `getServer(serverId)` - Get server by ID
- `getBestServer(countryCode?, isPremiumUser?)` - Get optimal server
- `getUserSessions(userId, limit?)` - Get user's VPN sessions
- `getActiveSession(userId)` - Get active session
- `getVpnConfig(userId, serverId)` - Get WireGuard config

**Mutations:**
- `startSession(userId, serverId)` - Start VPN session
- `endSession(sessionId, bytesIn, bytesOut, ...)` - End session and calculate rewards
- `updateSessionStats(sessionId, ...)` - Update session stats
- `addServer(...)` - Add VPN server (admin)
- `updateServerStats(serverId, ...)` - Update server stats

### Rewards (rewards.ts)

**Queries:**
- `getBalance(userId)` - Get ICR balance
- `getTransactions(userId, limit?, type?)` - Get transaction history
- `getMissions(userId, isPremium?)` - Get available missions
- `getUserMissions(userId, status?)` - Get user's missions
- `getLeaderboard(limit?, timeframe?)` - Get top earners
- `getReferralStats(userId)` - Get referral stats

**Mutations:**
- `startMission(userId, missionId)` - Start a mission
- `claimMissionReward(userMissionId)` - Claim mission reward
- `withdrawToWallet(userId, amount, walletAddress)` - Withdraw ICR
- `createReferralCode(userId)` - Create referral code
- `applyReferralCode(userId, referralCode)` - Apply referral code
- `createDefaultMissions()` - Create default missions (admin)

## 🔐 Security Notes

### Current Implementation (MVP)

⚠️ **DEVELOPMENT ONLY** - Current auth is simplified:
- Passwords stored as plain text (INSECURE!)
- No session management
- No rate limiting

### Production Requirements

Before production, implement:

1. **Password Hashing**
```typescript
import bcrypt from 'bcryptjs';
const passwordHash = await bcrypt.hash(password, 10);
const isValid = await bcrypt.compare(password, user.passwordHash);
```

2. **Proper Authentication**
- Use Convex Auth: https://docs.convex.dev/auth
- Or integrate Clerk: https://clerk.com
- Or use Auth0: https://auth0.com

3. **Session Management**
- JWT tokens
- Refresh tokens
- Token expiration

4. **Rate Limiting**
- Limit login attempts
- Protect against brute force
- API rate limits

5. **Input Validation**
- Validate all inputs
- Sanitize user data
- Prevent SQL injection (Convex is safe by default)

6. **Encryption**
- Encrypt sensitive data at rest
- Use HTTPS for all requests
- Encrypt VPN private keys

## 🧪 Testing

### Test User Registration

```bash
npx convex run users:register \
  --email "test@example.com" \
  --username "testuser" \
  --password "password123"
```

### Test Login

```bash
npx convex run users:login \
  --email "test@example.com" \
  --password "password123"
```

### Test VPN Session

```bash
# Start session
npx convex run vpn:startSession \
  --userId "USER_ID" \
  --serverId "SERVER_ID"

# End session
npx convex run vpn:endSession \
  --sessionId "SESSION_ID" \
  --bytesIn 1048576 \
  --bytesOut 524288 \
  --trackersBlocked 42 \
  --adsBlocked 15
```

## 📈 Monitoring

### View Data

Dashboard: https://dashboard.convex.dev/t/riccardo-silingardiseligardi/insight-ece3e/bold-curlew-524/data

### Logs

```bash
npx convex logs
```

### Database Console

```bash
npx convex console
```

## 🚀 Deployment

### Development

```bash
npx convex dev
```

### Production

```bash
npx convex deploy
```

## 🔄 Migration Guide

If you need to update the schema:

1. Update `schema.ts`
2. Run `npx convex dev` (auto-deploys)
3. Convex handles migrations automatically

For complex migrations:
1. Create migration function
2. Run migration
3. Update schema
4. Deploy

## 📝 Notes

- **Convex is serverless** - No server management needed
- **Real-time by default** - All queries are reactive
- **Type-safe** - Full TypeScript support
- **Free tier** - 1M monthly queries, 1GB storage
- **Auto-scaling** - Handles traffic spikes automatically

## 🆘 Troubleshooting

### "Module not found"

```bash
npx convex dev
```

This regenerates `_generated/` types.

### "Unauthorized"

```bash
npx convex login
```

Re-authenticate with Convex.

### "Schema mismatch"

```bash
npx convex dev --clear
```

Clears cache and redeploys.

## 📚 Resources

- [Convex Docs](https://docs.convex.dev)
- [Convex Dashboard](https://dashboard.convex.dev)
- [Convex Examples](https://github.com/get-convex/convex-examples)
- [Convex Discord](https://convex.dev/community)

---

**Status**: ✅ Ready for development
**Next**: Deploy with `npx convex dev`
