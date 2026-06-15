import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterLoading extends RegisterStates {}

class RegisterSuccess extends RegisterStates {
  final User user;
  RegisterSuccess(this.user);
}

class RegisterError extends RegisterStates {
  final String message;
  RegisterError(this.message);
}