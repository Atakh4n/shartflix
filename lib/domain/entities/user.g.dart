// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      language: json['language'] as String,
      darkMode: json['dark_mode'] as bool,
      notificationsEnabled: json['notifications_enabled'] as bool,
      emailNotifications: json['email_notifications'] as bool,
      pushNotifications: json['push_notifications'] as bool,
      videoQuality: json['video_quality'] as String,
      autoPlayNextEpisode: json['auto_play_next_episode'] as bool,
      downloadOnWifiOnly: json['download_on_wifi_only'] as bool,
      volume: (json['volume'] as num).toDouble(),
      subtitlesEnabled: json['subtitles_enabled'] as bool,
      subtitleLanguage: json['subtitle_language'] as String,
      preferredGenres: (json['preferred_genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'language': instance.language,
      'dark_mode': instance.darkMode,
      'notifications_enabled': instance.notificationsEnabled,
      'email_notifications': instance.emailNotifications,
      'push_notifications': instance.pushNotifications,
      'video_quality': instance.videoQuality,
      'auto_play_next_episode': instance.autoPlayNextEpisode,
      'download_on_wifi_only': instance.downloadOnWifiOnly,
      'volume': instance.volume,
      'subtitles_enabled': instance.subtitlesEnabled,
      'subtitle_language': instance.subtitleLanguage,
      'preferred_genres': instance.preferredGenres,
    };
