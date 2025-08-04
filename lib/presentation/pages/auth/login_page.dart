import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../routes/app_router.dart';
import '../../widgets/auth/social_login_buttons.dart';
import '../../widgets/common/test_credentials_info.dart';

class LoginPageContent extends StatefulWidget {
  const LoginPageContent({super.key});

  @override
  State<LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleSocialLogin(String provider) {
    context.read<AuthBloc>().add(
      SocialLoginRequested(provider: provider),
    );
  }

  void _navigateToRegister() {
    // Register sayfasına git
    context.router.push(const RegisterRoute());
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre sıfırlama özelliği yakında eklenecek'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.spacing40),

              // Header
              _buildHeader(l10n),

              const SizedBox(height: AppDimensions.spacing24),

              // Test Credentials Info (Development için)
              const TestCredentialsInfo(),

              const SizedBox(height: AppDimensions.spacing24),

              // Login Form
              _buildLoginForm(l10n),

              const SizedBox(height: AppDimensions.spacing24),

              // Forgot Password
              _buildForgotPassword(l10n),

              const SizedBox(height: AppDimensions.spacing32),

              // Login Button
              _buildLoginButton(l10n),

              const SizedBox(height: AppDimensions.spacing32),

              // Social Login
              _buildSocialLogin(l10n),

              const SizedBox(height: AppDimensions.spacing40),

              // Register Link
              _buildRegisterLink(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhabalar',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          'Hesabınıza giriş yapın',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          CustomTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            type: CustomTextFieldType.email,
            hintText: l10n.email,
            validator: Validators.email,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: AppDimensions.spacing16),

          // Password Field
          CustomTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            type: CustomTextFieldType.password,
            hintText: l10n.password,
            validator: Validators.password,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleLogin(),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: AppColors.inputHint,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            obscureText: !_isPasswordVisible,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          l10n.forgotPassword,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return CustomButton(
          text: l10n.login,
          onPressed: _handleLogin,
          isLoading: state is AuthLoading,
          type: CustomButtonType.primary,
        );
      },
    );
  }

  Widget _buildSocialLogin(AppLocalizations l10n) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.divider),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
              ),
              child: Text(
                l10n.orContinueWith,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.divider),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacing24),

        // Social Login Buttons
        SocialLoginButtons(
          onGooglePressed: () => _handleSocialLogin('google'),
          onApplePressed: () => _handleSocialLogin('apple'),
          onFacebookPressed: () => _handleSocialLogin('facebook'),
        ),
      ],
    );
  }

  Widget _buildRegisterLink(AppLocalizations l10n) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.dontHaveAccount,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: _navigateToRegister,
            child: Text(
              l10n.signUpNow,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Login Page with additional features
class EnhancedLoginPage extends StatefulWidget {
  const EnhancedLoginPage({super.key});

  @override
  State<EnhancedLoginPage> createState() => _EnhancedLoginPageState();
}

class _EnhancedLoginPageState extends State<EnhancedLoginPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: const LoginPageContent(),
          ),
        ),
      ),
    );
  }
}