
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<void> login(String email, String password);
  Future<User?> googleLogin();
  Future<User?> register(String email, String password, String name, String phone,String avatar);
  Future<void> resetPassword(String email);
}
