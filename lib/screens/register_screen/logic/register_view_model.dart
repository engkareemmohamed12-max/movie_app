import 'package:cineluxe/screens/register_screen/logic/register_states/register_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/auth/repository/auth_repository.dart';

class RegisterViewModel extends Cubit<RegisterStates> {
  final AuthRepository repository;

  RegisterViewModel(this.repository) : super(RegisterInitial());
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    emit(RegisterLoading());

    try {
      final user = await repository.register(email, password, name, phone, avatar);
      emit(RegisterSuccess(user!));
    } catch (e) {
      emit(RegisterError(e.toString().replaceFirst("Exception: ", "")));
    }
  }

}