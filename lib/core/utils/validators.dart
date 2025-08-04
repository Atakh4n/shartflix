class Validators {
  Validators._();

  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }

    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }

    return null;
  }

  // Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }

    if (value.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır';
    }

    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Şifre en az bir büyük harf içermelidir';
    }

    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Şifre en az bir küçük harf içermelidir';
    }

    // Check for number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Şifre en az bir rakam içermelidir';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Şifre onayı gerekli';
    }

    if (value != originalPassword) {
      return 'Şifreler eşleşmiyor';
    }

    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'İsim gerekli';
    }

    if (value.length < 2) {
      return 'İsim en az 2 karakter olmalıdır';
    }

    if (value.length > 50) {
      return 'İsim en fazla 50 karakter olabilir';
    }

    // Check for only letters and spaces
    if (!RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]+$').hasMatch(value)) {
      return 'İsim sadece harf ve boşluk içerebilir';
    }

    return null;
  }

  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası gerekli';
    }

    // Remove spaces and special characters
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]+'), '');

    // Turkish phone number format
    final phoneRegex = RegExp(r'^(\+90|0)?[5][0-9]{9}$');

    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Geçerli bir telefon numarası girin (05XX XXX XX XX)';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Bu alan zorunludur';
    }
    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Bu alan zorunludur';
    }

    if (value.length < minLength) {
      return 'En az $minLength karakter olmalıdır';
    }

    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'En fazla $maxLength karakter olabilir';
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL gerekli';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Geçerli bir URL girin';
    }

    return null;
  }

  // Age validation
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Yaş gerekli';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Geçerli bir yaş girin';
    }

    if (age < 13) {
      return 'En az 13 yaşında olmalısınız';
    }

    if (age > 120) {
      return 'Geçerli bir yaş girin';
    }

    return null;
  }

  // Credit card validation
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kredi kartı numarası gerekli';
    }

    // Remove spaces and dashes
    final cleanCard = value.replaceAll(RegExp(r'[\s\-]+'), '');

    // Check if it's numeric and has valid length
    if (!RegExp(r'^[0-9]{13,19}$').hasMatch(cleanCard)) {
      return 'Geçerli bir kredi kartı numarası girin';
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(cleanCard)) {
      return 'Geçerli bir kredi kartı numarası girin';
    }

    return null;
  }

  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV gerekli';
    }

    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'Geçerli bir CVV girin (3-4 rakam)';
    }

    return null;
  }

  // Expiry date validation (MM/YY format)
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Son kullanma tarihi gerekli';
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Geçerli bir tarih girin (AA/YY)';
    }

    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month);

    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Kartın süresi dolmuş';
    }

    return null;
  }

  // Helper method for Luhn algorithm
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = digit ~/ 10 + digit % 10;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  // Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }
}