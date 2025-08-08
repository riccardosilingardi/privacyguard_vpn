import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GdprComplianceWidget extends StatefulWidget {
  const GdprComplianceWidget({Key? key}) : super(key: key);

  @override
  State<GdprComplianceWidget> createState() => _GdprComplianceWidgetState();
}

class _GdprComplianceWidgetState extends State<GdprComplianceWidget> {
  bool _analyticsOptIn = false;
  bool _personalizationOptIn = false;

  final List<Map<String, dynamic>> _dataOptions = [
    {
      'title': 'Analytics & Performance',
      'description': 'Help us improve the app with anonymous usage data',
      'icon': 'analytics',
      'required': false,
    },
    {
      'title': 'Personalization',
      'description': 'Customize your experience based on preferences',
      'icon': 'person',
      'required': false,
    },
  ];

  void _toggleOption(int index) {
    setState(() {
      switch (index) {
        case 0:
          _analyticsOptIn = !_analyticsOptIn;
          break;
        case 1:
          _personalizationOptIn = !_personalizationOptIn;
          break;
      }
    });
  }

  bool _getOptionStatus(int index) {
    switch (index) {
      case 0:
        return _analyticsOptIn;
      case 1:
        return _personalizationOptIn;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Privacy Matters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'We follow GDPR guidelines and never collect personal data without your consent.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Optional Data Collection',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 2.h),
        ...List.generate(_dataOptions.length, (index) {
          final option = _dataOptions[index];
          final isEnabled = _getOptionStatus(index);

          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: option['icon'],
                  color: isEnabled
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                  size: 6.w,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        option['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Switch(
                  value: isEnabled,
                  onChanged: (value) => _toggleOption(index),
                  activeColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Text(
            'You can change these preferences anytime in Settings. We never share your data with third parties.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
