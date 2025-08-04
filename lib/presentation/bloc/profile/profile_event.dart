part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> updates;

  const UpdateProfile({required this.updates});

  @override
  List<Object> get props => [updates];
}

class UploadProfileImage extends ProfileEvent {
  final String imagePath;

  const UploadProfileImage({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}