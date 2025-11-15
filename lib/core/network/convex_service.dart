import 'package:convex/convex.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class ConvexService {
  static ConvexClient? _client;

  static Future<void> initialize() async {
    try {
      _client = ConvexClient.authenticated(
        AppConstants.convexUrl,
      );
      AppLogger.info('Convex initialized successfully');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize Convex', e, stack);
      rethrow;
    }
  }

  static ConvexClient get client {
    if (_client == null) {
      throw StateError('ConvexService not initialized. Call initialize() first.');
    }
    return _client!;
  }

  static void dispose() {
    _client?.close();
    _client = null;
  }
}
