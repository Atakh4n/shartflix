import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/movie/movie_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/profile/profile_page.dart';
import '../../core/services/token_service.dart';
import '../../domain/entities/movie.dart';
import '../../injection.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // Splash route - Token kontrolü yapılacak
    AutoRoute(
      page: SplashRoute.page,
      path: '/splash',
      initial: true,
    ),
    // Login route
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    // Register route
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
    // Home route - Authentication gerekli
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
  ];
}

// Splash Page - Token kontrolü yapan ana sayfa
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // AuthBloc'a check event'i gönder
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint('Splash - Auth state changed to: ${state.runtimeType}');

        if (state is AuthAuthenticated) {
          debugPrint('User authenticated, navigating to home');
          // Home'a git ve tüm stack'i temizle
          context.router.replaceAll([const HomeRoute()]);
        } else if (state is AuthUnauthenticated) {
          debugPrint('User not authenticated, navigating to login');
          // Login'e git ve tüm stack'i temizle
          context.router.replaceAll([const LoginRoute()]);
        } else if (state is AuthError) {
          debugPrint('Auth error: ${state.message}, navigating to login');
          // Hata durumunda da login'e git
          context.router.replaceAll([const LoginRoute()]);
        }
        // AuthLoading ve AuthInitial durumlarında bekle
      },
      child: const SplashPageContent(), // splash_page.dart'dan gelecek
    );
  }
}

// Login Page
@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          debugPrint('Login successful, navigating to home');
          // Login başarılı, home'a git ve tüm stack'i temizle
          context.router.replaceAll([const HomeRoute()]);
        } else if (state is AuthError) {
          // Hata mesajını göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const EnhancedLoginPage(), // login_page.dart'dan gelecek
    );
  }
}

// Register Page
@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          debugPrint('Registration successful, navigating to home');
          // Register başarılı, home'a git ve tüm stack'i temizle
          context.router.replaceAll([const HomeRoute()]);
        } else if (state is AuthError) {
          // Hata mesajını göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const SimpleRegisterPage(), // register_page.dart'dan gelecek
    );
  }
}

// Home Page - Ana sayfa
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          debugPrint('User logged out, navigating to login');
          // Logout oldu, login'e git ve tüm stack'i temizle
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: const HomePageContent(), // home_page.dart'dan gelecek
    );
  }
}

// Ana sayfa içeriği
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTabContent(),
    BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: const ProfilePageContent(), // Bizim yazdığımız profile sayfası
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Ana sayfa sekmesi
class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = getIt<MovieBloc>()..add(LoadMovies());
  }

  @override
  void dispose() {
    _movieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SHARTFLIX',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        bloc: _movieBloc,
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'Hata: ${state.message}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _movieBloc.add(LoadMovies()),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          } else if (state is MovieLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                _movieBloc.add(RefreshMovies());
                await _movieBloc.stream.firstWhere((s) => s is MovieLoaded);
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured content
                    _buildFeaturedMovie(state.featuredMovie),

                    // Categories
                    if (state.popularMovies.isNotEmpty)
                      _buildMovieCategory('Popüler Filmler', state.popularMovies),
                    if (state.nowPlayingMovies.isNotEmpty)
                      _buildMovieCategory('Vizyondakiler', state.nowPlayingMovies),
                    if (state.topRatedMovies.isNotEmpty)
                      _buildMovieCategory('En Çok Beğenilenler', state.topRatedMovies),
                    if (state.popularTVShows.isNotEmpty)
                      _buildMovieCategory('Popüler Diziler', state.popularTVShows),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeaturedMovie(Movie? movie) {
    if (movie == null) {
      return Container(
        height: 400,
        width: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: Icon(Icons.movie, size: 100, color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        image: movie.backdropPath != null
            ? DecorationImage(
          image: NetworkImage(movie.fullBackdropUrl),
          fit: BoxFit.cover,
        )
            : null,
        gradient: movie.backdropPath == null
            ? LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[800]!, Colors.black],
        )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (movie.overview != null)
                    Text(
                      movie.overview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow, size: 20),
                        label: const Text('Oynat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(100, 40),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline, size: 20),
                        label: const Text('Bilgi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 40),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCategory(String title, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to movie detail
                    },
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[800],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: movie.posterPath != null
                            ? Image.network(
                          movie.fullPosterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.movie,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        )
                            : Container(
                          color: Colors.grey[800],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.movie,
                                color: Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}