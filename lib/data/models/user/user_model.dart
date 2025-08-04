import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String firstName,
    String? lastName,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    @JsonKey(name: 'is_email_verified') required bool isEmailVerified,
    @JsonKey(name: 'is_phone_verified') required bool isPhoneVerified,
    @JsonKey(name: 'is_premium') required bool isPremium,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    UserPreferences? preferences,
    @JsonKey(name: 'favorite_movie_ids') List<String> favoriteMovieIds = const [],
    @JsonKey(name: 'watchlist_movie_ids') List<String> watchlistMovieIds = const [],
  }) : super(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    profileImageUrl: profileImageUrl,
    phoneNumber: phoneNumber,
    dateOfBirth: dateOfBirth,
    isEmailVerified: isEmailVerified,
    isPhoneVerified: isPhoneVerified,
    isPremium: isPremium,
    createdAt: createdAt,
    updatedAt: updatedAt,
    preferences: preferences,
    favoriteMovieIds: favoriteMovieIds,
    watchlistMovieIds: watchlistMovieIds,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      profileImageUrl: user.profileImageUrl,
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      isEmailVerified: user.isEmailVerified,
      isPhoneVerified: user.isPhoneVerified,
      isPremium: user.isPremium,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      preferences: user.preferences,
      favoriteMovieIds: user.favoriteMovieIds,
      watchlistMovieIds: user.watchlistMovieIds,
    );
  }
}