part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String firstName;
  final String email;
  final String password;

  const RegisterRequested({
    required this.firstName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, email, password];
}

class SocialLoginRequested extends AuthEvent {
  final String provider;

  const SocialLoginRequested({required this.provider});

  @override
  List<Object> get props => [provider];
}

class LogoutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final bool isAuthenticated;
  final User? user;

  const AuthStatusChanged({
    required this.isAuthenticated,
    this.user,
  });

  @override
  List<Object?> get props => [isAuthenticated, user];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  const ResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object> get props => [token, newPassword];
}

class VerifyEmailRequested extends AuthEvent {
  final String token;

  const VerifyEmailRequested({required this.token});

  @override
  List<Object> get props => [token];
}