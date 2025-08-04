import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final String? title;
  final bool showTitle;
  final Axis scrollDirection; // ScrollDirection yerine Axis kullanıldı
  final EdgeInsetsGeometry? padding;
  final double? height;
  final int? itemCount;
  final VoidCallback? onSeeAll;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoritePressed;
  final bool showFavoriteButton;
  final bool showSeeAllButton;

  const MovieList({
    super.key,
    required this.movies,
    this.title,
    this.showTitle = true,
    this.scrollDirection = Axis.horizontal,
    this.padding,
    this.height,
    this.itemCount,
    this.onSeeAll,
    this.onMovieTap,
    this.onFavoritePressed,
    this.showFavoriteButton = true,
    this.showSeeAllButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayMovies = itemCount != null && itemCount! < movies.length
        ? movies.take(itemCount!).toList()
        : movies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle && title != null) ...[
          Padding(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showSeeAllButton && onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: Text(
                      'Tümünü Gör',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacing12),
        ],

        if (scrollDirection == Axis.horizontal)
          _buildHorizontalList(displayMovies)
        else
          _buildVerticalList(displayMovies),
      ],
    );
  }

  Widget _buildHorizontalList(List<Movie> displayMovies) {
    return SizedBox(
      height: height ?? (AppDimensions.movieCardHeight + 40),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingHorizontal,
        ),
        itemCount: displayMovies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == displayMovies.length - 1
                  ? 0
                  : AppDimensions.spacing12,
            ),
            child: MovieCard(
              movie: displayMovies[index],
              onTap: () => onMovieTap?.call(displayMovies[index]),
              onFavoritePressed: () => onFavoritePressed?.call(displayMovies[index]),
              showFavoriteButton: showFavoriteButton,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalList(List<Movie> displayMovies) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingHorizontal,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: AppDimensions.spacing12,
          mainAxisSpacing: AppDimensions.spacing16,
        ),
        itemCount: displayMovies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            movie: displayMovies[index],
            onTap: () => onMovieTap?.call(displayMovies[index]),
            onFavoritePressed: () => onFavoritePressed?.call(displayMovies[index]),
            showFavoriteButton: showFavoriteButton,
          );
        },
      ),
    );
  }
}

// Specialized Movie Lists
class PopularMoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoritePressed;
  final VoidCallback? onSeeAll;

  const PopularMoviesList({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoritePressed,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return MovieList(
      movies: movies,
      title: 'Popüler Filmler',
      itemCount: 10,
      onMovieTap: onMovieTap,
      onFavoritePressed: onFavoritePressed,
      onSeeAll: onSeeAll,
    );
  }
}

class TrendingMoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoritePressed;
  final VoidCallback? onSeeAll;

  const TrendingMoviesList({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoritePressed,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return MovieList(
      movies: movies,
      title: 'Trend Filmler',
      itemCount: 10,
      onMovieTap: onMovieTap,
      onFavoritePressed: onFavoritePressed,
      onSeeAll: onSeeAll,
    );
  }
}

class FavoriteMoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoritePressed;
  final bool showAsGrid;

  const FavoriteMoviesList({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoritePressed,
    this.showAsGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return _buildEmptyState();
    }

    return MovieList(
      movies: movies,
      title: 'Favori Filmlerim',
      scrollDirection: showAsGrid ? Axis.vertical : Axis.horizontal,
      onMovieTap: onMovieTap,
      onFavoritePressed: onFavoritePressed,
      showSeeAllButton: false,
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.textTertiary,
          ),

          const SizedBox(height: AppDimensions.spacing16),

          Text(
            'Henüz favori film eklemediniz',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacing8),

          Text(
            'Beğendiğiniz filmleri favorilere ekleyerek kolayca bulabilirsiniz',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SearchResultsList extends StatelessWidget {
  final List<Movie> movies;
  final String searchQuery;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoritePressed;
  final bool isLoading;

  const SearchResultsList({
    super.key,
    required this.movies,
    required this.searchQuery,
    this.onMovieTap,
    this.onFavoritePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (movies.isEmpty && searchQuery.isNotEmpty) {
      return _buildEmptySearchState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchQuery.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
            ),
            child: Text(
              'Arama Sonuçları (${movies.length})',
              style: AppTextStyles.h6.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
        ],

        MovieList(
          movies: movies,
          showTitle: false,
          scrollDirection: Axis.vertical,
          onMovieTap: onMovieTap,
          onFavoritePressed: onFavoritePressed,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacing32),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),

            const SizedBox(height: AppDimensions.spacing16),

            Text(
              'Aradığınız film bulunamadı',
              style: AppTextStyles.h6.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacing8),

            Text(
              'Farklı anahtar kelimeler deneyin',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}