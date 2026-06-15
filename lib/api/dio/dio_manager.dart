import 'package:dio/dio.dart';

class DioManager {

  static final Dio dio = Dio(

    BaseOptions(

      baseUrl: 'https://movies-api.accel.li/api/v2/',

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      sendTimeout:
      const Duration(seconds: 30),
    ),
  );
}