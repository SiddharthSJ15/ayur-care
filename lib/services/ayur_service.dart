import 'package:dio/dio.dart';

class AyurService {
  final String baseUrl = 'https://flutter-amr.noviindus.in/api';
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> loginService(
    String email,
    String password,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'username': email,
        'password': password,
      });

      final response = await _dio.post('$baseUrl/Login', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];

        print(data);
        print('Token: $token');
        print('Login successful');

        return {'token': token, 'status': true};
      } else {
        return {'status': false, 'message': 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'status': false, 'message': 'Exception: $e'};
    }
  }
}
