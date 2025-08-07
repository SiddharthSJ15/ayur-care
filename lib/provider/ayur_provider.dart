import 'package:ayur_care/models/branch_model.dart';
import 'package:ayur_care/models/patient_model.dart';
import 'package:ayur_care/models/treatment_model.dart';
import 'package:ayur_care/services/ayur_service.dart';
import 'package:ayur_care/utilities/token_manager.dart';
import 'package:flutter/material.dart';

class AyurProvider extends ChangeNotifier {
  final AyurService _service = AyurService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<PatientModel> _patients = [];
  List<PatientModel> get patients => _patients;

  List<Branch> _branches = [];
  List<Branch> get branches => _branches;

  List<Treatment> _treatments = [];
  List<Treatment> get treatments => _treatments;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.loginService(email, password);
      if (response['status']) {
        await TokenManager.setToken(response['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final result = await _service.patientListService(token);
      if (result['status'] == true) {
        _patients = (result['data'] as List<PatientModel>);
      } else {
        _patients = [];
      }
    } catch (e) {
      print('Error fetching patients: $e');
      _patients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBranches() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final result = await _service.branchListService(token);
      if (result['status'] == true) {
        _branches = (result['data'] as List<Branch>);
      } else {
        _branches = [];
      }
    } catch (e) {
      print('Error fetching branches: $e');
      _branches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTreatments() async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenManager.getToken();
      final result = await _service.treatmentListService(token);
      if (result['status'] == true) {
        _treatments = (result['data']);
      } else {
        _treatments = [];
      }
    } catch (e) {
      print('Error fetching treatments: $e');
      _treatments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
