import 'movie_response.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  List<Movies>? watchlist;
  List<Movies>? history;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.watchlist,
    this.history,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    watchlist = json['watchlist'] != null
        ? (json['watchlist'] as List)
        .map((e) => Movies.fromJson(e))
        .toList()
        : [];

    history = json['history'] != null
        ? (json['history'] as List)
        .map((e) => Movies.fromJson(e))
        .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'watchlist': watchlist?.map((e) => e.toJson()).toList(),
      'history': history?.map((e) => e.toJson()).toList(),
    };
  }
}