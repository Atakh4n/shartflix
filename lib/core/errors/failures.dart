import 'package:equatable/equatable.dart';

// Either type definition (dartz yerine)
abstract class Either<L, R> {
  const Either();

  B fold<B>(B Function(L left) ifLeft, B Function(R right) ifRight);

  bool get isLeft;
  bool get isRight;

  L? get left;
  R? get right;
}

class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left(this._value);

  @override
  B fold<B>(B Function(L left) ifLeft, B Function(R right) ifRight) {
    return ifLeft(_value);
  }

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L get left => _value;

  @override
  R? get right => null;
}

class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right(this._value);

  @override
  B fold<B>(B Function(L left) ifLeft, B Function(R right) ifRight) {
    return ifRight(_value);
  }

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L? get left => null;

  @override
  R get right => _value;
}

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'İnternet bağlantısı yok',
    int? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Önbellek hatası',
    int? code,
  }) : super(message: message, code: code);
}

// Auth failures
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super(message: 'Geçersiz e-posta veya şifre', code: 401);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
      : super(message: 'Kullanıcı bulunamadı', code: 404);
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure()
      : super(message: 'Bu e-posta adresi zaten kullanılıyor', code: 409);
}

class TokenExpiredFailure extends AuthFailure {
  const TokenExpiredFailure()
      : super(message: 'Oturum süresi doldu', code: 401);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// Movie failures
class MovieFailure extends Failure {
  const MovieFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class MovieNotFoundFailure extends MovieFailure {
  const MovieNotFoundFailure()
      : super(message: 'Film bulunamadı', code: 404);
}