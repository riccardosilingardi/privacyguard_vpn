import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final String membershipTier;
  final bool isExpanded;

  const ProfileHeaderWidget({
    Key? key,
    required this.userProfile,
    required this.membershipTier,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: isExpanded ? 6.h : 3.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(isExpanded ? 6.w : 3.w),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row with settings icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                IconButton(
                  onPressed: () {
                    // Open settings menu
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile settings opened'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 6.w,
                  ),
                ),
              ],
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded ? null : 0,
              child: isExpanded
                  ? Column(
                      children: [
                        SizedBox(height: 3.h),

                        // Avatar and Name
                        Row(
                          children: [
                            // Avatar with status indicator
                            Stack(
                              children: [
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.w),
                                    child: CachedNetworkImage(
                                      imageUrl: userProfile['avatarUrl'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                            .withValues(alpha: 0.2),
                                        child: CustomIconWidget(
                                          iconName: 'person',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          size: 8.w,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                            .withValues(alpha: 0.2),
                                        child: CustomIconWidget(
                                          iconName: 'person',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          size: 8.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSecondary,
                                      size: 3.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 4.w),

                            // Name and membership info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProfile['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    userProfile['email'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary
                                              .withValues(alpha: 0.8),
                                        ),
                                  ),
                                  SizedBox(height: 1.h),

                                  // Membership tier badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 0.8.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(2.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'star',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSecondary,
                                          size: 4.w,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          membershipTier,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onSecondary,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Stats row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Protected Sessions',
                                '${userProfile['totalProtectedSessions']}',
                                'verified_user',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 6.h,
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Blocked Trackers',
                                '${(userProfile['totalBlockedTrackers'] / 1000).toStringAsFixed(1)}k',
                                'block',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 6.h,
                              color: AppTheme.lightTheme.colorScheme.onPrimary
                                  .withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                context,
                                'Member Since',
                                _formatJoinDate(userProfile['joinDate']),
                                'calendar_today',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.7),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatJoinDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
