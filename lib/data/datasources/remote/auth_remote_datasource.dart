import '../../../core/network/convex_service.dart';
import '../../../core/utils/logger.dart';
import '../../../core/config/vpn_test_config.dart';
import '../../models/user/user_model.dart';

class AuthRemoteDataSource {
  // Try to get Convex client, but don't fail if not initialized
  dynamic get _convex {
    try {
      return ConvexService.client;
    } catch (e) {
      AppLogger.warning('Convex not initialized, using test credentials');
      return null;
    }
  }

  Future<UserModel> login(String email, String password) async {
    // Try Convex first if available
    if (_convex != null) {
      try {
        AppLogger.info('🔑 Login attempt for: $email (Convex)');

        final result = await _convex.mutation(
          'users:login',
          {'email': email, 'password': password},
        );

        AppLogger.info('✅ Login successful (Convex)');
        return UserModel.fromJson(result['user'] as Map<String, dynamic>);
      } catch (e) {
        AppLogger.warning('⚠️ Convex login failed, trying test credentials: $e');
      }
    }

    // Fallback to test credentials
    AppLogger.info('🔑 Login attempt for: $email (Test mode)');

    if (VpnTestConfig.isValidTestCredential(email, password)) {
      final user = UserModel(
        id: 'test_user_${email.hashCode}',
        email: email,
        username: email.split('@')[0],
        isPremium: false,
        createdAt: DateTime.now(),
      );

      AppLogger.info('✅ Login successful (Test mode): ${user.email}');
      return user;
    }

    AppLogger.error('❌ Invalid credentials');
    throw Exception('Invalid email or password');
  }

  Future<UserModel> register(
    String email,
    String username,
    String password,
  ) async {
    // Try Convex first if available
    if (_convex != null) {
      try {
        AppLogger.info('📝 Register attempt for: $email (Convex)');

        final result = await _convex.mutation(
          'users:register',
          {
            'email': email,
            'username': username,
            'password': password,
          },
        );

        AppLogger.info('✅ Registration successful (Convex)');
        return UserModel.fromJson(result['user'] as Map<String, dynamic>);
      } catch (e) {
        AppLogger.warning('⚠️ Convex registration failed, using test mode: $e');
      }
    }

    // Fallback to test mode registration
    AppLogger.info('📝 Register attempt for: $email (Test mode)');

    final user = UserModel(
      id: 'test_user_${email.hashCode}',
      email: email,
      username: username,
      isPremium: false,
      createdAt: DateTime.now(),
    );

    AppLogger.info('✅ Registration successful (Test mode): ${user.email}');
    return user;
  }

  Future<UserModel?> getCurrentUser(String userId) async {
    // Try Convex first if available
    if (_convex != null) {
      try {
        final result = await _convex.query(
          'users:getUser',
          {'userId': userId},
        );

        if (result == null) return null;
        return UserModel.fromJson(result as Map<String, dynamic>);
      } catch (e) {
        AppLogger.warning('⚠️ Convex get user failed: $e');
      }
    }

    // Fallback to test user
    if (userId.startsWith('test_user_')) {
      return UserModel(
        id: userId,
        email: 'test@example.com',
        username: 'testuser',
        isPremium: false,
        createdAt: DateTime.now(),
      );
    }

    return null;
  }
}
