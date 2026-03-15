import 'dart:io';

import 'package:flutter/material.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _customerRepository;

  CustomerProvider(this._customerRepository);

  bool isLoading = false;

  File? _licenseImage;
  final ImagePicker _picker = ImagePicker();

  File? get licenseImage => _licenseImage;

  // Method to pick image from Gallery or Camera
  Future<void> pickLicenseImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Reduces size for faster upload
      );

      if (pickedFile != null) {
        _licenseImage = File(pickedFile.path);
        notifyListeners(); // Updates the UI
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // Clear image if needed
  void clearImage() {
    _licenseImage = null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await _customerRepository.login({
      "email": email,
      "password": password,
    });
    if (response["access_token"] != null) {
      prefs.setString('authToken', response["access_token"]).toString();
      prefs.setString('refreshToken', response["refresh_token"].toString());
      prefs.setString("role", response["role"]).toString();
      notifyListeners();
      if (context.mounted) {
        AppSnackbar.show(
          context,
          title: "Success",
          message: response["message"],
        );
      }

      return true;
    } else {
      debugPrint("Login failed: ${response["message"]}");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }


}
