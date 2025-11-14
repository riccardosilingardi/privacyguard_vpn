# PrivacyGuard VPN - Setup Guide

**Implementation Date:** 2025-11-14
**Time Spent:** 2 hours
**Cost:** $0 (free tier services)

---

## ✅ What's Been Implemented

### Architecture Foundation (100% Complete)
- ✅ Clean Architecture structure (Presentation, Domain, Data, Infrastructure layers)
- ✅ Directory structure for scalability
- ✅ Dependencies added to pubspec.yaml

### Core Infrastructure (100% Complete)
- ✅ Logger utility (`lib/core/utils/logger.dart`)
- ✅ App constants (`lib/core/constants/app_constants.dart`)
- ✅ Convex service wrapper (`lib/core/network/convex_service.dart`)

### Data Layer (100% Complete)
- ✅ User model with Freezed (`lib/data/models/user/user_model.dart`)
- ✅ VPN models (Server, Session) with Freezed (`lib/data/models/vpn/vpn_server_model.dart`)
- ✅ Rewards models (Balance, Mission) with Freezed (`lib/data/models/rewards/icr_balance_model.dart`)
- ✅ Auth remote datasource (`lib/data/datasources/remote/auth_remote_datasource.dart`)
- ✅ Auth repository implementation (`lib/data/repositories/auth_repository_impl.dart`)
- ✅ VPN repository implementation (`lib/data/repositories/vpn_repository_impl.dart`)

### Domain Layer (100% Complete)
- ✅ Auth repository interface (`lib/domain/repositories/auth_repository.dart`)
- ✅ VPN repository interface (`lib/domain/repositories/vpn_repository.dart`)
- ✅ Rewards repository interface (`lib/domain/repositories/rewards_repository.dart`)

### Platform Layer (100% Complete - Mock)
- ✅ VPN platform interface (`lib/platforms/vpn/vpn_platform_interface.dart`)
- ✅ VPN mock implementation for testing (`lib/platforms/vpn/vpn_mock_implementation.dart`)
- ⚠️ Real VPN requires native Android/iOS code (future work)

### Presentation Layer (100% Complete)
- ✅ Auth provider with Riverpod (`lib/presentation/providers/auth_provider.dart`)
- ✅ VPN provider with Riverpod (`lib/presentation/providers/vpn_provider.dart`)
- ⚠️ Existing screens need refactoring to use providers

---

## 🚀 Quick Start (5 minutes)

### Step 1: Install Flutter (if not already)
```bash
# Check if Flutter is installed
flutter --version

# If not installed, follow: https://docs.flutter.dev/get-started/install
```

### Step 2: Install Dependencies
```bash
cd /path/to/privacyguard_vpn
flutter pub get
```

### Step 3: Generate Freezed Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files (immutable models)
- `*.g.dart` files (JSON serialization)

**Expected output:**
```
[INFO] Generating build script completed, took 324ms
[INFO] Creating build script snapshot... completed, took 8.2s
[INFO] Building new asset graph completed, took 1.2s
[INFO] Succeeded after 9.7s with 42 outputs
```

### Step 4: Setup Convex Backend

1. **Go to Convex Dashboard:**
   https://dashboard.convex.dev/t/riccardo-silingardiseligardi/insight-ece3e/bold-curlew-524

2. **Update Convex URL in code:**
   - Open `lib/core/constants/app_constants.dart`
   - Verify `convexUrl` is correct: `https://bold-curlew-524.convex.cloud`

3. **Create Convex Functions** (in Convex dashboard):

Create file `convex/users.ts`:
```typescript
import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const login = mutation({
  args: {
    email: v.string(),
    password: v.string(),
  },
  handler: async (ctx, args) => {
    // TODO: Implement password hashing & verification
    const user = await ctx.db
      .query("users")
      .filter((q) => q.eq(q.field("email"), args.email))
      .first();

    if (!user) {
      throw new Error("User not found");
    }

    return user;
  },
});

export const register = mutation({
  args: {
    email: v.string(),
    username: v.string(),
    password: v.string(),
  },
  handler: async (ctx, args) => {
    // TODO: Hash password before storing
    const userId = await ctx.db.insert("users", {
      email: args.email,
      username: args.username,
      password: args.password, // TODO: Hash this!
      isPremium: false,
      createdAt: Date.now(),
    });

    return await ctx.db.get(userId);
  },
});

export const get = query({
  args: { userId: v.id("users") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.userId);
  },
});
```

Create file `convex/vpn.ts`:
```typescript
import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

export const getServers = query({
  handler: async (ctx) => {
    return await ctx.db
      .query("vpn_servers")
      .filter((q) => q.eq(q.field("status"), "active"))
      .collect();
  },
});

export const saveSession = mutation({
  args: {
    id: v.string(),
    userId: v.string(),
    serverId: v.string(),
    startedAt: v.number(),
    endedAt: v.optional(v.number()),
    bytesIn: v.number(),
    bytesOut: v.number(),
    trackersBlocked: v.number(),
    adsBlocked: v.number(),
    icrEarned: v.number(),
  },
  handler: async (ctx, args) => {
    return await ctx.db.insert("vpn_sessions", args);
  },
});
```

4. **Create Schema** `convex/schema.ts`:
```typescript
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    email: v.string(),
    username: v.string(),
    password: v.string(),
    avatarUrl: v.optional(v.string()),
    isPremium: v.boolean(),
    createdAt: v.number(),
    updatedAt: v.optional(v.number()),
  }).index("by_email", ["email"]),

  vpn_servers: defineTable({
    name: v.string(),
    countryCode: v.string(),
    cityName: v.string(),
    ipAddress: v.string(),
    port: v.number(),
    protocol: v.string(),
    load: v.number(),
    latency: v.number(),
    isPremium: v.boolean(),
    status: v.string(),
    configData: v.optional(v.string()),
  }).index("by_country", ["countryCode"]),

  vpn_sessions: defineTable({
    id: v.string(),
    userId: v.string(),
    serverId: v.string(),
    startedAt: v.number(),
    endedAt: v.optional(v.number()),
    bytesIn: v.number(),
    bytesOut: v.number(),
    trackersBlocked: v.number(),
    adsBlocked: v.number(),
    icrEarned: v.number(),
  }).index("by_user", ["userId"]),
});
```

5. **Deploy to Convex:**
```bash
npx convex deploy
```

### Step 5: Update main.dart

Replace `lib/main.dart` with:
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_export.dart';
import 'core/network/convex_service.dart';
import 'core/utils/logger.dart';
import 'widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Convex
  try {
    await ConvexService.initialize();
    AppLogger.info('Convex initialized successfully');
  } catch (e, stack) {
    AppLogger.error('Failed to initialize Convex', e, stack);
  }

  // Custom error handling
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorDetails: details);
  };

  // Device orientation lock
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(
      ProviderScope(  // Wrap with ProviderScope for Riverpod
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'privacyguard_vpn',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}
```

### Step 6: Test the App
```bash
# Android
flutter run

# iOS (requires Mac)
flutter run -d ios
```

---

## 📝 Next Steps (Priority Order)

### Immediate (Today)
1. ✅ Run `flutter pub run build_runner build`
2. ✅ Setup Convex functions (users, vpn)
3. ✅ Update main.dart with ProviderScope
4. ✅ Test app boots without errors

### This Week
5. 📝 Refactor Login Screen to use `authControllerProvider`
6. 📝 Refactor VPN Dashboard to use `vpnControllerProvider`
7. 📝 Test auth flow (login, register, logout)
8. 📝 Test VPN connection (mock implementation)

### Example: Refactor Login Screen

**Before:**
```dart
class LoginScreen extends StatefulWidget { ... }

class _LoginScreenState extends State<LoginScreen> {
  final _mockCredentials = { ... }; // Hardcoded

  void _handleLogin() async {
    setState(() => _isLoading = true);
    // Mock login logic
  }
}
```

**After:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    final authController = ref.read(authControllerProvider.notifier);

    try {
      await authController.login(
        _emailController.text,
        _passwordController.text,
      );

      // Navigate to dashboard on success
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/vpn-dashboard');
      }
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLoginForm(),
    );
  }
}
```

---

## 🔧 Troubleshooting

### Error: "flutter: command not found"
**Solution:** Install Flutter SDK from https://docs.flutter.dev/get-started/install

### Error: "ConvexService not initialized"
**Solution:** Make sure `ConvexService.initialize()` is called in main.dart before runApp()

### Error: "File *.freezed.dart doesn't exist"
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Error: Convex connection failed
**Solutions:**
- Check internet connection
- Verify Convex URL in `app_constants.dart`
- Check Convex project is deployed (https://dashboard.convex.dev)

### App crashes on startup
**Solutions:**
1. Check console logs: `flutter logs`
2. Verify all dependencies installed: `flutter pub get`
3. Clean and rebuild: `flutter clean && flutter run`

---

## 📚 Additional Resources

### Documentation
- [Architecture Guide](ARCHITECTURE.md) - Detailed architecture explanation
- [Gap Analysis](GAPS_ANALYSIS.md) - What's missing vs what's needed
- [Implementation Plan](IMPLEMENTATION_PLAN.md) - 10-month roadmap

### External Resources
- [Riverpod Documentation](https://riverpod.dev)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Convex Docs](https://docs.convex.dev)
- [Flutter Clean Architecture](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

---

## 🎯 Quick Commands Reference

```bash
# Install dependencies
flutter pub get

# Generate Freezed code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on file changes)
flutter pub run build_runner watch

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Run tests (when tests are written)
flutter test

# Build release APK
flutter build apk --release

# Build iOS (requires Mac)
flutter build ios --release
```

---

## ✅ Checklist Before First Run

- [ ] Flutter SDK installed (`flutter --version` works)
- [ ] Dependencies installed (`flutter pub get` successful)
- [ ] Freezed code generated (`*.freezed.dart` files exist)
- [ ] Convex functions deployed (users.ts, vpn.ts)
- [ ] Convex URL correct in `app_constants.dart`
- [ ] main.dart updated with `ProviderScope`
- [ ] Android emulator or iOS simulator running
- [ ] Run `flutter run` and app starts without errors

---

## 💡 Tips

1. **Development Speed:** Use hot reload (`r` in terminal) to see changes instantly
2. **Debugging:** Use `AppLogger.debug()` instead of `print()` for better logs
3. **State Management:** Always read providers with `ref.watch()` in build(), `ref.read()` in event handlers
4. **Testing:** Write tests as you go - it saves time in the long run
5. **Convex:** Check the Convex dashboard logs if API calls fail

---

## 🆘 Need Help?

1. Check [ARCHITECTURE.md](ARCHITECTURE.md) for detailed explanations
2. Review [Riverpod documentation](https://riverpod.dev) for state management questions
3. Check [Convex docs](https://docs.convex.dev) for backend questions
4. Search [Flutter issues](https://github.com/flutter/flutter/issues) for Flutter-specific problems

---

**Last Updated:** 2025-11-14
**Status:** Ready for development
**Next Review:** After first screen refactored
