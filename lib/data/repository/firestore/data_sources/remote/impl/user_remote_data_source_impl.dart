import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../models/movie_response.dart';
import '../../../../../../models/user_model.dart';
import '../user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Future<UserModel> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await firestore.collection("users").doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("User document not found in Firestore");
    }


    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> updateUser({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).update({
      "name": name,
      "phone": phone,
      "avatar": avatar,
    });
  }

  @override
  Future<void> deleteUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).delete();

    await FirebaseAuth.instance.currentUser!.delete();
  }
  @override
  Future<void> updateWatchlist(List<Movies> watchlist) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).update({
      "watchlist": watchlist.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> updateHistory(List<Movies> history) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).update({
      "history": history.map((e) => e.toJson()).toList(),
    });
  }
  @override
  Future<void> addMovieToWatchlist(Movies movie) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).update({
      "watchlist": FieldValue.arrayUnion([
        movie.toJson(),
      ])
    });
  }
  @override
  Future<void> addMovieToHistory(Movies movie) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await firestore.collection("users").doc(uid).update({
      "history": FieldValue.arrayUnion([
        movie.toJson(),
      ])
    });
  }
  @override
  Future<void> removeMovieFromWatchlist(int movieId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
    await firestore.collection("users").doc(uid).get();

    final user = UserModel.fromJson(doc.data()!);

    user.watchlist?.removeWhere((e) => e.id == movieId);

    await firestore.collection("users").doc(uid).update({
      "watchlist":
      user.watchlist?.map((e) => e.toJson()).toList(),
    });
  }

}