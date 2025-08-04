import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacing16,
                horizontal: AppDimensions.spacing4,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.textPrimary,
                    size: AppDimensions.iconMedium,
                  ),

                  const SizedBox(width: AppDimensions.spacing16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        if (subtitle != null) ...[
                          const SizedBox(height: AppDimensions.spacing2),
                          Text(
                            subtitle!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  trailing ??
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textTertiary,
                        size: AppDimensions.iconSmall,
                      ),
                ],
              ),
            ),
          ),
        ),

        if (showDivider)
          const Divider(
            color: AppColors.divider,
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}