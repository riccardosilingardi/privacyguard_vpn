import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PrivacyToggleWidget extends StatefulWidget {
  final String selectedMode;
  final Function(String) onModeChanged;

  const PrivacyToggleWidget({
    Key? key,
    required this.selectedMode,
    required this.onModeChanged,
  }) : super(key: key);

  @override
  State<PrivacyToggleWidget> createState() => _PrivacyToggleWidgetState();
}

class _PrivacyToggleWidgetState extends State<PrivacyToggleWidget> {
  final List<String> _modes = ['FULL BLOCK', 'SMART', 'OPEN'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: _modes.map((mode) {
          final isSelected = widget.selectedMode == mode;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onModeChanged(mode),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    mode,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
