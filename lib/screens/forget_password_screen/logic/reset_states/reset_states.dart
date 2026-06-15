abstract class ResetStates {}
class ResetPasswordInitial extends ResetStates {}
class ResetPasswordLoading extends ResetStates {}
class ResetPasswordSuccess extends ResetStates {}
class ResetPasswordError extends ResetStates {
  final String message;
  ResetPasswordError(this.message);
}