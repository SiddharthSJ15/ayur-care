import 'package:ayur_care/services/ayur_service.dart';
import 'package:ayur_care/utilities/token_manager.dart';
import 'package:flutter/material.dart';

class AyurProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await AyurService().loginService(email, password);
      if (response['status']) {
        await TokenManager.setToken(response['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
