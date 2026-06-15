import 'package:cineluxe/screens/forget_password_screen/logic/reset_states/reset_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/auth/repository/auth_repository.dart';

class ResetViewModel extends Cubit<ResetStates>{
  ResetViewModel( this.repository) : super(ResetPasswordInitial());
  AuthRepository repository;
  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());
    try {
      await repository.resetPassword(email);
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordError(e.message ?? "error_sending_reset_email"));
    } catch (e) {
      emit(
        ResetPasswordError(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

}