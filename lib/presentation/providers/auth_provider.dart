import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/user/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

// Providers for dependencies
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

// Auth State Provider
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// Current User Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
});

// Auth Controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AuthController(this._ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.login(email, password);

      state = const AsyncValue.data(null);

      // Invalidate to refresh auth state
      _ref.invalidate(authStateProvider);
      _ref.invalidate(currentUserProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> register(String email, String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.register(email, username, password);

      state = const AsyncValue.data(null);

      _ref.invalidate(authStateProvider);
      _ref.invalidate(currentUserProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(authRepositoryProvider);
      await repository.logout();

      state = const AsyncValue.data(null);

      _ref.invalidate(authStateProvider);
      _ref.invalidate(currentUserProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
