import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecases/usecase.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/profile/get_profile_usecase.dart';
import '../../../domain/usecases/profile/update_profile_usecase.dart';
import '../../../domain/usecases/profile/upload_profile_image_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final AppLogger _logger;

  ProfileBloc(
      this._getProfileUseCase,
      this._updateProfileUseCase,
      this._uploadProfileImageUseCase,
      this._logger,
      ) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadProfileImage>(_onUploadProfileImage);
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      emit(ProfileLoading());
      _logger.logBusinessLogic('Loading user profile', null);

      final result = await _getProfileUseCase(NoParams());

      result.fold(
            (failure) {
          _logger.error('Failed to load profile', failure.message);
          emit(ProfileError(message: failure.message));
        },
            (user) {
          _logger.logBusinessLogic('Profile loaded successfully', {'userId': user.id});
          emit(ProfileLoaded(user: user));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Error loading profile', e, stackTrace);
      emit(const ProfileError(message: 'Profil yüklenirken hata oluştu'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      emit(ProfileLoading());
      _logger.logBusinessLogic('Updating profile', event.updates);

      final result = await _updateProfileUseCase(UpdateProfileParams(
        firstName: event.updates['firstName'],
        lastName: event.updates['lastName'],
        phoneNumber: event.updates['phoneNumber'],
        dateOfBirth: event.updates['dateOfBirth'],
      ));

      result.fold(
            (failure) {
          _logger.error('Failed to update profile', failure.message);
          emit(ProfileError(message: failure.message));
        },
            (user) {
          _logger.logBusinessLogic('Profile updated successfully', {'userId': user.id});
          emit(ProfileLoaded(user: user));
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Error updating profile', e, stackTrace);
      emit(const ProfileError(message: 'Profil güncellenirken hata oluştu'));
    }
  }

  Future<void> _onUploadProfileImage(
      UploadProfileImage event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      if (state is ProfileLoaded) {
        emit(ProfileImageUploading(user: (state as ProfileLoaded).user));
      }

      _logger.logBusinessLogic('Uploading profile image', {'imagePath': event.imagePath});

      final result = await _uploadProfileImageUseCase(UploadProfileImageParams(
        imagePath: event.imagePath,
      ));

      result.fold(
            (failure) {
          _logger.error('Failed to upload profile image', failure.message);
          emit(ProfileError(message: failure.message));
        },
            (imageUrl) {
          _logger.logBusinessLogic('Profile image uploaded', {'imageUrl': imageUrl});

          if (state is ProfileImageUploading) {
            final currentUser = (state as ProfileImageUploading).user;
            final updatedUser = currentUser.copyWith(profileImageUrl: imageUrl);
            emit(ProfileLoaded(user: updatedUser));
          }
        },
      );
    } catch (e, stackTrace) {
      _logger.error('Error uploading profile image', e, stackTrace);
      emit(const ProfileError(message: 'Profil fotoğrafı yüklenirken hata oluştu'));
    }
  }
}