import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThreatCategoriesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Function(Map<String, dynamic>) onCategoryTap;

  const ThreatCategoriesWidget({
    Key? key,
    required this.categories,
    required this.onCategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            'Threat Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            itemCount: categories.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => onCategoryTap(category),
                child: Container(
                  width: 25.w,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category['type'] as String)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName:
                                _getCategoryIcon(category['type'] as String),
                            color:
                                _getCategoryColor(category['type'] as String),
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${category['count']}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        category['type'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String type) {
    switch (type.toLowerCase()) {
      case 'ads':
        return AppTheme.errorLight;
      case 'trackers':
        return Colors.orange;
      case 'malware':
        return Colors.red;
      case 'analytics':
        return Colors.purple;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getCategoryIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ads':
        return 'block';
      case 'trackers':
        return 'visibility_off';
      case 'malware':
        return 'security';
      case 'analytics':
        return 'analytics';
      default:
        return 'shield';
    }
  }
}
