import '../../../core/network/convex_service.dart';
import '../../../core/utils/logger.dart';
import '../../models/user/user_model.dart';

class AuthRemoteDataSource {
  final convex = ConvexService.client;

  Future<UserModel> login(String email, String password) async {
    try {
      AppLogger.info('Login attempt for: $email');

      // Call Convex mutation
      final result = await convex.mutation(
        'users:login',
        {'email': email, 'password': password},
      );

      AppLogger.info('Login successful');
      return UserModel.fromJson(result as Map<String, dynamic>);
    } catch (e, stack) {
      AppLogger.error('Login failed', e, stack);
      rethrow;
    }
  }

  Future<UserModel> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      AppLogger.info('Register attempt for: $email');

      final result = await convex.mutation(
        'users:register',
        {
          'email': email,
          'username': username,
          'password': password,
        },
      );

      AppLogger.info('Registration successful');
      return UserModel.fromJson(result as Map<String, dynamic>);
    } catch (e, stack) {
      AppLogger.error('Registration failed', e, stack);
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser(String userId) async {
    try {
      final result = await convex.query(
        'users:get',
        {'userId': userId},
      );

      if (result == null) return null;
      return UserModel.fromJson(result as Map<String, dynamic>);
    } catch (e, stack) {
      AppLogger.error('Get current user failed', e, stack);
      return null;
    }
  }
}
