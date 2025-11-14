import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;

  UserModel? _currentUser;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required FlutterSecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.login(email, password);

      // Save user ID securely
      await _secureStorage.write(
        key: AppConstants.keyUserId,
        value: user.id,
      );

      _currentUser = user;
      AppLogger.info('User logged in: ${user.email}');

      return user;
    } catch (e) {
      AppLogger.error('Login failed in repository', e);
      rethrow;
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final user = await _remoteDataSource.register(email, username, password);

      await _secureStorage.write(
        key: AppConstants.keyUserId,
        value: user.id,
      );

      _currentUser = user;
      AppLogger.info('User registered: ${user.email}');

      return user;
    } catch (e) {
      AppLogger.error('Registration failed in repository', e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.keyUserId);
    _currentUser = null;
    AppLogger.info('User logged out');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final userId = await _secureStorage.read(key: AppConstants.keyUserId);
    if (userId == null) return null;

    _currentUser = await _remoteDataSource.getCurrentUser(userId);
    return _currentUser;
  }

  @override
  Stream<UserModel?> get authStateChanges async* {
    // Initial state
    yield await getCurrentUser();

    // Listen to changes (can be improved with Convex subscriptions)
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield _currentUser;
    }
  }
}
