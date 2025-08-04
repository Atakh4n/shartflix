import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../../l10n/app_localizations.dart';

import 'core/services/navigation_service.dart';
import 'core/theme/app_theme.dart';
import 'injection.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/movie/movie_bloc.dart';
import 'presentation/bloc/profile/profile_bloc.dart';
import 'presentation/routes/app_router.dart';

class ShartflixApp extends StatefulWidget {
  const ShartflixApp({super.key});

  @override
  State<ShartflixApp> createState() => _ShartflixAppState();
}

class _ShartflixAppState extends State<ShartflixApp> {
  late final AppRouter _appRouter;
  late final NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
    _navigationService = getIt<NavigationService>();
    // NavigationService'e router'ı set et
    _navigationService.setRouter(_appRouter);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<MovieBloc>(
          create: (context) => getIt<MovieBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => getIt<ProfileBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Shartflix',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('tr', ''),
        ],
        locale: const Locale('tr', ''),

        // Router configuration
        routerConfig: _appRouter.config(),

        // Builder for additional configurations
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}