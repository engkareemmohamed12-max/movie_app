import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<void> login(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<User?> googleLogin() async {
    try {
      await GoogleSignIn.instance.initialize();

      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await firebaseAuth.signInWithCredential(credential);

      final uid = userCredential.user!.uid;

      final doc = await firestore.collection("users").doc(uid).get();

      if (!doc.exists) {
        await firestore.collection("users").doc(uid).set({
          "id": uid,
          "name": userCredential.user!.displayName ?? "",
          "email": userCredential.user!.email ?? "",
          "phone": "",
          "avatar": "",
          "isWatchlist": false,
          "isHistory": false,
        });
      }

      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<User?> register(
      String email,
      String password,
      String name,
      String phone,
      String avatar,
      ) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await firestore.collection('users').doc(uid).set({
        "id": uid,
        "name": name,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "isWatchlist": false,
        "isHistory": false,
      });

      return credential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}