# PrivacyGuard VPN - PIANO DI IMPLEMENTAZIONE PRODUCTION READY

**Versione:** 1.0
**Data:** 2025-11-14
**Strategia Scelta:** Phased Approach (Raccomandato)
**Timeline Totale:** 10 mesi
**Team Size:** 3-5 developers

---

## INDICE

1. [Architettura Tecnica](#architettura-tecnica)
2. [Technology Stack](#technology-stack)
3. [Roadmap Implementazione](#roadmap-implementazione)
4. [Fase 1: Foundation (Mesi 1-2)](#fase-1-foundation)
5. [Fase 2: VPN Core (Mesi 3-4)](#fase-2-vpn-core)
6. [Fase 3: Security & Backend (Mesi 5-6)](#fase-3-security-backend)
7. [Fase 4: Tracker Blocking (Mese 7)](#fase-4-tracker-blocking)
8. [Fase 5: ICR Tokenomics (Mesi 8-9)](#fase-5-icr-tokenomics)
9. [Fase 6: Launch Prep (Mese 10)](#fase-6-launch-prep)
10. [Specifiche Tecniche Dettagliate](#specifiche-tecniche)
11. [Team & Risorse](#team-risorse)

---

## ARCHITETTURA TECNICA

### Architecture Pattern: Clean Architecture + MVVM

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Screens    │  │   Widgets    │  │  ViewModels  │      │
│  │  (Current)   │  │  (Current)   │  │    (NEW)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Use Cases   │  │  Entities/   │  │ Repositories │      │
│  │    (NEW)     │  │   Models     │  │ (Interfaces) │      │
│  │              │  │    (NEW)     │  │    (NEW)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                        DATA LAYER                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Repositories │  │ Data Sources │  │   Services   │      │
│  │   (Impl)     │  │ Remote/Local │  │ API/Storage  │      │
│  │    (NEW)     │  │    (NEW)     │  │    (NEW)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Platform VPN │  │  Blockchain  │  │   Network    │      │
│  │   Channels   │  │    Web3      │  │     Dio      │      │
│  │    (NEW)     │  │    (NEW)     │  │    (NEW)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Directory Structure (Target)

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── error_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── interceptors/
│   │   └── network_info.dart
│   ├── theme/
│   │   └── app_theme.dart (existing)
│   ├── utils/
│   │   ├── logger.dart
│   │   ├── validators.dart
│   │   └── extensions.dart
│   └── app_export.dart (existing)
│
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── auth_remote_datasource.dart
│   │   │   ├── vpn_remote_datasource.dart
│   │   │   ├── rewards_remote_datasource.dart
│   │   │   └── analytics_remote_datasource.dart
│   │   └── local/
│   │       ├── user_local_datasource.dart
│   │       ├── vpn_local_datasource.dart
│   │       └── cache_datasource.dart
│   ├── models/
│   │   ├── user/
│   │   │   ├── user_model.dart
│   │   │   ├── user_profile_model.dart
│   │   │   └── user_settings_model.dart
│   │   ├── vpn/
│   │   │   ├── vpn_server_model.dart
│   │   │   ├── vpn_session_model.dart
│   │   │   ├── vpn_connection_model.dart
│   │   │   └── vpn_stats_model.dart
│   │   ├── rewards/
│   │   │   ├── icr_balance_model.dart
│   │   │   ├── mission_model.dart
│   │   │   ├── achievement_model.dart
│   │   │   └── payout_model.dart
│   │   └── analytics/
│   │       ├── privacy_score_model.dart
│   │       ├── tracker_data_model.dart
│   │       └── threat_category_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── vpn_repository_impl.dart
│       ├── rewards_repository_impl.dart
│       └── analytics_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── user/
│   │   ├── vpn/
│   │   ├── rewards/
│   │   └── analytics/
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── vpn_repository.dart
│   │   ├── rewards_repository.dart
│   │   └── analytics_repository.dart
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── register_usecase.dart
│       │   └── logout_usecase.dart
│       ├── vpn/
│       │   ├── connect_vpn_usecase.dart
│       │   ├── disconnect_vpn_usecase.dart
│       │   ├── get_servers_usecase.dart
│       │   └── get_session_stats_usecase.dart
│       ├── rewards/
│       │   ├── get_balance_usecase.dart
│       │   ├── get_missions_usecase.dart
│       │   └── claim_reward_usecase.dart
│       └── analytics/
│           ├── get_privacy_score_usecase.dart
│           └── get_tracker_stats_usecase.dart
│
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── vpn_provider.dart
│   │   ├── rewards_provider.dart
│   │   └── analytics_provider.dart
│   ├── splash_screen/ (existing - refactor)
│   ├── login_screen/ (existing - refactor)
│   ├── privacy_onboarding/ (existing - refactor)
│   ├── vpn_dashboard/ (existing - refactor)
│   ├── privacy_analytics/ (existing - refactor)
│   ├── icr_rewards_hub/ (existing - refactor)
│   └── user_profile/ (existing - refactor)
│
├── routes/
│   └── app_routes.dart (existing)
│
├── widgets/
│   └── (existing widgets)
│
├── platforms/
│   ├── vpn/
│   │   ├── vpn_platform_interface.dart
│   │   ├── vpn_method_channel.dart
│   │   ├── android_vpn_handler.dart
│   │   └── ios_vpn_handler.dart
│   ├── blockchain/
│   │   ├── web3_client.dart
│   │   ├── smart_contract_interface.dart
│   │   └── wallet_connector.dart
│   └── tracker_blocking/
│       ├── dns_filter.dart
│       ├── filter_list_manager.dart
│       └── threat_detector.dart
│
└── main.dart (existing - refactor)

android/
├── app/src/main/kotlin/com/privacyguard/vpn/
│   ├── MainActivity.kt (upgrade)
│   ├── VpnService.kt (NEW)
│   ├── VpnMethodChannel.kt (NEW)
│   └── utils/
│       ├── OpenVPNManager.kt (NEW)
│       └── WireGuardManager.kt (NEW)

ios/
├── Runner/
│   ├── AppDelegate.swift (upgrade)
│   ├── VpnService.swift (NEW)
│   ├── VpnMethodChannel.swift (NEW)
│   └── Utils/
│       ├── OpenVPNManager.swift (NEW)
│       └── WireGuardManager.swift (NEW)

test/
├── unit/
│   ├── data/
│   ├── domain/
│   └── presentation/
├── widget/
│   └── screens/
└── integration/
    └── flows/
```

---

## TECHNOLOGY STACK

### Frontend (Flutter)

#### State Management
```yaml
flutter_riverpod: ^2.5.1  # State management
riverpod_annotation: ^2.3.5
riverpod_generator: ^2.4.0
```

#### Networking
```yaml
dio: ^5.4.0  # Already installed
retrofit: ^4.1.0  # Type-safe REST client
retrofit_generator: ^8.1.0
```

#### Storage
```yaml
shared_preferences: ^2.2.2  # Already installed
flutter_secure_storage: ^9.0.0  # Secure storage
hive: ^2.2.3  # Local database
hive_flutter: ^1.1.0
```

#### VPN Integration
```yaml
# Android
dependencies:
  - OpenVPN for Android (de.blinkt.openvpn)
  - WireGuard Android

# iOS
dependencies:
  - NetworkExtension framework
  - OpenVPNAdapter pod
  - WireGuardKit pod
```

#### Blockchain/Web3
```yaml
web3dart: ^2.7.3  # Ethereum integration
wallet_connect_dart: ^0.0.11  # WalletConnect
http: ^1.2.0
```

#### Error Handling & Logging
```yaml
logger: ^2.0.2+1  # Logging
sentry_flutter: ^7.18.0  # Error tracking
```

#### Testing
```yaml
mockito: ^5.4.4
build_runner: ^2.4.8
flutter_test: sdk
integration_test: sdk
```

#### Existing Dependencies (Keep)
```yaml
sizer: ^2.0.15
flutter_svg: ^2.0.9
google_fonts: ^6.1.0
cached_network_image: ^3.3.1
connectivity_plus: ^6.1.4
fluttertoast: ^8.2.4
fl_chart: ^0.65.0
```

### Backend Stack (Raccomandazioni)

#### Primary Backend: Node.js + Express
```javascript
// Core
express: ^4.18.2
typescript: ^5.3.3

// Database
prisma: ^5.8.0  // ORM
postgresql: ^15.x  // Database

// Authentication
jsonwebtoken: ^9.0.2
bcrypt: ^5.1.1
passport: ^0.7.0

// VPN Server Management
node-openvpn: ^2.0.0
wireguard: latest

// Blockchain
web3: ^4.3.0
ethers: ^6.10.0

// Others
redis: ^4.6.12  // Caching
socket.io: ^4.6.1  // Real-time
```

#### Alternative: Supabase (Faster MVP)
- PostgreSQL database
- Built-in auth (JWT)
- Real-time subscriptions
- Storage
- Edge functions

**Pros:** Faster development, less infrastructure
**Cons:** Vendor lock-in, less flexibility

**Recommendation:** Start with Supabase for MVP, migrate to custom backend later if needed

### Infrastructure

#### Cloud Provider: AWS (Raccomandato)
```
- EC2: VPN servers (multiple regions)
- RDS: PostgreSQL database
- ElastiCache: Redis caching
- S3: Storage
- CloudFront: CDN
- Route53: DNS
- ECS/EKS: Container orchestration
- Lambda: Serverless functions
```

#### Alternative: DigitalOcean (Budget-Friendly)
- Droplets: VPN servers
- Managed Databases
- Spaces: Storage
- Load Balancers

#### CI/CD
```
- GitHub Actions (CI/CD)
- Fastlane (Mobile deployment)
- Docker (Containerization)
- Terraform (Infrastructure as Code)
```

#### Monitoring & Analytics
```
- Sentry: Error tracking
- Firebase Analytics: User analytics
- Grafana + Prometheus: Server monitoring
- Mixpanel/Amplitude: Product analytics
```

### Blockchain Infrastructure

#### Network: Polygon (Raccomandato per MVP)
**Why Polygon:**
- Low transaction fees (~$0.01)
- Fast confirmations (~2 sec)
- Ethereum-compatible
- Good ecosystem

**Alternative:** Ethereum L2 (Arbitrum, Optimism)

#### Smart Contracts
```solidity
// ICRToken.sol - ERC20 token
// RewardDistributor.sol - Reward logic
// MissionManager.sol - Mission completion
// PayoutManager.sol - Token payouts
```

#### Development Tools
```
- Hardhat: Smart contract development
- OpenZeppelin: Security libraries
- Etherscan: Block explorer
- Alchemy/Infura: Node provider
```

---

## ROADMAP IMPLEMENTAZIONE

### Overview Timeline

```
Month 1-2:  Foundation (Architecture, Models, State Management)
Month 3-4:  VPN Core (Native integration, Platform channels)
Month 5-6:  Security & Backend (API, Auth, Encryption)
Month 7:    Tracker Blocking (DNS filter, Block lists)
Month 8-9:  ICR Tokenomics (Blockchain, Smart contracts)
Month 10:   Launch Prep (Testing, Compliance, Deployment)
```

### Milestones

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| M1: Architecture Setup | Week 4 | 🔴 Not Started |
| M2: VPN POC Android | Week 8 | 🔴 Not Started |
| M3: VPN POC iOS | Week 12 | 🔴 Not Started |
| M4: Backend API v1 | Week 16 | 🔴 Not Started |
| M5: Alpha Release | Week 20 | 🔴 Not Started |
| M6: Tracker Blocking | Week 24 | 🔴 Not Started |
| M7: ICR Integration | Week 32 | 🔴 Not Started |
| M8: Beta Release | Week 36 | 🔴 Not Started |
| M9: Production Launch | Week 40 | 🔴 Not Started |

---

## FASE 1: FOUNDATION (Mesi 1-2)

### Obiettivo: Setup architettura, models, state management

### Week 1-2: Project Setup & Architecture

#### Tasks

1. **Environment Configuration**
   ```bash
   # Setup .env files
   .env.development
   .env.staging
   .env.production

   # Install flutter_dotenv
   flutter pub add flutter_dotenv

   # Configure build flavors (Android/iOS)
   # - Development: com.privacyguard.vpn.dev
   # - Staging: com.privacyguard.vpn.staging
   # - Production: com.privacyguard.vpn
   ```

2. **Dependencies Installation**
   ```yaml
   # pubspec.yaml additions
   dependencies:
     flutter_riverpod: ^2.5.1
     riverpod_annotation: ^2.3.5
     retrofit: ^4.1.0
     flutter_secure_storage: ^9.0.0
     hive: ^2.2.3
     hive_flutter: ^1.1.0
     logger: ^2.0.2+1
     sentry_flutter: ^7.18.0
     freezed_annotation: ^2.4.1
     json_annotation: ^4.8.1

   dev_dependencies:
     build_runner: ^2.4.8
     retrofit_generator: ^8.1.0
     riverpod_generator: ^2.4.0
     freezed: ^2.4.7
     json_serializable: ^6.7.1
     mockito: ^5.4.4
   ```

3. **Core Infrastructure**
   - Create core/ directory structure
   - Setup Dio client with interceptors
   - Configure logger (debug/info/warning/error levels)
   - Setup Sentry error tracking
   - Create base repository pattern

4. **Code Generation Setup**
   ```bash
   # Build runner command
   flutter pub run build_runner build --delete-conflicting-outputs

   # Watch mode for development
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

**Deliverables:**
- ✅ Project configured with flavors
- ✅ Core infrastructure ready
- ✅ Logging system working
- ✅ Error tracking configured

---

### Week 3-4: Data Models & Serialization

#### Tasks

1. **User Models**
   ```dart
   // lib/data/models/user/user_model.dart
   @freezed
   class UserModel with _$UserModel {
     const factory UserModel({
       required String id,
       required String email,
       required String username,
       String? avatarUrl,
       required UserRole role,
       required DateTime createdAt,
       UserProfileModel? profile,
     }) = _UserModel;

     factory UserModel.fromJson(Map<String, dynamic> json) =>
         _$UserModelFromJson(json);
   }

   // Similar for:
   // - UserProfileModel
   // - UserSettingsModel
   // - UserSubscriptionModel
   ```

2. **VPN Models**
   ```dart
   // lib/data/models/vpn/vpn_server_model.dart
   @freezed
   class VpnServerModel with _$VpnServerModel {
     const factory VpnServerModel({
       required String id,
       required String name,
       required String countryCode,
       required String cityName,
       required String ipAddress,
       required int port,
       required VpnProtocol protocol,
       required int load, // 0-100
       required int latency, // ms
       required bool isPremium,
       required ServerStatus status,
       String? configData, // OpenVPN config or WireGuard config
     }) = _VpnServerModel;

     factory VpnServerModel.fromJson(Map<String, dynamic> json) =>
         _$VpnServerModelFromJson(json);
   }

   // Similar for:
   // - VpnSessionModel
   // - VpnStatsModel
   // - VpnConnectionModel
   ```

3. **Rewards Models**
   ```dart
   // lib/data/models/rewards/icr_balance_model.dart
   @freezed
   class IcrBalanceModel with _$IcrBalanceModel {
     const factory IcrBalanceModel({
       required double balance,
       required double lifetimeEarnings,
       required double lifetimeSpent,
       required double pendingRewards,
       required DateTime lastUpdated,
       String? walletAddress,
     }) = _IcrBalanceModel;

     factory IcrBalanceModel.fromJson(Map<String, dynamic> json) =>
         _$IcrBalanceModelFromJson(json);
   }

   // Similar for:
   // - MissionModel
   // - AchievementModel
   // - PayoutModel
   // - TransactionModel
   ```

4. **Analytics Models**
   ```dart
   // lib/data/models/analytics/privacy_score_model.dart
   @freezed
   class PrivacyScoreModel with _$PrivacyScoreModel {
     const factory PrivacyScoreModel({
       required int score, // 0-100
       required String grade, // A+, A, B, C, D, F
       required int trackersBlocked,
       required int adsBlocked,
       required int malwareBlocked,
       required Duration protectionTime,
       required List<ThreatCategoryModel> threats,
       required DateTime calculatedAt,
     }) = _PrivacyScoreModel;

     factory PrivacyScoreModel.fromJson(Map<String, dynamic> json) =>
         _$PrivacyScoreModelFromJson(json);
   }
   ```

5. **Generate Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

**Deliverables:**
- ✅ All models created with Freezed
- ✅ JSON serialization working
- ✅ Type-safe data classes
- ✅ Immutable models

---

### Week 5-6: State Management with Riverpod

#### Tasks

1. **Auth Provider**
   ```dart
   // lib/presentation/providers/auth_provider.dart
   @riverpod
   class AuthNotifier extends _$AuthNotifier {
     @override
     AsyncValue<UserModel?> build() {
       return const AsyncValue.loading();
     }

     Future<void> login(String email, String password) async {
       state = const AsyncValue.loading();
       try {
         final user = await ref.read(authRepositoryProvider)
             .login(email, password);
         state = AsyncValue.data(user);
       } catch (e, stack) {
         state = AsyncValue.error(e, stack);
       }
     }

     Future<void> logout() async {
       await ref.read(authRepositoryProvider).logout();
       state = const AsyncValue.data(null);
     }
   }

   @riverpod
   bool isAuthenticated(IsAuthenticatedRef ref) {
     final authState = ref.watch(authNotifierProvider);
     return authState.valueOrNull != null;
   }
   ```

2. **VPN Provider**
   ```dart
   // lib/presentation/providers/vpn_provider.dart
   @riverpod
   class VpnNotifier extends _$VpnNotifier {
     @override
     VpnState build() {
       return VpnState.initial();
     }

     Future<void> connect(VpnServerModel server) async {
       state = state.copyWith(
         status: VpnStatus.connecting,
         currentServer: server,
       );

       try {
         final session = await ref.read(vpnRepositoryProvider)
             .connect(server);
         state = state.copyWith(
           status: VpnStatus.connected,
           currentSession: session,
         );

         // Start stats monitoring
         _startStatsMonitoring();
       } catch (e) {
         state = state.copyWith(
           status: VpnStatus.disconnected,
           error: e.toString(),
         );
       }
     }

     Future<void> disconnect() async {
       state = state.copyWith(status: VpnStatus.disconnecting);
       await ref.read(vpnRepositoryProvider).disconnect();
       state = state.copyWith(
         status: VpnStatus.disconnected,
         currentSession: null,
       );
     }

     void _startStatsMonitoring() {
       // Monitor connection stats
       Timer.periodic(const Duration(seconds: 1), (timer) {
         if (state.status != VpnStatus.connected) {
           timer.cancel();
           return;
         }
         _updateStats();
       });
     }
   }

   @freezed
   class VpnState with _$VpnState {
     const factory VpnState({
       required VpnStatus status,
       VpnServerModel? currentServer,
       VpnSessionModel? currentSession,
       VpnStatsModel? stats,
       String? error,
     }) = _VpnState;

     factory VpnState.initial() => const VpnState(
       status: VpnStatus.disconnected,
     );
   }
   ```

3. **Rewards Provider**
   ```dart
   // lib/presentation/providers/rewards_provider.dart
   @riverpod
   class RewardsNotifier extends _$RewardsNotifier {
     @override
     Future<RewardsState> build() async {
       final balance = await ref.read(rewardsRepositoryProvider)
           .getBalance();
       final missions = await ref.read(rewardsRepositoryProvider)
           .getActiveMissions();

       return RewardsState(
         balance: balance,
         missions: missions,
       );
     }

     Future<void> claimMissionReward(String missionId) async {
       state = const AsyncValue.loading();
       try {
         await ref.read(rewardsRepositoryProvider)
             .claimReward(missionId);

         // Refresh data
         ref.invalidateSelf();
       } catch (e, stack) {
         state = AsyncValue.error(e, stack);
       }
     }
   }
   ```

4. **Refactor Existing Screens**
   - Replace StatefulWidget state with Riverpod providers
   - Remove hardcoded mock data
   - Connect UI to providers
   - Add loading/error states

**Example Refactor:**
```dart
// BEFORE (lib/presentation/vpn_dashboard/vpn_dashboard.dart)
class _VpnDashboardState extends State<VpnDashboard> {
  bool _isConnected = false;

  Future<void> _handleConnectionToggle() async {
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isConnected = !_isConnected);
  }
}

// AFTER
class VpnDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnNotifierProvider);

    return Scaffold(
      body: vpnState.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(error: error),
      ),
    );
  }

  void _handleConnectionToggle(WidgetRef ref) {
    final vpn = ref.read(vpnNotifierProvider.notifier);
    if (vpnState.status == VpnStatus.connected) {
      vpn.disconnect();
    } else {
      // Show server selection
      _showServerSelection(context, ref);
    }
  }
}
```

**Deliverables:**
- ✅ All providers implemented
- ✅ Screens refactored to use Riverpod
- ✅ Mock data removed
- ✅ State management working

---

### Week 7-8: Repository Pattern & Local Storage

#### Tasks

1. **Repository Interfaces (Domain Layer)**
   ```dart
   // lib/domain/repositories/auth_repository.dart
   abstract class AuthRepository {
     Future<UserModel> login(String email, String password);
     Future<UserModel> register(RegisterRequest request);
     Future<void> logout();
     Future<UserModel?> getCurrentUser();
     Future<String> refreshToken(String refreshToken);
   }

   // Similar for:
   // - VpnRepository
   // - RewardsRepository
   // - AnalyticsRepository
   ```

2. **Repository Implementations (Data Layer)**
   ```dart
   // lib/data/repositories/auth_repository_impl.dart
   class AuthRepositoryImpl implements AuthRepository {
     final AuthRemoteDataSource remoteDataSource;
     final UserLocalDataSource localDataSource;
     final FlutterSecureStorage secureStorage;

     AuthRepositoryImpl({
       required this.remoteDataSource,
       required this.localDataSource,
       required this.secureStorage,
     });

     @override
     Future<UserModel> login(String email, String password) async {
       try {
         final response = await remoteDataSource.login(email, password);

         // Save tokens securely
         await secureStorage.write(
           key: 'access_token',
           value: response.accessToken,
         );
         await secureStorage.write(
           key: 'refresh_token',
           value: response.refreshToken,
         );

         // Cache user data locally
         await localDataSource.saveUser(response.user);

         return response.user;
       } catch (e) {
         throw AuthException(e.toString());
       }
     }

     @override
     Future<UserModel?> getCurrentUser() async {
       // Try to get from local cache first
       final user = await localDataSource.getUser();
       if (user != null) return user;

       // If not cached, fetch from API
       final token = await secureStorage.read(key: 'access_token');
       if (token == null) return null;

       final remoteUser = await remoteDataSource.getCurrentUser(token);
       await localDataSource.saveUser(remoteUser);

       return remoteUser;
     }
   }
   ```

3. **Local DataSources with Hive**
   ```dart
   // lib/data/datasources/local/user_local_datasource.dart
   class UserLocalDataSource {
     static const String _userBoxName = 'userBox';
     late Box<UserModel> _userBox;

     Future<void> init() async {
       await Hive.initFlutter();
       Hive.registerAdapter(UserModelAdapter());
       _userBox = await Hive.openBox<UserModel>(_userBoxName);
     }

     Future<void> saveUser(UserModel user) async {
       await _userBox.put('current_user', user);
     }

     UserModel? getUser() {
       return _userBox.get('current_user');
     }

     Future<void> deleteUser() async {
       await _userBox.delete('current_user');
     }
   }

   // Similar for:
   // - VpnLocalDataSource (cache servers, sessions)
   // - CacheDataSource (API response caching)
   ```

4. **Secure Storage for Sensitive Data**
   ```dart
   // lib/core/storage/secure_storage_service.dart
   class SecureStorageService {
     final FlutterSecureStorage _storage;

     SecureStorageService(this._storage);

     // Tokens
     Future<void> saveAccessToken(String token) =>
         _storage.write(key: 'access_token', value: token);

     Future<String?> getAccessToken() =>
         _storage.read(key: 'access_token');

     // VPN Configs
     Future<void> saveVpnConfig(String serverId, String config) =>
         _storage.write(key: 'vpn_config_$serverId', value: config);

     Future<String?> getVpnConfig(String serverId) =>
         _storage.read(key: 'vpn_config_$serverId');

     // Clear all
     Future<void> clearAll() => _storage.deleteAll();
   }
   ```

**Deliverables:**
- ✅ Repository pattern implemented
- ✅ Local storage working (Hive)
- ✅ Secure storage configured
- ✅ Data persistence working

---

### Week 9-10: Testing Setup

#### Tasks

1. **Unit Tests - Models**
   ```dart
   // test/unit/data/models/user_model_test.dart
   void main() {
     group('UserModel', () {
       test('should create UserModel from JSON', () {
         final json = {
           'id': '123',
           'email': 'test@test.com',
           'username': 'testuser',
           'role': 'user',
           'createdAt': '2024-01-01T00:00:00Z',
         };

         final user = UserModel.fromJson(json);

         expect(user.id, '123');
         expect(user.email, 'test@test.com');
       });

       test('should convert UserModel to JSON', () {
         final user = UserModel(
           id: '123',
           email: 'test@test.com',
           username: 'testuser',
           role: UserRole.user,
           createdAt: DateTime.parse('2024-01-01'),
         );

         final json = user.toJson();

         expect(json['id'], '123');
         expect(json['email'], 'test@test.com');
       });
     });
   }
   ```

2. **Unit Tests - Repositories**
   ```dart
   // test/unit/data/repositories/auth_repository_test.dart
   @GenerateMocks([AuthRemoteDataSource, UserLocalDataSource])
   void main() {
     late AuthRepositoryImpl repository;
     late MockAuthRemoteDataSource mockRemoteDataSource;
     late MockUserLocalDataSource mockLocalDataSource;

     setUp(() {
       mockRemoteDataSource = MockAuthRemoteDataSource();
       mockLocalDataSource = MockUserLocalDataSource();
       repository = AuthRepositoryImpl(
         remoteDataSource: mockRemoteDataSource,
         localDataSource: mockLocalDataSource,
       );
     });

     group('login', () {
       test('should return user when login is successful', () async {
         final mockUser = UserModel(/* ... */);
         when(mockRemoteDataSource.login(any, any))
             .thenAnswer((_) async => LoginResponse(user: mockUser));

         final result = await repository.login('test@test.com', 'password');

         expect(result, mockUser);
         verify(mockLocalDataSource.saveUser(mockUser)).called(1);
       });
     });
   }
   ```

3. **Widget Tests**
   ```dart
   // test/widget/login_screen_test.dart
   void main() {
     testWidgets('LoginScreen should show login form', (tester) async {
       await tester.pumpWidget(
         ProviderScope(
           child: MaterialApp(
             home: LoginScreen(),
           ),
         ),
       );

       expect(find.byType(TextField), findsNWidgets(2));
       expect(find.text('Login'), findsOneWidget);
     });

     testWidgets('Should show error on invalid credentials', (tester) async {
       // Test implementation
     });
   }
   ```

4. **Integration Tests Setup**
   ```dart
   // integration_test/app_test.dart
   void main() {
     IntegrationTestWidgetsFlutterBinding.ensureInitialized();

     group('end-to-end test', () {
       testWidgets('complete user flow', (tester) async {
         app.main();
         await tester.pumpAndSettle();

         // Test splash -> login -> dashboard flow
       });
     });
   }
   ```

**Deliverables:**
- ✅ Test structure setup
- ✅ Unit tests for models (50+ tests)
- ✅ Unit tests for repositories (30+ tests)
- ✅ Widget tests for key screens (20+ tests)
- ✅ CI configured to run tests

---

## FASE 2: VPN CORE (Mesi 3-4)

### Obiettivo: Implementare VPN reale con OpenVPN/WireGuard

### Week 11-12: Android VPN Implementation

#### Tasks

1. **Android Permissions & Configuration**
   ```xml
   <!-- android/app/src/main/AndroidManifest.xml -->
   <manifest xmlns:android="http://schemas.android.com/apk/res/android">
     <uses-permission android:name="android.permission.INTERNET" />
     <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
     <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
     <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
     <uses-permission android:name="android.permission.BIND_VPN_SERVICE" />

     <application
       android:usesCleartextTraffic="false">  <!-- CHANGE TO FALSE -->

       <service
         android:name=".VpnService"
         android:permission="android.permission.BIND_VPN_SERVICE"
         android:exported="false">
         <intent-filter>
           <action android:name="android.net.VpnService" />
         </intent-filter>
       </service>
     </application>
   </manifest>
   ```

2. **OpenVPN Integration (Android)**
   ```gradle
   // android/app/build.gradle
   dependencies {
     implementation 'de.blinkt:openvpn:0.7.48'
     implementation 'androidx.work:work-runtime-ktx:2.9.0'
   }
   ```

   ```kotlin
   // android/app/src/main/kotlin/.../VpnService.kt
   class VpnService : VpnService() {
     private var vpnThread: OpenVPNThread? = null

     fun connect(configData: String) {
       val config = ConfigParser().parseConfig(
         ByteArrayInputStream(configData.toByteArray())
       )

       val vpnProfile = config.convertProfile()

       val builder = Builder()
       builder.setConfigureIntent(getPendingIntent())

       vpnThread = OpenVPNThread(this, vpnProfile)
       vpnThread?.start()
     }

     fun disconnect() {
       vpnThread?.stopVPN()
       vpnThread = null
     }

     override fun onDestroy() {
       disconnect()
       super.onDestroy()
     }
   }
   ```

3. **Method Channel (Flutter <-> Android)**
   ```kotlin
   // android/app/src/main/kotlin/.../VpnMethodChannel.kt
   class VpnMethodChannel(
     private val context: Context,
     private val activity: Activity
   ) : MethodChannel.MethodCallHandler {

     companion object {
       const val CHANNEL_NAME = "com.privacyguard.vpn/vpn"
       const val METHOD_CONNECT = "connect"
       const val METHOD_DISCONNECT = "disconnect"
       const val METHOD_GET_STATUS = "getStatus"
     }

     override fun onMethodCall(call: MethodCall, result: Result) {
       when (call.method) {
         METHOD_CONNECT -> {
           val config = call.argument<String>("config")
           if (config != null) {
             connectVpn(config, result)
           } else {
             result.error("INVALID_ARGUMENT", "Config is null", null)
           }
         }
         METHOD_DISCONNECT -> disconnectVpn(result)
         METHOD_GET_STATUS -> getVpnStatus(result)
         else -> result.notImplemented()
       }
     }

     private fun connectVpn(config: String, result: Result) {
       val intent = VpnService.prepare(context)
       if (intent != null) {
         // Request VPN permission
         activity.startActivityForResult(intent, VPN_REQUEST_CODE)
       } else {
         // Permission already granted
         startVpnService(config)
       }
       result.success(true)
     }
   }
   ```

   ```kotlin
   // android/app/src/main/kotlin/.../MainActivity.kt
   class MainActivity : FlutterActivity() {
     private lateinit var vpnMethodChannel: VpnMethodChannel

     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
       super.configureFlutterEngine(flutterEngine)

       vpnMethodChannel = VpnMethodChannel(this, this)

       MethodChannel(
         flutterEngine.dartExecutor.binaryMessenger,
         VpnMethodChannel.CHANNEL_NAME
       ).setMethodCallHandler(vpnMethodChannel)
     }
   }
   ```

4. **Flutter Platform Interface**
   ```dart
   // lib/platforms/vpn/vpn_platform_interface.dart
   abstract class VpnPlatformInterface {
     Future<bool> connect(VpnServerModel server, String config);
     Future<bool> disconnect();
     Future<VpnConnectionStatus> getStatus();
     Stream<VpnStats> getStatsStream();
   }

   // lib/platforms/vpn/vpn_method_channel.dart
   class VpnMethodChannel implements VpnPlatformInterface {
     static const MethodChannel _channel =
         MethodChannel('com.privacyguard.vpn/vpn');

     @override
     Future<bool> connect(VpnServerModel server, String config) async {
       try {
         final result = await _channel.invokeMethod('connect', {
           'config': config,
           'serverId': server.id,
         });
         return result as bool;
       } catch (e) {
         throw VpnException('Failed to connect: $e');
       }
     }

     @override
     Future<bool> disconnect() async {
       try {
         final result = await _channel.invokeMethod('disconnect');
         return result as bool;
       } catch (e) {
         throw VpnException('Failed to disconnect: $e');
       }
     }

     @override
     Future<VpnConnectionStatus> getStatus() async {
       final status = await _channel.invokeMethod('getStatus');
       return VpnConnectionStatus.values[status as int];
     }
   }
   ```

**Deliverables:**
- ✅ Android VPN service working
- ✅ OpenVPN connection functional
- ✅ Method channel communication working
- ✅ VPN permissions handling

---

### Week 13-14: iOS VPN Implementation

#### Tasks

1. **iOS Configuration**
   ```xml
   <!-- ios/Runner/Info.plist -->
   <dict>
     <key>UIBackgroundModes</key>
     <array>
       <string>network-authentication</string>
       <string>voip</string>
     </array>

     <key>NSAppTransportSecurity</key>
     <dict>
       <key>NSAllowsArbitraryLoads</key>
       <false/>
     </dict>
   </dict>
   ```

   ```ruby
   # ios/Podfile
   target 'Runner' do
     use_frameworks!

     pod 'OpenVPNAdapter', :git => 'https://github.com/ss-abramchuk/OpenVPNAdapter.git'
     # or
     pod 'WireGuardKit', '~> 1.0'
   end
   ```

2. **Network Extension (iOS)**
   ```swift
   // ios/Runner/VpnService.swift
   import NetworkExtension
   import OpenVPNAdapter

   class VpnService: NSObject {
     private var vpnManager: NETunnelProviderManager?
     private var vpnAdapter: OpenVPNAdapter?

     func connect(config: String, completion: @escaping (Bool, Error?) -> Void) {
       loadVpnManager { [weak self] error in
         guard error == nil else {
           completion(false, error)
           return
         }

         self?.startVpn(config: config, completion: completion)
       }
     }

     private func loadVpnManager(completion: @escaping (Error?) -> Void) {
       NETunnelProviderManager.loadAllFromPreferences { managers, error in
         if let error = error {
           completion(error)
           return
         }

         if let manager = managers?.first {
           self.vpnManager = manager
         } else {
           self.createVpnManager()
         }

         completion(nil)
       }
     }

     private func startVpn(config: String, completion: @escaping (Bool, Error?) -> Void) {
       guard let manager = vpnManager else {
         completion(false, NSError(domain: "VPN", code: -1))
         return
       }

       do {
         let options = ["config": config]
         try manager.connection.startVPNTunnel(options: options)
         completion(true, nil)
       } catch {
         completion(false, error)
       }
     }

     func disconnect(completion: @escaping (Bool) -> Void) {
       vpnManager?.connection.stopVPNTunnel()
       completion(true)
     }

     func getStatus() -> NEVPNStatus {
       return vpnManager?.connection.status ?? .invalid
     }
   }
   ```

3. **Method Channel (iOS)**
   ```swift
   // ios/Runner/VpnMethodChannel.swift
   import Flutter

   class VpnMethodChannel: NSObject, FlutterPlugin {
     static let channelName = "com.privacyguard.vpn/vpn"
     private let vpnService = VpnService()

     static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel(
         name: channelName,
         binaryMessenger: registrar.messenger()
       )
       let instance = VpnMethodChannel()
       registrar.addMethodCallDelegate(instance, channel: channel)
     }

     func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
       switch call.method {
       case "connect":
         guard let args = call.arguments as? [String: Any],
               let config = args["config"] as? String else {
           result(FlutterError(code: "INVALID_ARGUMENT", message: nil, details: nil))
           return
         }

         vpnService.connect(config: config) { success, error in
           if success {
             result(true)
           } else {
             result(FlutterError(code: "VPN_ERROR", message: error?.localizedDescription, details: nil))
           }
         }

       case "disconnect":
         vpnService.disconnect { success in
           result(success)
         }

       case "getStatus":
         let status = vpnService.getStatus()
         result(status.rawValue)

       default:
         result(FlutterMethodNotImplemented)
       }
     }
   }
   ```

   ```swift
   // ios/Runner/AppDelegate.swift
   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       let controller = window?.rootViewController as! FlutterViewController

       VpnMethodChannel.register(with: controller.registrar(forPlugin: "VpnMethodChannel")!)

       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```

**Deliverables:**
- ✅ iOS VPN extension working
- ✅ OpenVPN connection functional on iOS
- ✅ Method channel communication working
- ✅ VPN permissions handling

---

### Week 15-16: VPN Features & Polish

#### Tasks

1. **Kill Switch Implementation**
   ```dart
   // lib/platforms/vpn/kill_switch_manager.dart
   class KillSwitchManager {
     final VpnPlatformInterface vpnPlatform;
     final ConnectivityPlus connectivity;

     Future<void> enableKillSwitch() async {
       // Monitor VPN status
       vpnPlatform.getStatusStream().listen((status) {
         if (status == VpnConnectionStatus.disconnected) {
           _blockInternetAccess();
         }
       });
     }

     Future<void> _blockInternetAccess() async {
       // On Android: Use VpnService to drop all packets
       // On iOS: Use NEPacketTunnelProvider

       await vpnPlatform.enableKillSwitch();
     }
   }
   ```

2. **Auto-Reconnect**
   ```dart
   // lib/domain/usecases/vpn/auto_reconnect_usecase.dart
   class AutoReconnectUsecase {
     final VpnRepository repository;

     void startMonitoring() {
       repository.getConnectionStatusStream().listen((status) {
         if (status == VpnConnectionStatus.disconnected &&
             _shouldAutoReconnect) {
           _attemptReconnect();
         }
       });
     }

     Future<void> _attemptReconnect() async {
       int attempts = 0;
       const maxAttempts = 3;

       while (attempts < maxAttempts) {
         try {
           await repository.reconnect();
           return;
         } catch (e) {
           attempts++;
           await Future.delayed(Duration(seconds: pow(2, attempts).toInt()));
         }
       }
     }
   }
   ```

3. **Server Selection Algorithm**
   ```dart
   // lib/domain/usecases/vpn/select_best_server_usecase.dart
   class SelectBestServerUsecase {
     final VpnRepository repository;

     Future<VpnServerModel> selectBestServer({
       String? countryCode,
       bool premiumOnly = false,
     }) async {
       var servers = await repository.getServers();

       // Filter
       if (countryCode != null) {
         servers = servers.where((s) => s.countryCode == countryCode).toList();
       }
       if (premiumOnly) {
         servers = servers.where((s) => s.isPremium).toList();
       }

       // Sort by score
       servers.sort((a, b) {
         final scoreA = _calculateServerScore(a);
         final scoreB = _calculateServerScore(b);
         return scoreB.compareTo(scoreA);
       });

       return servers.first;
     }

     double _calculateServerScore(VpnServerModel server) {
       // Score = (100 - load) * 0.6 + (100 - latency/10) * 0.4
       final loadScore = (100 - server.load) * 0.6;
       final latencyScore = (100 - min(server.latency / 10, 100)) * 0.4;
       return loadScore + latencyScore;
     }
   }
   ```

4. **Connection Stats Monitoring**
   ```dart
   // lib/platforms/vpn/stats_monitor.dart
   class VpnStatsMonitor {
     Stream<VpnStatsModel> getStatsStream() {
       return Stream.periodic(const Duration(seconds: 1), (_) async {
         // Get stats from platform channel
         final nativeStats = await _channel.invokeMethod('getStats');

         return VpnStatsModel(
           bytesIn: nativeStats['bytesIn'],
           bytesOut: nativeStats['bytesOut'],
           speed: _calculateSpeed(nativeStats),
           duration: Duration(seconds: nativeStats['duration']),
         );
       }).asyncMap((event) => event);
     }
   }
   ```

**Deliverables:**
- ✅ Kill switch working
- ✅ Auto-reconnect functional
- ✅ Server selection optimized
- ✅ Stats monitoring real-time
- ✅ VPN fully functional on Android & iOS

---

## FASE 3: SECURITY & BACKEND (Mesi 5-6)

### Obiettivo: Backend API + Auth real + Security hardening

### Week 17-18: Backend Setup (Supabase)

#### Tasks

1. **Supabase Project Setup**
   ```bash
   # Create project on https://supabase.com

   # Install Supabase CLI
   npm install -g supabase

   # Initialize project
   supabase init
   supabase link --project-ref your-project-ref
   ```

2. **Database Schema**
   ```sql
   -- users table (Supabase Auth handles this)

   -- user_profiles
   CREATE TABLE user_profiles (
     id UUID PRIMARY KEY REFERENCES auth.users(id),
     username TEXT UNIQUE NOT NULL,
     avatar_url TEXT,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- vpn_servers
   CREATE TABLE vpn_servers (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     name TEXT NOT NULL,
     country_code TEXT NOT NULL,
     city_name TEXT NOT NULL,
     ip_address INET NOT NULL,
     port INTEGER NOT NULL,
     protocol TEXT NOT NULL,
     load INTEGER CHECK (load >= 0 AND load <= 100),
     latency INTEGER,
     is_premium BOOLEAN DEFAULT false,
     status TEXT DEFAULT 'active',
     config_data TEXT,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- vpn_sessions
   CREATE TABLE vpn_sessions (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id),
     server_id UUID REFERENCES vpn_servers(id),
     started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     ended_at TIMESTAMP WITH TIME ZONE,
     bytes_in BIGINT DEFAULT 0,
     bytes_out BIGINT DEFAULT 0,
     trackers_blocked INTEGER DEFAULT 0,
     ads_blocked INTEGER DEFAULT 0
   );

   -- icr_balances
   CREATE TABLE icr_balances (
     user_id UUID PRIMARY KEY REFERENCES auth.users(id),
     balance DECIMAL(18, 8) DEFAULT 0,
     lifetime_earnings DECIMAL(18, 8) DEFAULT 0,
     lifetime_spent DECIMAL(18, 8) DEFAULT 0,
     pending_rewards DECIMAL(18, 8) DEFAULT 0,
     wallet_address TEXT,
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- missions
   CREATE TABLE missions (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     title TEXT NOT NULL,
     description TEXT,
     mission_type TEXT NOT NULL,
     target_value DECIMAL,
     reward_amount DECIMAL NOT NULL,
     duration_hours INTEGER,
     is_active BOOLEAN DEFAULT true,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- user_missions
   CREATE TABLE user_missions (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id),
     mission_id UUID REFERENCES missions(id),
     progress DECIMAL DEFAULT 0,
     status TEXT DEFAULT 'active',
     started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     completed_at TIMESTAMP WITH TIME ZONE,
     expires_at TIMESTAMP WITH TIME ZONE
   );

   -- privacy_scores
   CREATE TABLE privacy_scores (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     user_id UUID REFERENCES auth.users(id),
     score INTEGER CHECK (score >= 0 AND score <= 100),
     trackers_blocked INTEGER DEFAULT 0,
     ads_blocked INTEGER DEFAULT 0,
     malware_blocked INTEGER DEFAULT 0,
     protection_time_seconds BIGINT DEFAULT 0,
     calculated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Row Level Security (RLS)
   ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
   ALTER TABLE vpn_sessions ENABLE ROW LEVEL SECURITY;
   ALTER TABLE icr_balances ENABLE ROW LEVEL SECURITY;
   ALTER TABLE user_missions ENABLE ROW LEVEL SECURITY;
   ALTER TABLE privacy_scores ENABLE ROW LEVEL SECURITY;

   -- Policies
   CREATE POLICY "Users can view own profile"
     ON user_profiles FOR SELECT
     USING (auth.uid() = id);

   CREATE POLICY "Users can view own sessions"
     ON vpn_sessions FOR SELECT
     USING (auth.uid() = user_id);

   -- ... more policies
   ```

3. **Supabase Edge Functions**
   ```typescript
   // supabase/functions/reward-calculator/index.ts
   import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
   import { createClient } from '@supabase/supabase-js'

   serve(async (req) => {
     const { userId, sessionId } = await req.json()

     const supabase = createClient(
       Deno.env.get('SUPABASE_URL') ?? '',
       Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
     )

     // Get session data
     const { data: session } = await supabase
       .from('vpn_sessions')
       .select('*')
       .eq('id', sessionId)
       .single()

     // Calculate reward
     const baseReward = calculateBaseReward(session)
     const multiplier = await getMultiplier(userId)
     const totalReward = baseReward * multiplier

     // Update balance
     await supabase.rpc('add_icr_balance', {
       p_user_id: userId,
       p_amount: totalReward
     })

     return new Response(
       JSON.stringify({ reward: totalReward }),
       { headers: { "Content-Type": "application/json" } }
     )
   })
   ```

4. **Flutter Supabase Integration**
   ```dart
   // lib/core/network/supabase_client.dart
   class SupabaseService {
     static final SupabaseClient client = SupabaseClient(
       dotenv.env['SUPABASE_URL']!,
       dotenv.env['SUPABASE_ANON_KEY']!,
     );

     static Future<void> init() async {
       await Supabase.initialize(
         url: dotenv.env['SUPABASE_URL']!,
         anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
       );
     }
   }

   // lib/data/datasources/remote/auth_remote_datasource.dart
   class AuthRemoteDataSource {
     final SupabaseClient _supabase;

     Future<UserModel> login(String email, String password) async {
       final response = await _supabase.auth.signInWithPassword(
         email: email,
         password: password,
       );

       if (response.user == null) {
         throw AuthException('Login failed');
       }

       // Get user profile
       final profile = await _supabase
           .from('user_profiles')
           .select()
           .eq('id', response.user!.id)
           .single();

       return UserModel.fromJson({
         ...response.user!.toJson(),
         'profile': profile,
       });
     }
   }
   ```

**Deliverables:**
- ✅ Supabase project configured
- ✅ Database schema deployed
- ✅ Edge functions working
- ✅ Flutter integration complete
- ✅ Authentication working with real backend

---

### Week 19-20: Security Hardening

#### Tasks

1. **SSL/TLS Pinning**
   ```dart
   // lib/core/network/dio_client.dart
   class DioClient {
     static Dio createDio() {
       final dio = Dio();

       // SSL Pinning
       (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
           (HttpClient client) {
         client.badCertificateCallback =
             (X509Certificate cert, String host, int port) {
           // Verify certificate fingerprint
           final certHash = sha256.convert(cert.der).toString();
           final allowedHashes = [
             dotenv.env['CERT_HASH_1']!,
             dotenv.env['CERT_HASH_2']!,
           ];

           return allowedHashes.contains(certHash);
         };
         return client;
       };

       return dio;
     }
   }
   ```

2. **Data Encryption**
   ```dart
   // lib/core/security/encryption_service.dart
   class EncryptionService {
     static final _encrypter = Encrypter(AES(
       Key.fromSecureRandom(32),
       mode: AESMode.gcm,
     ));

     String encrypt(String plainText) {
       final iv = IV.fromSecureRandom(16);
       final encrypted = _encrypter.encrypt(plainText, iv: iv);
       return '${iv.base64}:${encrypted.base64}';
     }

     String decrypt(String encryptedText) {
       final parts = encryptedText.split(':');
       final iv = IV.fromBase64(parts[0]);
       final encrypted = Encrypted.fromBase64(parts[1]);
       return _encrypter.decrypt(encrypted, iv: iv);
     }
   }
   ```

3. **Biometric Authentication**
   ```dart
   // lib/core/auth/biometric_auth_service.dart
   class BiometricAuthService {
     final LocalAuthentication _localAuth = LocalAuthentication();

     Future<bool> isBiometricAvailable() async {
       return await _localAuth.canCheckBiometrics &&
              await _localAuth.isDeviceSupported();
     }

     Future<bool> authenticate() async {
       try {
         return await _localAuth.authenticate(
           localizedReason: 'Please authenticate to access PrivacyGuard',
           options: const AuthenticationOptions(
             stickyAuth: true,
             biometricOnly: true,
           ),
         );
       } catch (e) {
         return false;
       }
     }
   }
   ```

4. **Code Obfuscation**
   ```bash
   # Build with obfuscation
   flutter build apk --release --obfuscate --split-debug-info=build/debug-info
   flutter build ios --release --obfuscate --split-debug-info=build/debug-info
   ```

**Deliverables:**
- ✅ SSL pinning implemented
- ✅ Data encryption working
- ✅ Biometric auth functional
- ✅ Code obfuscation enabled
- ✅ Security audit passed

---

## FASE 4: TRACKER BLOCKING (Mese 7)

### Obiettivo: Implementare blocco real-time di ads/trackers

### Week 21-22: DNS Filtering

#### Tasks

1. **DNS-over-HTTPS Implementation**
   ```dart
   // lib/platforms/tracker_blocking/dns_filter.dart
   class DnsFilter {
     final Dio _dio = Dio();
     final FilterListManager _filterManager;

     Future<bool> shouldBlock(String domain) async {
       // Check against filter lists
       return _filterManager.isBlocked(domain);
     }

     Future<String?> resolveDomain(String domain) async {
       if (await shouldBlock(domain)) {
         return null; // Blocked
       }

       // Use Cloudflare DNS-over-HTTPS
       final response = await _dio.get(
         'https://cloudflare-dns.com/dns-query',
         queryParameters: {
           'name': domain,
           'type': 'A',
         },
         options: Options(
           headers: {'Accept': 'application/dns-json'},
         ),
       );

       return response.data['Answer']?[0]?['data'];
     }
   }
   ```

2. **Filter List Manager**
   ```dart
   // lib/platforms/tracker_blocking/filter_list_manager.dart
   class FilterListManager {
     final Map<String, Set<String>> _filterLists = {};

     Future<void> initialize() async {
       await _loadFilterList(
         'easylist',
         'https://easylist.to/easylist/easylist.txt',
       );
       await _loadFilterList(
         'easyprivacy',
         'https://easylist.to/easylist/easyprivacy.txt',
       );
       await _loadFilterList(
         'malware',
         'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
       );
     }

     Future<void> _loadFilterList(String name, String url) async {
       final response = await http.get(Uri.parse(url));
       final domains = _parseFilterList(response.body);
       _filterLists[name] = domains;

       // Cache locally
       await _cacheFilterList(name, domains);
     }

     bool isBlocked(String domain) {
       for (final list in _filterLists.values) {
         if (list.contains(domain)) return true;

         // Check wildcards
         final parts = domain.split('.');
         for (int i = 0; i < parts.length - 1; i++) {
           final wildcard = '*.${parts.sublist(i + 1).join('.')}';
           if (list.contains(wildcard)) return true;
         }
       }
       return false;
     }

     Set<String> _parseFilterList(String content) {
       // Parse different filter list formats
       final domains = <String>{};

       for (final line in content.split('\n')) {
         if (line.isEmpty || line.startsWith('!') || line.startsWith('#')) {
           continue;
         }

         // Parse domain
         final domain = _extractDomain(line);
         if (domain != null) {
           domains.add(domain);
         }
       }

       return domains;
     }
   }
   ```

3. **Threat Detector**
   ```dart
   // lib/platforms/tracker_blocking/threat_detector.dart
   class ThreatDetector {
     ThreatCategory detectThreat(String domain) {
       // Check against categorized lists
       if (_isAdDomain(domain)) return ThreatCategory.ads;
       if (_isTrackerDomain(domain)) return ThreatCategory.trackers;
       if (_isMalwareDomain(domain)) return ThreatCategory.malware;
       if (_isAnalyticsDomain(domain)) return ThreatCategory.analytics;

       return ThreatCategory.none;
     }

     bool _isAdDomain(String domain) {
       final adKeywords = ['ad', 'ads', 'doubleclick', 'adserver'];
       return adKeywords.any((keyword) => domain.contains(keyword));
     }
   }
   ```

4. **Stats Collection**
   ```dart
   // lib/data/repositories/analytics_repository_impl.dart
   class AnalyticsRepositoryImpl implements AnalyticsRepository {
     @override
     Future<void> recordBlockedThreat(
       String domain,
       ThreatCategory category,
     ) async {
       // Update local stats
       await _localDataSource.incrementBlockCount(category);

       // Send to backend (batched)
       _batchQueue.add(BlockEvent(
         domain: domain,
         category: category,
         timestamp: DateTime.now(),
       ));

       if (_batchQueue.length >= 10) {
         await _flushBatch();
       }
     }

     @override
     Future<PrivacyScoreModel> calculatePrivacyScore() async {
       final stats = await _localDataSource.getBlockStats();

       final score = _calculateScore(
         stats.trackersBlocked,
         stats.adsBlocked,
         stats.malwareBlocked,
         stats.protectionTime,
       );

       return PrivacyScoreModel(
         score: score,
         grade: _getGrade(score),
         trackersBlocked: stats.trackersBlocked,
         adsBlocked: stats.adsBlocked,
         malwareBlocked: stats.malwareBlocked,
         protectionTime: stats.protectionTime,
         threats: stats.threatCategories,
         calculatedAt: DateTime.now(),
       );
     }
   }
   ```

**Deliverables:**
- ✅ DNS filtering working
- ✅ Filter lists integrated (EasyList, EasyPrivacy, StevenBlack)
- ✅ Threat detection functional
- ✅ Real-time blocking stats
- ✅ Privacy score calculation accurate

---

## FASE 5: ICR TOKENOMICS (Mesi 8-9)

### Obiettivo: Blockchain integration + reward system

### Week 23-26: Smart Contracts

#### Tasks

1. **Smart Contract Development**
   ```solidity
   // contracts/ICRToken.sol
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.20;

   import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
   import "@openzeppelin/contracts/access/Ownable.sol";

   contract ICRToken is ERC20, Ownable {
     mapping(address => bool) public minters;

     constructor() ERC20("InternetCitizen Reward", "ICR") Ownable(msg.sender) {
       _mint(msg.sender, 1000000000 * 10 ** decimals()); // 1B initial supply
     }

     modifier onlyMinter() {
       require(minters[msg.sender], "Not authorized");
       _;
     }

     function addMinter(address minter) external onlyOwner {
       minters[minter] = true;
     }

     function mint(address to, uint256 amount) external onlyMinter {
       _mint(to, amount);
     }
   }
   ```

   ```solidity
   // contracts/RewardDistributor.sol
   pragma solidity ^0.8.20;

   import "./ICRToken.sol";

   contract RewardDistributor is Ownable {
     ICRToken public icrToken;

     struct RewardClaim {
       address user;
       uint256 amount;
       string sessionId;
       uint256 timestamp;
       bool claimed;
     }

     mapping(bytes32 => RewardClaim) public claims;
     mapping(address => uint256) public totalEarned;

     event RewardCalculated(address indexed user, uint256 amount, string sessionId);
     event RewardClaimed(address indexed user, uint256 amount);

     constructor(address _icrToken) Ownable(msg.sender) {
       icrToken = ICRToken(_icrToken);
     }

     function calculateReward(
       address user,
       string memory sessionId,
       uint256 sessionDuration,
       uint256 trackersBlocked
     ) external onlyOwner returns (bytes32) {
       // Base reward: 0.1 ICR per minute
       uint256 baseReward = (sessionDuration / 60) * 1e17; // 0.1 ICR

       // Tracker bonus: 0.01 ICR per tracker
       uint256 trackerBonus = trackersBlocked * 1e16; // 0.01 ICR

       uint256 totalReward = baseReward + trackerBonus;

       bytes32 claimId = keccak256(abi.encodePacked(user, sessionId));

       claims[claimId] = RewardClaim({
         user: user,
         amount: totalReward,
         sessionId: sessionId,
         timestamp: block.timestamp,
         claimed: false
       });

       emit RewardCalculated(user, totalReward, sessionId);

       return claimId;
     }

     function claimReward(bytes32 claimId) external {
       RewardClaim storage claim = claims[claimId];
       require(claim.user == msg.sender, "Not your reward");
       require(!claim.claimed, "Already claimed");

       claim.claimed = true;
       totalEarned[msg.sender] += claim.amount;

       icrToken.transfer(msg.sender, claim.amount);

       emit RewardClaimed(msg.sender, claim.amount);
     }
   }
   ```

2. **Deploy to Polygon Mumbai (Testnet)**
   ```javascript
   // scripts/deploy.js
   const hre = require("hardhat");

   async function main() {
     // Deploy ICRToken
     const ICRToken = await hre.ethers.getContractFactory("ICRToken");
     const icrToken = await ICRToken.deploy();
     await icrToken.waitForDeployment();
     console.log("ICRToken deployed to:", await icrToken.getAddress());

     // Deploy RewardDistributor
     const RewardDistributor = await hre.ethers.getContractFactory("RewardDistributor");
     const distributor = await RewardDistributor.deploy(await icrToken.getAddress());
     await distributor.waitForDeployment();
     console.log("RewardDistributor deployed to:", await distributor.getAddress());

     // Add distributor as minter
     await icrToken.addMinter(await distributor.getAddress());
   }

   main().catch((error) => {
     console.error(error);
     process.exitCode = 1;
   });
   ```

3. **Flutter Web3 Integration**
   ```dart
   // lib/platforms/blockchain/web3_client.dart
   class Web3Client {
     late web3dart.Web3Client _client;
     late EthereumWalletConnectProvider _provider;

     Future<void> initialize() async {
       final rpcUrl = dotenv.env['POLYGON_RPC_URL']!;
       _client = web3dart.Web3Client(rpcUrl, http.Client());
     }

     Future<void> connectWallet() async {
       _provider = EthereumWalletConnectProvider(
         bridge: 'https://bridge.walletconnect.org',
       );

       await _provider.connect();
     }

     Future<EthereumAddress> getAddress() async {
       final session = _provider.session;
       return EthereumAddress.fromHex(session.accounts[0]);
     }
   }

   // lib/platforms/blockchain/smart_contract_interface.dart
   class SmartContractInterface {
     final Web3Client _web3Client;
     late DeployedContract _icrTokenContract;
     late DeployedContract _rewardDistributorContract;

     Future<void> initialize() async {
       // Load ABIs
       final icrTokenAbi = await rootBundle.loadString('assets/abi/ICRToken.json');
       final distributorAbi = await rootBundle.loadString('assets/abi/RewardDistributor.json');

       _icrTokenContract = DeployedContract(
         ContractAbi.fromJson(icrTokenAbi, 'ICRToken'),
         EthereumAddress.fromHex(dotenv.env['ICR_TOKEN_ADDRESS']!),
       );

       _rewardDistributorContract = DeployedContract(
         ContractAbi.fromJson(distributorAbi, 'RewardDistributor'),
         EthereumAddress.fromHex(dotenv.env['REWARD_DISTRIBUTOR_ADDRESS']!),
       );
     }

     Future<BigInt> getBalance(EthereumAddress address) async {
       final function = _icrTokenContract.function('balanceOf');
       final result = await _web3Client.call(
         contract: _icrTokenContract,
         function: function,
         params: [address],
       );
       return result[0] as BigInt;
     }

     Future<String> claimReward(String claimId) async {
       final function = _rewardDistributorContract.function('claimReward');

       final transaction = Transaction.callContract(
         contract: _rewardDistributorContract,
         function: function,
         parameters: [hexToBytes(claimId)],
       );

       final txHash = await _web3Client.sendTransaction(
         _credentials,
         transaction,
         chainId: 80001, // Mumbai testnet
       );

       return txHash;
     }
   }
   ```

4. **Reward Calculation Backend**
   ```typescript
   // supabase/functions/calculate-icr-reward/index.ts
   serve(async (req) => {
     const { sessionId } = await req.json()

     // Get session data
     const session = await getSession(sessionId)

     // Calculate reward
     const baseReward = (session.duration / 60) * 0.1 // 0.1 ICR per minute
     const trackerBonus = session.trackersBlocked * 0.01 // 0.01 per tracker
     const totalReward = baseReward + trackerBonus

     // Call smart contract
     const web3 = new Web3(process.env.POLYGON_RPC_URL)
     const contract = new web3.eth.Contract(RewardDistributorABI, contractAddress)

     const claimId = await contract.methods.calculateReward(
       session.userId,
       sessionId,
       session.duration,
       session.trackersBlocked
     ).send({ from: adminWallet })

     // Save to database
     await supabase.from('reward_claims').insert({
       user_id: session.userId,
       claim_id: claimId,
       amount: totalReward,
       session_id: sessionId
     })

     return new Response(JSON.stringify({ claimId, reward: totalReward }))
   })
   ```

**Deliverables:**
- ✅ Smart contracts deployed (testnet)
- ✅ Wallet connection working (WalletConnect)
- ✅ ICR token minting functional
- ✅ Reward calculation automated
- ✅ Claim process working

---

### Week 27-28: Missions & Achievements

#### Tasks

1. **Mission Engine**
   ```dart
   // lib/domain/usecases/rewards/mission_tracker_usecase.dart
   class MissionTrackerUsecase {
     final RewardsRepository _repository;

     Future<void> trackProgress(MissionEvent event) async {
       final activeMissions = await _repository.getActiveMissions();

       for (final mission in activeMissions) {
         if (_isEventRelevant(mission, event)) {
           final newProgress = _calculateProgress(mission, event);
           await _repository.updateMissionProgress(mission.id, newProgress);

           if (newProgress >= mission.targetValue) {
             await _completeMission(mission);
           }
         }
       }
     }

     Future<void> _completeMission(MissionModel mission) async {
       await _repository.completeMission(mission.id);

       // Award ICR
       await _repository.addPendingReward(mission.rewardAmount);

       // Trigger notification
       await _notificationService.showMissionComplete(mission);
     }
   }

   sealed class MissionEvent {}
   class TrackersBlockedEvent extends MissionEvent {
     final int count;
     TrackersBlockedEvent(this.count);
   }
   class SessionDurationEvent extends MissionEvent {
     final Duration duration;
     SessionDurationEvent(this.duration);
   }
   ```

2. **Achievement System**
   ```dart
   // lib/domain/usecases/rewards/achievement_checker_usecase.dart
   class AchievementCheckerUsecase {
     Future<void> checkAchievements(String userId) async {
       final stats = await _getUser Stats(userId);
       final achievements = await _repository.getAllAchievements();

       for (final achievement in achievements) {
         if (_isUnlocked(achievement, stats)) {
           await _unlockAchievement(userId, achievement);
         }
       }
     }

     bool _isUnlocked(AchievementModel achievement, UserStats stats) {
       switch (achievement.type) {
         case AchievementType.trackersBlocked:
           return stats.totalTrackersBlocked >= achievement.requirement;
         case AchievementType.sessionCount:
           return stats.totalSessions >= achievement.requirement;
         case AchievementType.protectionTime:
           return stats.totalProtectionTime.inHours >= achievement.requirement;
         default:
           return false;
       }
     }
   }
   ```

**Deliverables:**
- ✅ Mission system working
- ✅ Achievement unlocking functional
- ✅ Referral system implemented
- ✅ Payout options integrated

---

## FASE 6: LAUNCH PREP (Mese 10)

### Obiettivo: Testing, compliance, deployment

### Week 29-30: Testing & QA

#### Tasks

1. **Comprehensive Testing**
   - Unit tests: 70%+ coverage
   - Widget tests: All screens
   - Integration tests: Critical flows
   - E2E tests: User journeys
   - Performance testing
   - Security testing

2. **Beta Testing**
   - TestFlight (iOS): 100 beta testers
   - Firebase App Distribution (Android): 100 beta testers
   - Feedback collection
   - Bug fixes

**Deliverables:**
- ✅ Test coverage >70%
- ✅ Critical bugs fixed
- ✅ Beta feedback incorporated

---

### Week 31-32: Compliance & Legal

#### Tasks

1. **Privacy Policy & ToS**
   - Legal review
   - GDPR compliance documentation
   - User consent flows
   - Data deletion mechanism

2. **App Store Preparation**
   - Screenshots (iOS/Android)
   - App descriptions
   - Keywords optimization
   - Store listings

3. **Security Audit**
   - Third-party penetration testing
   - Code review
   - Vulnerability assessment
   - Fix critical issues

**Deliverables:**
- ✅ Legal documents finalized
- ✅ GDPR fully compliant
- ✅ App stores ready
- ✅ Security audit passed

---

### Week 33-36: Production Launch

#### Tasks

1. **Infrastructure Setup**
   - Production servers (AWS/DO)
   - VPN nodes (5+ countries)
   - Database backups
   - Monitoring (Grafana, Sentry)
   - CDN configuration

2. **Smart Contracts (Mainnet)**
   - Deploy to Polygon mainnet
   - Verify contracts on PolygonScan
   - Fund reward pool

3. **Soft Launch**
   - Limited release (geo-restricted)
   - Monitor metrics
   - Fix issues
   - Gradual rollout

4. **Full Launch**
   - Public release
   - Marketing campaign
   - Community building
   - Support channels

**Deliverables:**
- ✅ Production infrastructure live
- ✅ App store approved
- ✅ Public launch successful

---

## TEAM & RISORSE

### Team Raccomandato

#### Core Team (Fulltime)
1. **Senior Flutter Developer** (2)
   - Clean architecture
   - Native platform integration
   - State management expert

2. **Backend Developer** (1)
   - Node.js/TypeScript or Supabase
   - Database design
   - API development

3. **Blockchain Developer** (1)
   - Solidity
   - Smart contracts
   - Web3 integration

4. **DevOps Engineer** (0.5)
   - AWS/DigitalOcean
   - CI/CD
   - Server management

5. **QA Engineer** (1)
   - Test automation
   - Manual testing
   - Bug tracking

6. **UI/UX Designer** (0.5)
   - Refinements
   - Assets
   - Marketing materials

#### Part-time/Consultants
7. **Security Expert** (consultant)
   - Security audit
   - Penetration testing
   - Best practices review

8. **Legal Advisor** (consultant)
   - GDPR compliance
   - Privacy policy
   - Terms of service

9. **Marketing** (consultant)
   - Launch strategy
   - Community management
   - Growth hacking

### Budget Estimate (10 mesi)

| Voce | Costo Mensile | Totale 10M |
|------|---------------|------------|
| **Team Salaries** | | |
| 2x Flutter Dev ($6k ea) | $12,000 | $120,000 |
| 1x Backend Dev ($5k) | $5,000 | $50,000 |
| 1x Blockchain Dev ($7k) | $7,000 | $70,000 |
| 1x QA Engineer ($4k) | $4,000 | $40,000 |
| 0.5x DevOps ($3k) | $3,000 | $30,000 |
| 0.5x Designer ($2k) | $2,000 | $20,000 |
| **Subtotale Team** | **$33,000** | **$330,000** |
| | | |
| **Infrastructure** | | |
| AWS/DigitalOcean | $500 | $5,000 |
| Supabase | $200 | $2,000 |
| Polygon gas fees | $100 | $1,000 |
| CDN & Storage | $200 | $2,000 |
| Monitoring tools | $150 | $1,500 |
| **Subtotale Infra** | **$1,150** | **$11,500** |
| | | |
| **Services** | | |
| Sentry | $100 | $1,000 |
| Firebase | $200 | $2,000 |
| Domain & SSL | $20 | $200 |
| Design tools | $100 | $1,000 |
| **Subtotale Services** | **$420** | **$4,200** |
| | | |
| **Consultants** | | |
| Security audit | - | $10,000 |
| Legal advisor | - | $5,000 |
| Marketing consultant | - | $10,000 |
| **Subtotale Consultants** | **-** | **$25,000** |
| | | |
| **TOTALE** | **~$35,000/mo** | **~$370,000** |

### Timeline Alternatives

#### Fast Track (6 mesi, $450k)
- Team di 7 developers
- Skip ICR tokenomics (fase 2)
- Focus su VPN + tracker blocking

#### Budget (12 mesi, $250k)
- Team ridotto (3-4 dev)
- Phased approach più diluito
- Più rischi timeline

---

## CONCLUSIONE

Questo piano di implementazione fornisce una roadmap dettagliata per trasformare PrivacyGuard VPN da prototipo UI a prodotto production-ready.

**Prossimi Step Immediati:**
1. ✅ Review e approval del piano
2. ✅ Assemblare team
3. ✅ Setup infrastructure (settimana 1)
4. ✅ Kickoff sviluppo (settimana 2)

**Success Metrics:**
- VPN connessione funzionante: Mese 4
- Alpha release: Mese 6
- Beta release: Mese 9
- Production launch: Mese 10

---

**Documento preparato da:** Claude Code AI
**Per:** PrivacyGuard VPN Development Team
**Data:** 2025-11-14
**Versione:** 1.0
