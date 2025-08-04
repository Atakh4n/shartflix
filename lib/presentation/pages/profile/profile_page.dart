import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/navigation_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../../injection.dart';
// import '../../../l10n/app_localizations.dart'; // Geçici olarak kapatıldı
import '../../../widgets/custom_button.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../routes/app_router.dart';
import '../../widgets/profile/profile_avatar.dart';
import '../../widgets/profile/profile_menu_item.dart';
import '../../widgets/profile/premium_offer_bottom_sheet.dart';

class ProfilePageContent extends StatefulWidget {
  const ProfilePageContent({super.key});

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  final NavigationService _navigationService = getIt<NavigationService>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing24),

                Text(
                  'Profil Fotoğrafı',
                  style: AppTextStyles.h6.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacing24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Kamera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Galeri',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconLarge,
            ),
          ),

          const SizedBox(height: AppDimensions.spacing8),

          Text(
            label,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      context.read<ProfileBloc>().add(UploadProfileImage(imagePath: pickedFile.path));
    }
  }

  void _showLimitedOffer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumOfferBottomSheet(),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Çıkış Yap',
          style: AppTextStyles.h6,
        ),
        content: Text(
          'Hesabınızdan çıkmak istediğinize emin misiniz?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'İptal',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text(
              'Çıkış Yap',
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

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!; // Geçici olarak kapatıldı

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            _navigationService.pushAndClearStack(const LoginRoute());
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.spacing24),

                // Profile Header
                _buildProfileHeader(),

                const SizedBox(height: AppDimensions.spacing40),

                // Premium Offer Banner
                if (!_isPremiumUser()) _buildPremiumBanner(),

                const SizedBox(height: AppDimensions.spacing24),

                // Menu Items
                _buildMenuItems(),

                const SizedBox(height: AppDimensions.spacing40),

                // Logout Button
                _buildLogoutButton(),

                const SizedBox(height: AppDimensions.spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Column(
            children: [
              Stack(
                children: [
                  ProfileAvatar(
                    imageUrl: state.user.profileImageUrl,
                    radius: 50,
                    onTap: _showImagePicker,
                    showEditIcon: true,
                    initials: state.user.initials,
                  ),

                  // Upload Progress Indicator (görünür sadece yükleme sırasında)
                  if (state is ProfileImageUploading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacing16),

              Text(
                state.user.fullName,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing4),

              Text(
                state.user.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              if (state.user.isPremium) ...[
                const SizedBox(height: AppDimensions.spacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing4,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ],
          );
        }

        // Loading state için skeleton
        return Column(
          children: [
            Stack(
              children: [
                const ProfileAvatar(
                  radius: 50,
                  showEditIcon: true,
                ),

                if (state is ProfileImageUploading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacing16),

            // Name skeleton
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),

            const SizedBox(height: AppDimensions.spacing8),

            // Email skeleton
            Container(
              width: 160,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPremiumBanner() {
    return GestureDetector(
      onTap: _showLimitedOffer,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8B0000), // Koyu kırmızı
              Color(0xFFCC0000), // Kırmızı
              Color(0xFFFF4444), // Açık kırmızı
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(77),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star,
                color: AppColors.textPrimary,
                size: AppDimensions.iconLarge,
              ),
            ),

            const SizedBox(width: AppDimensions.spacing12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sınırlı Teklif!',
                    style: AppTextStyles.h6.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacing4),

                  Text(
                    'Jeton paketi seç, bonus kazan!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary.withAlpha(204),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing8,
                vertical: AppDimensions.spacing4,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Text(
                '+70% BONUS',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.spacing8),

            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textPrimary,
              size: AppDimensions.iconSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ProfileMenuItem(
          icon: Icons.person_outline,
          title: 'Profili Düzenle',
          subtitle: 'Kişisel bilgilerini güncelle',
          onTap: () {
            // TODO: Navigate to edit profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil düzenleme sayfası yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.favorite_outline,
          title: 'Favorilerim', // l10n.favorites yerine
          subtitle: 'Beğendiğin içerikler',
          onTap: () {
            // TODO: Navigate to favorites
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Favoriler sayfası yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.download_outlined,
          title: 'İndirilenler',
          subtitle: 'Çevrimdışı içerikler',
          onTap: () {
            // TODO: Navigate to downloads
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('İndirilenler sayfası yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Jeton Cüzdanım',
          subtitle: 'Jeton bakiyesi ve geçmiş',
          onTap: () {
            // TODO: Navigate to wallet
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jeton cüzdanı yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Ayarlar', // l10n.settings yerine
          subtitle: 'Uygulama ayarları',
          onTap: () {
            // TODO: Navigate to settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ayarlar sayfası yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.help_outline,
          title: 'Yardım & Destek',
          subtitle: 'SSS ve iletişim',
          onTap: () {
            // TODO: Navigate to help
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Yardım sayfası yakında eklenecek'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        ),

        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'Hakkında',
          subtitle: 'Sürüm bilgileri',
          onTap: () {
            // TODO: Navigate to about
            _showAboutDialog();
          },
        ),
      ],
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppDimensions.spacing8),
            Text(
              'Shartflix Hakkında',
              style: AppTextStyles.h6,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shartflix',
              style: AppTextStyles.h5.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'Sürüm: 1.0.0',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              'Netflix tarzında eğlenceli içerik platformu',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tamam',
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

  Widget _buildLogoutButton() {
    return CustomButton(
      text: 'Çıkış Yap', // l10n.logout yerine
      onPressed: _logout,
      type: CustomButtonType.outline,
      borderColor: AppColors.error,
      textColor: AppColors.error,
      icon: const Icon(
        Icons.logout,
        color: AppColors.error,
        size: AppDimensions.iconMedium,
      ),
    );
  }

  bool _isPremiumUser() {
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      return state.user.isPremium;
    }
    return false;
  }
}