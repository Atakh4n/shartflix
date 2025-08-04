import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

// Profile Page'de kullanım için:
// void _showLimitedOffer() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => const PremiumOfferBottomSheet(),
//   );
// }

class PremiumOfferBottomSheet extends StatefulWidget {
  const PremiumOfferBottomSheet({super.key});

  @override
  State<PremiumOfferBottomSheet> createState() => _PremiumOfferBottomSheetState();
}

class _PremiumOfferBottomSheetState extends State<PremiumOfferBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int selectedPackageIndex = 1; // Orta paket varsayılan seçili

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePurchase() {
    // TODO: Implement purchase flow
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alma özelliği yakında eklenecek'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              height: screenHeight * 0.85,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8B0000), // Koyu kırmızı
                    Color(0xFF4A0000), // Daha koyu kırmızı
                    Color(0xFF2D0000), // En koyu kırmızı
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Close Button
                  _buildCloseButton(),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.spacing20),
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(),

                          const SizedBox(height: AppDimensions.spacing24),

                          // Bonus Features
                          _buildBonusFeatures(),

                          const SizedBox(height: AppDimensions.spacing32),

                          // Package Selection Text
                          _buildPackageSelectionText(),

                          const SizedBox(height: AppDimensions.spacing20),

                          // Token Packages
                          _buildTokenPackages(),

                          const SizedBox(height: AppDimensions.spacing32),

                          // Purchase Button
                          _buildPurchaseButton(),

                          const SizedBox(height: AppDimensions.spacing20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.textPrimary,
              size: AppDimensions.iconMedium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Sınırlı Teklif',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacing8),

        Text(
          'Jeton paketi\'ni seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBonusFeatures() {
    return Column(
      children: [
        Text(
          'Alacağınız Bonuslar',
          style: AppTextStyles.h6.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: AppDimensions.spacing16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBonusItem(
              icon: Icons.diamond_outlined,
              label: 'Premium\nHesap',
            ),
            _buildBonusItem(
              icon: Icons.favorite_outline,
              label: 'Daha\nFazla Eğlence',
            ),
            _buildBonusItem(
              icon: Icons.trending_up,
              label: 'Öne\nÇıkarma',
            ),
            _buildBonusItem(
              icon: Icons.thumb_up_outlined,
              label: 'Daha\nFazla Beğeni',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBonusItem({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: AppColors.textPrimary,
            size: AppDimensions.iconMedium,
          ),
        ),

        const SizedBox(height: AppDimensions.spacing8),

        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPackageSelectionText() {
    return Text(
      'Kilit açmak için bir jeton paketi seçin',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary.withOpacity(0.9),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTokenPackages() {
    final packages = [
      {
        'discount': '+10%',
        'tokens': '200',
        'bonus': '330',
        'price': '₺99,99',
        'note': 'Başlangıç Paketik',
        'color': const Color(0xFF8B0000),
      },
      {
        'discount': '+70%',
        'tokens': '2.000',
        'bonus': '5.375',
        'price': '₺799,99',
        'note': 'Başlangıç Paketik',
        'color': const Color(0xFF4A148C),
        'isPopular': true,
      },
      {
        'discount': '+35%',
        'tokens': '1.000',
        'bonus': '1.350',
        'price': '₺399,99',
        'note': 'Başlangıç Paketik',
        'color': const Color(0xFF8B0000),
      },
    ];

    return Row(
      children: packages.asMap().entries.map((entry) {
        final index = entry.key;
        final package = entry.value;
        final isSelected = selectedPackageIndex == index;
        final isPopular = package['isPopular'] == true;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedPackageIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: index == 1 ? 0 : AppDimensions.spacing4,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing12),
                    decoration: BoxDecoration(
                      color: package['color'] as Color,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      border: isSelected
                          ? Border.all(
                        color: AppColors.textPrimary,
                        width: 2,
                      )
                          : null,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        // Discount Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            package['discount'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing8),

                        // Original Tokens
                        Text(
                          package['tokens'] as String,
                          style: AppTextStyles.h5.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Bonus Tokens
                        Text(
                          package['bonus'] as String,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing4),

                        Text(
                          'Jeton',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.8),
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing8),

                        // Price
                        Text(
                          package['price'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spacing4),

                        Text(
                          package['note'] as String,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  if (isPopular)
                    Positioned(
                      top: -5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            'EN POPÜLER',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF4444),
            Color(0xFFCC0000),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handlePurchase,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacing16,
            ),
            child: Text(
              'Tüm Jetonları Gör',
              style: AppTextStyles.buttonLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}