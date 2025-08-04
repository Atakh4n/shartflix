import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../domain/entities/movie.dart';
import '../../bloc/movie/movie_bloc.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/movie/movie_card.dart';
import '/presentation/widgets/movie/movie_list.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Search functionality için local state
  String _searchQuery = '';
  List<Movie> _filteredMovies = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupScrollListener();
  }

  void _initializeData() {
    // Yeni bloc yapısında tek event ile tüm kategoriler yükleniyor
    context.read<MovieBloc>().add(LoadMovies());
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load more data when near bottom - şu an trending kategorisi için
        final state = context.read<MovieBloc>().state;
        if (state is MovieLoaded) {
          context.read<MovieBloc>().add(LoadMoreMovies(
            category: MovieCategory.popular,
            page: 2, // Dinamik sayfa numarası gerekli ise ayrı bir counter eklenebilir
          ));
        }
      }
    });
  }

  void _onRefresh() {
    context.read<MovieBloc>().add(RefreshMovies());
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isNotEmpty) {
        final state = context.read<MovieBloc>().state;
        if (state is MovieLoaded) {
          // Tüm film listelerinde arama yap
          final allMovies = [
            ...state.trendingMovies,
            ...state.popularMovies,
            ...state.nowPlayingMovies,
            ...state.topRatedMovies,
            ...state.popularTVShows,
          ];

          _filteredMovies = allMovies.where((movie) =>
              movie.title.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }
      } else {
        _filteredMovies = [];
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<MovieBloc, MovieState>(
          listener: (context, state) {
            if (state is MovieLoaded) {
              _refreshController.refreshCompleted();
            } else if (state is MovieError) {
              _refreshController.refreshFailed();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: const WaterDropMaterialHeader(
              backgroundColor: AppColors.primary,
              color: AppColors.textPrimary,
            ),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Custom App Bar
                _buildAppBar(l10n),

                // Search Bar
                _buildSearchBar(l10n),

                // Content
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    if (state is MovieError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is MovieLoaded) {
                      return _buildContent(state);
                    }

                    return const SliverFillRemaining(
                      child: Center(child: Text('Beklenmeyen durum')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'Shartflix',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Show notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Show user menu
            },
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
        child: SearchTextField(
          controller: _searchController,
          hintText: l10n.searchMovies,
          onChanged: _onSearch,
          onClear: () => _onSearch(''),
        ),
      ),
    );
  }

  Widget _buildContent(MovieLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (_searchQuery.isEmpty) ...[
          // Trending Movies Section (Featured)
          if (state.featuredMovie != null) ...[
            _buildFeaturedSection(state.featuredMovie!),
            const SizedBox(height: AppDimensions.spacing24),
          ],

          // Popular Movies Section
          if (state.popularMovies.isNotEmpty) ...[
            _buildMovieSection(
              title: 'Popüler Filmler',
              movies: state.popularMovies,
              onSeeAll: () {
                // TODO: Navigate to popular movies page
              },
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],

          // Trending Movies Section
          if (state.trendingMovies.isNotEmpty) ...[
            _buildMovieSection(
              title: 'Trend Filmler',
              movies: state.trendingMovies,
              onSeeAll: () {
                // TODO: Navigate to trending movies page
              },
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],

          // Now Playing Movies Section
          if (state.nowPlayingMovies.isNotEmpty) ...[
            _buildMovieSection(
              title: 'Vizyondaki Filmler',
              movies: state.nowPlayingMovies,
              onSeeAll: () {
                // TODO: Navigate to now playing movies page
              },
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],

          // Top Rated Movies Section
          if (state.topRatedMovies.isNotEmpty) ...[
            _buildMovieSection(
              title: 'En Çok Beğenilenler',
              movies: state.topRatedMovies,
              onSeeAll: () {
                // TODO: Navigate to top rated movies page
              },
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],

          // Popular TV Shows Section
          if (state.popularTVShows.isNotEmpty) ...[
            _buildMovieSection(
              title: 'Popüler Diziler',
              movies: state.popularTVShows,
              onSeeAll: () {
                // TODO: Navigate to tv shows page
              },
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ] else ...[
          // Search Results
          _buildSearchResults(),
        ],

        const SizedBox(height: AppDimensions.spacing24),
      ]),
    );
  }

  Widget _buildFeaturedSection(Movie movie) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingHorizontal,
      ),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primaryLight.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterPath ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.movie,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (movie.voteAverage ?? 0.0).toStringAsFixed(1),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _onMovieTap(movie),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('İzle'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection({
    required String title,
    required List<Movie> movies,
    required VoidCallback onSeeAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPaddingHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
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

        SizedBox(
          height: AppDimensions.movieCardHeight + 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == movies.length - 1 ? 0 : AppDimensions.spacing12,
                ),
                child: MovieCard(
                  movie: movies[index],
                  onTap: () => _onMovieTap(movies[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Arama Sonuçları (${_filteredMovies.length})',
            style: AppTextStyles.h6.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppDimensions.spacing16),

          if (_filteredMovies.isEmpty && _searchQuery.isNotEmpty)
            _buildEmptySearchState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: AppDimensions.spacing12,
                mainAxisSpacing: AppDimensions.spacing16,
              ),
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: _filteredMovies[index],
                  onTap: () => _onMovieTap(_filteredMovies[index]),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
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
          ),

          const SizedBox(height: AppDimensions.spacing8),

          Text(
            'Farklı anahtar kelimeler deneyin',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),

            const SizedBox(height: AppDimensions.spacing16),

            Text(
              'Bir hata oluştu',
              style: AppTextStyles.h6.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacing8),

            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.spacing24),

            ElevatedButton(
              onPressed: _onRefresh,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  void _onMovieTap(Movie movie) {
    // TODO: Navigate to movie detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title} filmini seçtiniz'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}