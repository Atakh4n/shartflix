import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
        title!,
        style: AppTextStyles.h5.copyWith(
          fontWeight: FontWeight.bold,
        ),
      )
          : null,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: elevation,
      bottom: bottom,
      shape: elevation > 0
          ? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppDimensions.radiusMedium),
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
  );
}