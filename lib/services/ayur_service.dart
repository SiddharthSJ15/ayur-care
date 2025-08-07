import 'package:ayur_care/models/branch_model.dart';
import 'package:ayur_care/models/patient_model.dart';
import 'package:ayur_care/models/treatment_model.dart';
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

  Future<Map<String, dynamic>> patientListService(String? token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/PatientList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        print('Patient list fetched successfully');
        final List<dynamic> responseData = data['patient'] ?? [];
        final List<PatientModel> patientList = responseData
            .map((item) => PatientModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return {
          'data': patientList,
          'status': true,
          'message': data['message'] ?? 'Success',
        };
      } else {
        return {'status': false, 'message': 'Failed to fetch patient list'};
      }
    } catch (e) {
      print('Error fetching patient list: $e');
      return {'status': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> branchListService(String? token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/BranchList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final List<dynamic> responseData = data['branches'] ?? [];
        final List<Branch> branchList = responseData
            .map((item) => Branch.fromJson(item as Map<String, dynamic>))
            .toList();
        return {
          'data': branchList,
          'status': true,
          'message': data['message'] ?? 'Success',
        };
      } else {
        return {'status': false, 'message': 'Failed to fetch branch list'};
      }
    } catch (e) {
      print('Error fetching branch list: $e');
      return {'status': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> treatmentListService(String? token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/TreatmentList',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final List<dynamic> responseData = data['treatments'] ?? [];
        final List<Treatment> treatmentList = responseData
            .map((item) => Treatment.fromJson(item))
            .toList();
        return {
          'data': treatmentList,
          'status': true,
          'message': data['message'] ?? 'Success',
        };
      } else {
        return {'status': false, 'message': 'Failed to fetch treatment list'};
      }
    } catch (e) {
      print('Error fetching treatment list: $e');
      return {'status': false, 'message': 'Exception: $e'};
    }
  }

}