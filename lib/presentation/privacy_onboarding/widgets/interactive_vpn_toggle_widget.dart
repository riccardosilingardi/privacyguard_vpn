import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InteractiveVpnToggleWidget extends StatefulWidget {
  const InteractiveVpnToggleWidget({Key? key}) : super(key: key);

  @override
  State<InteractiveVpnToggleWidget> createState() =>
      _InteractiveVpnToggleWidgetState();
}

class _InteractiveVpnToggleWidgetState extends State<InteractiveVpnToggleWidget>
    with SingleTickerProviderStateMixin {
  bool _isConnected = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVpn() {
    HapticFeedback.lightImpact();
    setState(() {
      _isConnected = !_isConnected;
    });

    if (_isConnected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: _isConnected
              ? AppTheme.lightTheme.colorScheme.tertiary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _toggleVpn,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isConnected
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      boxShadow: _isConnected
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: CustomIconWidget(
                      iconName: _isConnected ? 'shield' : 'shield_outlined',
                      color: _isConnected
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                      size: 8.w,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          Text(
            _isConnected ? 'VPN Connected' : 'Tap to Connect',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _isConnected
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
