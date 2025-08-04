import 'package:flutter/material.dart';
import 'dart:math' show pow;

// String Extensions
extension StringExtensions on String {
  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  // Check if string is email
  bool get isEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  // Check if string is phone number
  bool get isPhoneNumber {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(this);
  }

  // Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Check if string is numeric
  bool get isNumeric {
    return double.tryParse(this) != null;
  }

  // Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceFirst(RegExp(r'^_'), '');
  }

  // Convert to camelCase
  String get toCamelCase {
    List<String> words = split('_');
    if (words.isEmpty) return this;

    String result = words.first.toLowerCase();
    for (int i = 1; i < words.length; i++) {
      result += words[i].capitalize;
    }
    return result;
  }

  // Parse to integer safely
  int? get toInt => int.tryParse(this);

  // Parse to double safely
  double? get toDouble => double.tryParse(this);

  // Check if string contains only digits
  bool get isDigitsOnly => RegExp(r'^\d+$').hasMatch(this);

  // Get initials from full name
  String get initials {
    List<String> words = trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first.isNotEmpty ? words.first[0].toUpperCase() : '';
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

// DateTime Extensions
extension DateTimeExtensions on DateTime {
  // Format as dd/MM/yyyy
  String get formatDDMMYYYY {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  // Format as dd MMM yyyy (e.g., 15 Jan 2024)
  String get formatDDMMMYYYY {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '$day ${months[month - 1]} $year';
  }

  // Format as HH:mm
  String get formatHHMM {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  // Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  // Get relative time string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years} yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  // Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
}

// BuildContext Extensions
extension BuildContextExtensions on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Get theme
  ThemeData get theme => Theme.of(this);

  // Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  // Get keyboard height
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  // Check if keyboard is open
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;

  // Show snackbar
  void showSnackBar(String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Hide current snackbar
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  // Push page with slide transition
  Future<T?> pushWithSlideTransition<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  // Push page with fade transition
  Future<T?> pushWithFadeTransition<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

// List Extensions
extension ListExtensions<T> on List<T> {
  // Get element at index safely
  T? elementAtOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  // Add element if not null
  void addIfNotNull(T? element) {
    if (element != null) {
      add(element);
    }
  }

  // Remove duplicates
  List<T> get unique {
    return toSet().toList();
  }

  // Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    List<List<T>> chunks = [];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size) > length ? length : (i + size)));
    }
    return chunks;
  }
}

// Map Extensions
extension MapExtensions<K, V> on Map<K, V> {
  // Get value safely
  V? getOrNull(K key) {
    return containsKey(key) ? this[key] : null;
  }

  // Get value or default
  V getOrDefault(K key, V defaultValue) {
    return containsKey(key) ? this[key]! : defaultValue;
  }
}

// Double Extensions
extension DoubleExtensions on double {
  // Round to decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    final factor = pow(10, decimalPlaces).toDouble();
    return (this * factor).round() / factor;
  }

  // Format as currency (Turkish Lira)
  String get toTurkishLira {
    return '₺${toStringAsFixed(2)}';
  }

  // Format as percentage
  String get toPercentage {
    return '${(this * 100).toStringAsFixed(1)}%';
  }
}

// Import for pow function


// Duration Extensions
extension DurationExtensions on Duration {
  // Format as HH:MM:SS
  String get formatHHMMSS {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  // Format as MM:SS
  String get formatMMSS {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  // Get human readable format
  String get humanReadable {
    if (inDays > 0) {
      return '${inDays} gün ${inHours.remainder(24)} saat';
    } else if (inHours > 0) {
      return '${inHours} saat ${inMinutes.remainder(60)} dakika';
    } else if (inMinutes > 0) {
      return '${inMinutes} dakika';
    } else {
      return '${inSeconds} saniye';
    }
  }
}