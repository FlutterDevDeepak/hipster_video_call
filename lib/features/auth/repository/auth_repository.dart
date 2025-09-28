import 'package:dio/dio.dart';
import 'package:hipster/core/constants/api_end_point.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndPoint.baseUrl,
      headers: {"x-api-key": "reqres-free-v1"},
    ),
  );

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndPoint.login,
        data: {'email': email, 'password': password},
      );

      return response.data['token'];
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Login failed';
      throw Exception(message);
    }
  }
}
