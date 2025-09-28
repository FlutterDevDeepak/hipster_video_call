import 'package:dio/dio.dart';
import 'package:hipster/core/constants/api_end_point.dart';

Dio buildDio() {
  final dio = Dio(BaseOptions(
    baseUrl: ApiEndPoint.baseUrl,
     headers: {"x-api-key": "reqres-free-v1"},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));


  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  return dio;
}
