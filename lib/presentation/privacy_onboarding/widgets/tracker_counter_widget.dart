import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrackerCounterWidget extends StatefulWidget {
  const TrackerCounterWidget({Key? key}) : super(key: key);

  @override
  State<TrackerCounterWidget> createState() => _TrackerCounterWidgetState();
}

class _TrackerCounterWidgetState extends State<TrackerCounterWidget>
    with SingleTickerProviderStateMixin {
  int _blockedCount = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startSimulation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startSimulation() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _incrementCounter();
      }
    });
  }

  void _incrementCounter() {
    if (_blockedCount < 47) {
      setState(() {
        _blockedCount++;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      Future.delayed(Duration(milliseconds: _blockedCount < 20 ? 200 : 400),
          () {
        if (mounted) {
          _incrementCounter();
        }
      });
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
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'block',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Text(
                    '$_blockedCount',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                  );
                },
              ),
              Text(
                'Trackers Blocked',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
