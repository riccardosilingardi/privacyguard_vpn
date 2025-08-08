import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class IcrAccumulationWidget extends StatefulWidget {
  const IcrAccumulationWidget({Key? key}) : super(key: key);

  @override
  State<IcrAccumulationWidget> createState() => _IcrAccumulationWidgetState();
}

class _IcrAccumulationWidgetState extends State<IcrAccumulationWidget>
    with SingleTickerProviderStateMixin {
  double _icrBalance = 0.0;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _startAccumulation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAccumulation() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _addIcr();
      }
    });
  }

  void _addIcr() {
    if (_icrBalance < 12.47) {
      setState(() {
        _icrBalance += 0.23;
      });

      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _addIcr();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _bounceAnimation.value,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                  child: Center(
                    child: Text(
                      'I',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 3.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_icrBalance.toStringAsFixed(2)} ICR',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Earned Today',
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
