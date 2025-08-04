import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final bool showFavoriteButton;
  final double? width;
  final double? height;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoritePressed,
    this.showFavoriteButton = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? AppDimensions.movieCardWidth,
        height: height ?? AppDimensions.movieCardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.movieCardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppDimensions.shadowBlurRadius,
              offset: const Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.movieCardRadius),
          child: Stack(
            children: [
              // Movie Poster
              _buildPoster(),

              // Gradient Overlay
              _buildGradientOverlay(),

              // Content
              _buildContent(),

              // Favorite Button
              if (showFavoriteButton) _buildFavoriteButton(),

              // Rating Badge
              _buildRatingBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPoster() {
    return Positioned.fill(
      child: movie.fullPosterUrl.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: movie.fullPosterUrl,
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
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.inputBackground,
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 40,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              AppColors.background.withAlpha(128),
              AppColors.background.withAlpha(230),
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: AppDimensions.spacing8,
      right: AppDimensions.spacing8,
      bottom: AppDimensions.spacing8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            movie.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          if (movie.formattedReleaseDate.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              movie.formattedReleaseDate,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: AppDimensions.spacing8,
      right: AppDimensions.spacing8,
      child: GestureDetector(
        onTap: onFavoritePressed,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          decoration: BoxDecoration(
            color: AppColors.background.withAlpha(128),
            shape: BoxShape.circle,
          ),
          child: Icon(
            movie.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: movie.isFavorite ? AppColors.primary : AppColors.textPrimary,
            size: AppDimensions.iconMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    if (movie.voteAverage == null || movie.voteAverage! <= 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: AppDimensions.spacing8,
      left: AppDimensions.spacing8,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing2,
          vertical: AppDimensions.spacing2,
        ),
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(180),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 12,
            ),
            const SizedBox(width: AppDimensions.spacing2),
            Text(
              movie.formattedRating,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Horizontal Movie Card for lists
class HorizontalMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;

  const HorizontalMovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingHorizontal,
          vertical: AppDimensions.spacing8,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppDimensions.shadowBlurRadius,
              offset: const Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        child: Row(
          children: [
            // Poster
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMedium),
                bottomLeft: Radius.circular(AppDimensions.radiusMedium),
              ),
              child: SizedBox(
                width: 100,
                height: 120,
                child: movie.fullPosterUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: movie.fullPosterUrl,
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
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.inputBackground,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
                    : Container(
                  color: AppColors.inputBackground,
                  child: const Center(
                    child: Icon(
                      Icons.movie,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (movie.overview?.isNotEmpty == true) ...[
                      const SizedBox(height: AppDimensions.spacing4),
                      Text(
                        movie.overview!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: AppDimensions.spacing8),

                    Row(
                      children: [
                        if (movie.voteAverage != null && movie.voteAverage! > 0) ...[
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: AppDimensions.spacing4),
                          Text(
                            movie.formattedRating,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacing12),
                        ],

                        if (movie.formattedReleaseDate.isNotEmpty)
                          Text(
                            movie.formattedReleaseDate,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Favorite Button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing8),
              child: GestureDetector(
                onTap: onFavoritePressed,
                child: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: movie.isFavorite ? AppColors.primary : AppColors.textSecondary,
                  size: AppDimensions.iconMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}