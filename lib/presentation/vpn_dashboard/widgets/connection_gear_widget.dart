import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ConnectionGearWidget extends StatefulWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onTap;

  const ConnectionGearWidget({
    Key? key,
    required this.isConnected,
    required this.isConnecting,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ConnectionGearWidget> createState() => _ConnectionGearWidgetState();
}

class _ConnectionGearWidgetState extends State<ConnectionGearWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isConnecting) {
      _rotationController.repeat();
    }
    if (widget.isConnected) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ConnectionGearWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnecting && !oldWidget.isConnecting) {
      _rotationController.repeat();
      _pulseController.stop();
    } else if (widget.isConnected && !oldWidget.isConnected) {
      _rotationController.stop();
      _pulseController.repeat(reverse: true);
    } else if (!widget.isConnecting && !widget.isConnected) {
      _rotationController.stop();
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _getGearColor() {
    if (widget.isConnected) {
      return AppTheme.successLight;
    } else if (widget.isConnecting) {
      return AppTheme.secondaryLight;
    } else {
      return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 45.w,
        height: 45.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: AnimatedBuilder(
            animation:
                widget.isConnecting ? _rotationAnimation : _pulseAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: widget.isConnecting
                    ? _rotationAnimation.value * 2 * 3.14159
                    : 0,
                child: Transform.scale(
                  scale: widget.isConnected ? _pulseAnimation.value : 1.0,
                  child: CustomIconWidget(
                    iconName: 'settings',
                    color: _getGearColor(),
                    size: 20.w,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
