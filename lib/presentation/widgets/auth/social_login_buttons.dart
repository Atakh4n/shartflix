import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;
  final String? loadingProvider;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
    this.loadingProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google Login Button
        Expanded(
          child: _SocialButton(
            provider: 'Google',
            icon: Icons.g_mobiledata,
            backgroundColor: AppColors.google,
            onPressed: onGooglePressed,
            isLoading: isLoading && loadingProvider == 'google',
          ),
        ),

        const SizedBox(width: AppDimensions.spacing12),

        // Apple Login Button
        Expanded(
          child: _SocialButton(
            provider: 'Apple',
            icon: Icons.apple,
            backgroundColor: AppColors.apple,
            onPressed: onApplePressed,
            isLoading: isLoading && loadingProvider == 'apple',
          ),
        ),

        const SizedBox(width: AppDimensions.spacing12),

        // Facebook Login Button
        Expanded(
          child: _SocialButton(
            provider: 'Facebook',
            icon: Icons.facebook,
            backgroundColor: AppColors.facebook,
            onPressed: onFacebookPressed,
            isLoading: isLoading && loadingProvider == 'facebook',
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String provider;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.provider,
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.inputBorder.withAlpha(50),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing12,
              vertical: AppDimensions.spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                    ),
                  ),
                ] else ...[
                  Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconMedium,
                  ),
                ],
                const SizedBox(width: AppDimensions.spacing8),
                Flexible(
                  child: Text(
                    provider,
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative Compact Social Login Buttons
class CompactSocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;
  final String? loadingProvider;

  const CompactSocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
    this.loadingProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google
        _CompactSocialButton(
          icon: Icons.g_mobiledata,
          backgroundColor: AppColors.google,
          onPressed: onGooglePressed,
          isLoading: isLoading && loadingProvider == 'google',
        ),

        // Apple
        _CompactSocialButton(
          icon: Icons.apple,
          backgroundColor: AppColors.apple,
          onPressed: onApplePressed,
          isLoading: isLoading && loadingProvider == 'apple',
        ),

        // Facebook
        _CompactSocialButton(
          icon: Icons.facebook,
          backgroundColor: AppColors.facebook,
          onPressed: onFacebookPressed,
          isLoading: isLoading && loadingProvider == 'facebook',
        ),
      ],
    );
  }
}

class _CompactSocialButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _CompactSocialButton({
    required this.icon,
    required this.backgroundColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.inputBorder.withAlpha(50),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
              ),
            )
                : Icon(
              icon,
              color: AppColors.textPrimary,
              size: AppDimensions.iconLarge,
            ),
          ),
        ),
      ),
    );
  }
}

// Full Width Social Login Buttons
class FullWidthSocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;
  final String? loadingProvider;

  const FullWidthSocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.isLoading = false,
    this.loadingProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Button
        CustomButton(
          text: 'Google ile devam et',
          onPressed: onGooglePressed,
          type: CustomButtonType.social,
          backgroundColor: AppColors.google,
          icon: const Icon(
            Icons.g_mobiledata,
            color: AppColors.textPrimary,
          ),
          isLoading: isLoading && loadingProvider == 'google',
        ),

        const SizedBox(height: AppDimensions.spacing12),

        // Apple Button
        CustomButton(
          text: 'Apple ile devam et',
          onPressed: onApplePressed,
          type: CustomButtonType.social,
          backgroundColor: AppColors.apple,
          icon: const Icon(
            Icons.apple,
            color: AppColors.textPrimary,
          ),
          isLoading: isLoading && loadingProvider == 'apple',
        ),

        const SizedBox(height: AppDimensions.spacing12),

        // Facebook Button
        CustomButton(
          text: 'Facebook ile devam et',
          onPressed: onFacebookPressed,
          type: CustomButtonType.social,
          backgroundColor: AppColors.facebook,
          icon: const Icon(
            Icons.facebook,
            color: AppColors.textPrimary,
          ),
          isLoading: isLoading && loadingProvider == 'facebook',
        ),
      ],
    );
  }
}