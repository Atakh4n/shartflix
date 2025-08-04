import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final String? initials;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.onTap,
    this.showEditIcon = false,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.inputBackground,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(),
              )
                  : _buildPlaceholder(),
            ),
          ),

          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: radius * 0.6,
                height: radius * 0.6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.textPrimary,
                  size: radius * 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.inputBackground,
      child: Center(
        child: Text(
          initials ?? 'U',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}