import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_dimensions.dart';
import '/core/theme/app_text_styles.dart';


enum CustomButtonType {
  primary,
  secondary,
  outline,
  text,
  social,
}

enum CustomButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.large,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? _getButtonHeight(),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? _getGradient(),
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: boxShadow,
          border: _getBorder(),
        ),
        child: Material(
          color: gradient != null ? Colors.transparent : _getBackgroundColor(),
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
          child: InkWell(
            onTap: _isEnabled() ? onPressed : null,
            borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusMedium),
            child: Container(
              padding: padding ?? _getPadding(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && !isLoading) ...[
                    icon!,
                    const SizedBox(width: AppDimensions.spacing8),
                  ],
                  if (isLoading) ...[
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: _getTextStyle(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (suffixIcon != null && !isLoading) ...[
                    const SizedBox(width: AppDimensions.spacing8),
                    suffixIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isEnabled() => !isDisabled && !isLoading && onPressed != null;

  double _getButtonHeight() {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case CustomButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case CustomButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.iconSmall;
      case CustomButtonSize.medium:
        return AppDimensions.iconMedium;
      case CustomButtonSize.large:
        return AppDimensions.iconMedium;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        );
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        );
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
          vertical: AppDimensions.spacing16,
        );
    }
  }

  Color _getBackgroundColor() {
    if (!_isEnabled()) {
      return AppColors.buttonDisabled;
    }

    if (backgroundColor != null) {
      return backgroundColor!;
    }

    switch (type) {
      case CustomButtonType.primary:
        return AppColors.buttonPrimary;
      case CustomButtonType.secondary:
        return AppColors.buttonSecondary;
      case CustomButtonType.outline:
      case CustomButtonType.text:
        return Colors.transparent;
      case CustomButtonType.social:
        return AppColors.inputBackground;
    }
  }

  Color _getTextColor() {
    if (!_isEnabled()) {
      return AppColors.textTertiary;
    }

    if (textColor != null) {
      return textColor!;
    }

    switch (type) {
      case CustomButtonType.primary:
      case CustomButtonType.secondary:
      case CustomButtonType.social:
        return AppColors.textPrimary;
      case CustomButtonType.outline:
      case CustomButtonType.text:
        return AppColors.primary;
    }
  }

  TextStyle _getTextStyle() {
    final color = _getTextColor();

    switch (size) {
      case CustomButtonSize.small:
        return AppTextStyles.buttonSmall.copyWith(color: color);
      case CustomButtonSize.medium:
        return AppTextStyles.buttonMedium.copyWith(color: color);
      case CustomButtonSize.large:
        return AppTextStyles.buttonLarge.copyWith(color: color);
    }
  }

  Border? _getBorder() {
    if (type == CustomButtonType.outline) {
      return Border.all(
        color: borderColor ?? AppColors.inputBorder,
        width: 1,
      );
    }
    return null;
  }

  Gradient? _getGradient() {
    if (type == CustomButtonType.primary && gradient == null) {
      return const LinearGradient(
        colors: AppColors.primaryGradient,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
    return gradient;
  }
}

// Social Login Button
class SocialLoginButton extends StatelessWidget {
  final String provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.provider,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: '',
      onPressed: onPressed,
      type: CustomButtonType.social,
      size: CustomButtonSize.large,
      isLoading: isLoading,
      backgroundColor: _getBackgroundColor(),
      width: 60,
      height: 60,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      icon: _getIcon(),
    );
  }

  Color _getBackgroundColor() {
    switch (provider.toLowerCase()) {
      case 'google':
        return AppColors.google;
      case 'apple':
        return AppColors.apple;
      case 'facebook':
        return AppColors.facebook;
      default:
        return AppColors.inputBackground;
    }
  }

  Widget _getIcon() {
    switch (provider.toLowerCase()) {
      case 'google':
        return const Icon(
          Icons.g_mobiledata,
          color: AppColors.textPrimary,
          size: AppDimensions.iconLarge,
        );
      case 'apple':
        return const Icon(
          Icons.apple,
          color: AppColors.textPrimary,
          size: AppDimensions.iconLarge,
        );
      case 'facebook':
        return const Icon(
          Icons.facebook,
          color: AppColors.textPrimary,
          size: AppDimensions.iconLarge,
        );
      default:
        return const Icon(
          Icons.login,
          color: AppColors.textPrimary,
          size: AppDimensions.iconLarge,
        );
    }
  }
}

// Floating Action Button
class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: elevation ?? 6,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: child,
    );
  }
}

// Icon Button
class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Border? border;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.padding,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? AppDimensions.buttonHeightMedium,
      height: size ?? AppDimensions.buttonHeightMedium,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusSmall),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusSmall),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDimensions.spacing8),
            child: IconTheme(
              data: IconThemeData(
                color: iconColor ?? AppColors.textPrimary,
                size: AppDimensions.iconMedium,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}