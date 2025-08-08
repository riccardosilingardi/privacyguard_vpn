import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_connection_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _showRetryOption = false;
  bool _isInitializing = true;
  String _currentStatus = 'Initializing secure connection...';
  Timer? _timeoutTimer;
  Timer? _initializationTimer;

  // Mock user authentication states for demonstration
  final Map<String, dynamic> _mockUserStates = {
    'authenticated_user': {
      'isAuthenticated': true,
      'hasCompletedOnboarding': true,
      'email': 'user@privacyguard.com',
      'subscription': 'premium',
    },
    'new_user': {
      'isAuthenticated': false,
      'hasCompletedOnboarding': false,
      'isFirstLaunch': true,
    },
    'returning_user': {
      'isAuthenticated': false,
      'hasCompletedOnboarding': true,
      'lastLogin': '2025-08-05',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setSystemUIOverlay();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0F1419),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isInitializing = true;
      _showRetryOption = false;
    });

    // Set timeout timer for 5 seconds
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (_isInitializing) {
        setState(() {
          _showRetryOption = true;
          _isInitializing = false;
        });
      }
    });

    try {
      // Simulate initialization process
      await _performInitializationSteps();

      // Cancel timeout timer if initialization completes
      _timeoutTimer?.cancel();

      if (mounted && _isInitializing) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      _timeoutTimer?.cancel();
      if (mounted) {
        setState(() {
          _showRetryOption = true;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      'Checking authentication status...',
      'Loading user preferences...',
      'Initializing VPN configuration...',
      'Preparing cached privacy data...',
      'Establishing secure connection...',
    ];

    for (int i = 0; i < steps.length; i++) {
      if (!_isInitializing) break;

      setState(() {
        _currentStatus = steps[i];
      });

      // Simulate processing time for each step
      await Future.delayed(Duration(milliseconds: 400 + (i * 100)));
    }

    // Additional delay to show completion
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate checking user authentication status
    final userState = _getCurrentUserState();

    setState(() {
      _isInitializing = false;
    });

    // Add smooth transition delay
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Navigation logic based on user state
    if (userState['isAuthenticated'] == true) {
      // Authenticated users go directly to VPN Dashboard
      Navigator.pushReplacementNamed(context, '/vpn-dashboard');
    } else if (userState['hasCompletedOnboarding'] == false) {
      // New users see Privacy Onboarding flow
      Navigator.pushReplacementNamed(context, '/privacy-onboarding');
    } else {
      // Returning non-authenticated users reach Login screen
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Map<String, dynamic> _getCurrentUserState() {
    // Simulate different user states for demonstration
    // In real implementation, this would check actual authentication status
    final states = _mockUserStates.values.toList();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final stateIndex = (currentTime ~/ 10000) % states.length;
    return states[stateIndex];
  }

  void _retryConnection() {
    _initializeApp();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _initializationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradientWidget(),

          // Safe area content
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _showRetryOption
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        const AnimatedLogoWidget(),
                        const Spacer(flex: 3),
                        RetryConnectionWidget(
                          onRetry: _retryConnection,
                          errorMessage:
                              'Unable to establish secure connection. Please check your internet connection and try again.',
                        ),
                        const Spacer(flex: 2),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        const AnimatedLogoWidget(),
                        const Spacer(flex: 2),
                        LoadingIndicatorWidget(
                          loadingText: _currentStatus,
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
            ),
          ),

          // Version info at bottom
          if (!_showRetryOption)
            Positioned(
              bottom: 4.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Version 1.0.0 • Build 2025.08.07',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
