import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bloc/auth/auth_bloc.dart';

// Bu sadece SplashPageContent widget'ı
// Ana SplashPage wrapper'ı app_router.dart'ta tanımlı

class SplashPageContent extends StatefulWidget {
  const SplashPageContent({super.key});

  @override
  State<SplashPageContent> createState() => _SplashPageContentState();
}

class _SplashPageContentState extends State<SplashPageContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() async {
    // Start animations
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo Animation
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              children: [
                                // App Icon/Logo
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: AppColors.primaryGradient,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    size: 60,
                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: AppDimensions.spacing24),

                                // App Name
                                Text(
                                  'Shartflix',
                                  style: AppTextStyles.h1.copyWith(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: AppDimensions.spacing8),

                                // Subtitle
                                Text(
                                  'Sınırsız Eğlence',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // Loading Animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Loading indicator
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacing16),

                      // Loading text with state info
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String statusText = 'Yükleniyor...';

                          if (state is AuthLoading) {
                            statusText = 'Kontrol ediliyor...';
                          } else if (state is AuthAuthenticated) {
                            statusText = 'Hoş geldiniz!';
                          } else if (state is AuthUnauthenticated) {
                            statusText = 'Giriş sayfasına yönlendiriliyorsunuz...';
                          }

                          return Column(
                            children: [
                              Text(
                                statusText,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),

                              // Debug info - production'da kaldırılabilir
                              if (kDebugMode) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'State: ${state.runtimeType}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textTertiary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Version and Copyright
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacing20),
                    child: Column(
                      children: [
                        Text(
                          'v1.0.0',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing4),

                        Text(
                          '© 2025 Shartflix. Tüm hakları saklıdır.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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