import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/gdpr_compliance_widget.dart';
import './widgets/icr_accumulation_widget.dart';
import './widgets/interactive_vpn_toggle_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_request_widget.dart';
import './widgets/tracker_counter_widget.dart';

class PrivacyOnboarding extends StatefulWidget {
  const PrivacyOnboarding({Key? key}) : super(key: key);

  @override
  State<PrivacyOnboarding> createState() => _PrivacyOnboardingState();
}

class _PrivacyOnboardingState extends State<PrivacyOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _permissionsGranted = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'One-Tap VPN Protection',
      'description':
          'Connect to our secure VPN network instantly. Your internet traffic is encrypted and protected from prying eyes with military-grade security.',
      'imageUrl':
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'hasInteractive': true,
      'interactiveType': 'vpn_toggle',
    },
    {
      'title': 'Real-Time Tracker Blocking',
      'description':
          'Watch as we block invasive trackers in real-time. Our advanced filtering protects your privacy while you browse, keeping your digital footprint minimal.',
      'imageUrl':
          'https://images.unsplash.com/photo-1555949963-aa79dcee981c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'hasInteractive': true,
      'interactiveType': 'tracker_counter',
    },
    {
      'title': 'Earn ICR Tokens',
      'description':
          'Get rewarded for protecting your privacy! Earn ICR tokens while browsing securely. The more you protect yourself, the more you earn.',
      'imageUrl':
          'https://images.unsplash.com/photo-1621761191319-c6fb62004040?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'hasInteractive': true,
      'interactiveType': 'icr_accumulation',
    },
    {
      'title': 'Privacy Score Gamification',
      'description':
          'Track your privacy protection with our gamified scoring system. Complete missions, block trackers, and climb the leaderboard while staying secure.',
      'imageUrl':
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'hasInteractive': false,
    },
    {
      'title': 'Essential Permissions',
      'description':
          'To provide the best protection, we need a few permissions. All data collection follows GDPR guidelines with your explicit consent.',
      'imageUrl':
          'https://images.unsplash.com/photo-1614064641938-3bbee52942c7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'hasInteractive': true,
      'interactiveType': 'permissions',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/vpn-dashboard');
  }

  void _onPermissionsGranted() {
    setState(() {
      _permissionsGranted = true;
    });
  }

  Widget _buildInteractiveWidget(String type) {
    switch (type) {
      case 'vpn_toggle':
        return const InteractiveVpnToggleWidget();
      case 'tracker_counter':
        return const TrackerCounterWidget();
      case 'icr_accumulation':
        return const IcrAccumulationWidget();
      case 'permissions':
        return PermissionRequestWidget(
          onPermissionsGranted: _onPermissionsGranted,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Skip button
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  PageIndicatorWidget(
                    currentPage: _currentPage,
                    totalPages: _onboardingData.length,
                  ),
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                HapticFeedback.selectionClick();
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];

                if (index == _onboardingData.length - 1) {
                  // GDPR Compliance page
                  return SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 2.h),
                            CustomImageWidget(
                              imageUrl: data['imageUrl'],
                              width: 60.w,
                              height: 25.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              data['title'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              data['description'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            const GdprComplianceWidget(),
                            SizedBox(height: 2.h),
                            if (data['hasInteractive'] &&
                                data['interactiveType'] == 'permissions')
                              _buildInteractiveWidget(data['interactiveType']),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return OnboardingPageWidget(
                  title: data['title'],
                  description: data['description'],
                  imageUrl: data['imageUrl'],
                  interactiveWidget: data['hasInteractive']
                      ? _buildInteractiveWidget(data['interactiveType'])
                      : null,
                );
              },
            ),
          ),

          // Bottom navigation
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Row(
                children: [
                  // Back button
                  _currentPage > 0
                      ? TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'arrow_back',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Back',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(width: 80),

                  const Spacer(),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: (_currentPage == _onboardingData.length - 1 &&
                            !_permissionsGranted)
                        ? null
                        : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _onboardingData.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: _currentPage == _onboardingData.length - 1
                              ? 'check'
                              : 'arrow_forward',
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 5.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
