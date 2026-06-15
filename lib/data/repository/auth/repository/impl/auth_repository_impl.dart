import 'package:firebase_auth/firebase_auth.dart';

import '../../data_sources/remote/auth_remote_data_source.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<void> login(String email, String password) async {
    try {
      await remote.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw Exception(errorMessage(e.code));
    }
  }

  String errorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
        return "Invalid email or password";

      case 'invalid-email':
        return "Invalid email format";

      case 'too-many-requests':
        return "Too many attempts. Try again later";

      default:
        return "Login failed";
    }
  }

  @override
  Future<User?> googleLogin() async{
    return await remote.googleLogin();
  }

  @override
  Future<User?> register(String email, String password, String name, String phone,String avatar) async{
    return await remote.register(email, password, name, phone,avatar);
  }

  @override
  Future<void> resetPassword(String email) async{
    return await remote.resetPassword(email);
  }

}
