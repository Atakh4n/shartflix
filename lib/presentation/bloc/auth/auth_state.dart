part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class EmailVerificationSuccess extends AuthState {
  final String message;

  const EmailVerificationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthSessionExpired extends AuthState {}

class AuthAccountLocked extends AuthState {
  final String reason;
  final DateTime? unlockTime;

  const AuthAccountLocked({
    required this.reason,
    this.unlockTime,
  });

  @override
  List<Object?> get props => [reason, unlockTime];
}