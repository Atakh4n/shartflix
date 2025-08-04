import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? profileImageUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserPreferences? preferences;
  final List<String> favoriteMovieIds;
  final List<String> watchlistMovieIds;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.phoneNumber,
    this.dateOfBirth,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
    this.preferences,
    this.favoriteMovieIds = const [],
    this.watchlistMovieIds = const [],
  });

  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  String get displayName => fullName;

  bool get hasProfileImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;

  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName != null && lastName!.isNotEmpty
        ? lastName![0].toUpperCase()
        : '';
    return '$firstInitial$lastInitial';
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
    List<String>? favoriteMovieIds,
    List<String>? watchlistMovieIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      favoriteMovieIds: favoriteMovieIds ?? this.favoriteMovieIds,
      watchlistMovieIds: watchlistMovieIds ?? this.watchlistMovieIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    profileImageUrl,
    phoneNumber,
    dateOfBirth,
    isEmailVerified,
    isPhoneVerified,
    isPremium,
    createdAt,
    updatedAt,
    preferences,
    favoriteMovieIds,
    watchlistMovieIds,
  ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, isPremium: $isPremium)';
  }
}

@JsonSerializable()
class UserPreferences extends Equatable {
  final String language;
  @JsonKey(name: 'dark_mode')
  final bool darkMode;
  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;
  @JsonKey(name: 'email_notifications')
  final bool emailNotifications;
  @JsonKey(name: 'push_notifications')
  final bool pushNotifications;
  @JsonKey(name: 'video_quality')
  final String videoQuality;
  @JsonKey(name: 'auto_play_next_episode')
  final bool autoPlayNextEpisode;
  @JsonKey(name: 'download_on_wifi_only')
  final bool downloadOnWifiOnly;
  final double volume;
  @JsonKey(name: 'subtitles_enabled')
  final bool subtitlesEnabled;
  @JsonKey(name: 'subtitle_language')
  final String subtitleLanguage;
  @JsonKey(name: 'preferred_genres')
  final List<String> preferredGenres;

  const UserPreferences({
    required this.language,
    required this.darkMode,
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.videoQuality,
    required this.autoPlayNextEpisode,
    required this.downloadOnWifiOnly,
    required this.volume,
    required this.subtitlesEnabled,
    required this.subtitleLanguage,
    this.preferredGenres = const [],
  });

  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      language: 'tr',
      darkMode: true,
      notificationsEnabled: true,
      emailNotifications: true,
      pushNotifications: true,
      videoQuality: 'hd',
      autoPlayNextEpisode: true,
      downloadOnWifiOnly: true,
      volume: 0.8,
      subtitlesEnabled: false,
      subtitleLanguage: 'tr',
      preferredGenres: [],
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? language,
    bool? darkMode,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    String? videoQuality,
    bool? autoPlayNextEpisode,
    bool? downloadOnWifiOnly,
    double? volume,
    bool? subtitlesEnabled,
    String? subtitleLanguage,
    List<String>? preferredGenres,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      videoQuality: videoQuality ?? this.videoQuality,
      autoPlayNextEpisode: autoPlayNextEpisode ?? this.autoPlayNextEpisode,
      downloadOnWifiOnly: downloadOnWifiOnly ?? this.downloadOnWifiOnly,
      volume: volume ?? this.volume,
      subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
      subtitleLanguage: subtitleLanguage ?? this.subtitleLanguage,
      preferredGenres: preferredGenres ?? this.preferredGenres,
    );
  }

  @override
  List<Object> get props => [
    language,
    darkMode,
    notificationsEnabled,
    emailNotifications,
    pushNotifications,
    videoQuality,
    autoPlayNextEpisode,
    downloadOnWifiOnly,
    volume,
    subtitlesEnabled,
    subtitleLanguage,
    preferredGenres,
  ];

  @override
  String toString() {
    return 'UserPreferences(language: $language, darkMode: $darkMode, videoQuality: $videoQuality)';
  }
}