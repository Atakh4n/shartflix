import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../presentation/routes/app_router.dart';

@singleton
class NavigationService {
  late final AppRouter _appRouter;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setRouter(AppRouter router) {
    _appRouter = router;
  }

  AppRouter get router => _appRouter;

  BuildContext? get context => navigatorKey.currentContext;

  // Basic Navigation
  Future<T?> push<T extends Object?>(PageRouteInfo route) {
    if (context == null) return Future.value(null);
    return context!.router.push<T>(route);
  }

  Future<T?> pushAndClearStack<T extends Object?>(PageRouteInfo route) async {
    if (context == null) return Future.value(null);
    context!.router.popUntilRoot();
    return await context!.router.push<T>(route);
  }

  Future<T?> pushReplacement<T extends Object?>(PageRouteInfo route) {
    if (context == null) return Future.value(null);
    return context!.router.replace<T>(route);
  }

  Future<bool> pop<T extends Object?>([T? result]) {
    if (context == null) return Future.value(false);
    return context!.router.pop<T>(result);
  }

  void popUntil(RoutePredicate predicate) {
    if (context == null) return;
    context!.router.popUntil(predicate);
  }

  void popUntilRoot() {
    if (context == null) return;
    context!.router.popUntilRoot();
  }

  // Named Routes Navigation
  Future<T?> pushNamed<T extends Object?>(
      String routeName, {
        Object? arguments,
      }) {
    if (context == null) return Future.value(null);
    return Navigator.of(context!).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        Object? arguments,
        TO? result,
      }) {
    if (context == null) return Future.value(null);
    return Navigator.of(context!).pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String newRouteName,
      RoutePredicate predicate, {
        Object? arguments,
      }) {
    if (context == null) return Future.value(null);
    return Navigator.of(context!).pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  // Dialog and Modal Navigation
  Future<T?> showDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    if (context == null) return Future.value(null);
    return showGeneralDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      barrierLabel: barrierLabel,
      pageBuilder: (context, animation, secondaryAnimation) => dialog,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  Future<T?> showBottomSheet<T>({
    required Widget content,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) {
    if (context == null) return Future.value(null);
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      builder: (context) => content,
    );
  }

  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
  }) {
    if (context == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context!);
    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Utility Methods
  bool canPop() {
    if (context == null) return false;
    return context!.router.canPop();
  }

  String get currentPath {
    if (context == null) return '/';
    return context!.router.currentPath;
  }

  bool isRouteActive(String routeName) {
    if (context == null) return false;
    return context!.router.currentPath.contains(routeName);
  }

  // Custom Transitions
  Future<T?> pushWithSlideTransition<T extends Object?>(
      PageRouteInfo route, {
        Offset begin = const Offset(1.0, 0.0),
        Offset end = Offset.zero,
        Curve curve = Curves.easeInOut,
      }) {
    if (context == null) return Future.value(null);
    return context!.router.push<T>(route);
  }

  Future<T?> pushWithFadeTransition<T extends Object?>(
      PageRouteInfo route, {
        Curve curve = Curves.easeInOut,
      }) {
    if (context == null) return Future.value(null);
    return context!.router.push<T>(route);
  }

  // Error Handling
  void handleNavigationError(Object error, StackTrace stackTrace) {
    debugPrint('Navigation Error: $error');
    debugPrint('Stack Trace: $stackTrace');
  }

  // Deep Link Handling
  Future<void> handleDeepLink(String link) async {
    try {
      // Parse and navigate to deep link
      // This will be implemented based on your routing structure
      debugPrint('Handling deep link: $link');
    } catch (e) {
      debugPrint('Deep link error: $e');
    }
  }
}