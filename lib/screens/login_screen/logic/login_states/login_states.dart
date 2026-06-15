import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {}

class LoginError extends LoginStates {
  final String message;
  LoginError({required this.message});
}

class GoogleLoading extends LoginStates {}

class GoogleSuccess extends LoginStates {
  final User user;
  GoogleSuccess(this.user);
}

class GoogleError extends LoginStates {
  final String message;
  GoogleError(this.message);
}
