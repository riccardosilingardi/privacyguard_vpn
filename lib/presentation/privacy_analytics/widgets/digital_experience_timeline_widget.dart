import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DigitalExperienceTimelineWidget extends StatefulWidget {
  final List<Map<String, dynamic>> timelineData;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const DigitalExperienceTimelineWidget({
    Key? key,
    required this.timelineData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<DigitalExperienceTimelineWidget> createState() =>
      _DigitalExperienceTimelineWidgetState();
}

class _DigitalExperienceTimelineWidgetState
    extends State<DigitalExperienceTimelineWidget> {
  final List<String> _periods = ['24h', '7d', '30d'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Digital Experience',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: _periods.map((period) {
                    final isSelected = widget.selectedPeriod == period;
                    return GestureDetector(
                      onTap: () => widget.onPeriodChanged(period),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          period,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 20.h,
            child: CustomPaint(
              painter: TimelineChartPainter(
                data: widget.timelineData,
                primaryColor: AppTheme.lightTheme.primaryColor,
                accentColor: AppTheme.secondaryLight,
              ),
              child: Container(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimelineMetric(
                  'Threats Blocked', '1,247', AppTheme.errorLight),
              _buildTimelineMetric(
                  'Data Saved', '2.3 GB', AppTheme.secondaryLight),
              _buildTimelineMetric(
                  'Time Protected', '18h 42m', AppTheme.successLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineMetric(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}

class TimelineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color primaryColor;
  final Color accentColor;

  TimelineChartPainter({
    required this.data,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    if (data.isEmpty) return;

    final maxValue = data
        .map((e) => (e['value'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final stepX = size.width / (data.length - 1);

    // Start fill path from bottom
    fillPath.moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height -
          ((data[i]['value'] as num).toDouble() / maxValue) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw data points
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill,
      );
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
