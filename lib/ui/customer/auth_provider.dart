import 'dart:io';

import 'package:flutter/material.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
 final CustomerRepository _customerRepository;

  AuthProvider( this._customerRepository);


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

    print("response");
    if (response["access_token"] != null) {
      prefs.setString('authToken', response["access_token"]).toString();
      prefs.setString('refreshToken', response["refresh_token"].toString());
      prefs.setString("role", response["role"]).toString();
      notifyListeners();
      if (context.mounted) {
        AppSnackbar.show(
          context,
          title: "Success",
          message: "Login Successfully",
          type: SnackType.success,
        );
        return true;
      }
      return true;
    } else if (response.containsKey("")) {
      debugPrint("Login failed: ${response["message"]}");
      isLoading = false;
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> signUpUser({
    required String fullName,
    required String email,

    required String password,
    required String licenseNumber,
    required String experiyDate,
    required String passportNumber,

    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();
    final response = await _customerRepository.signUpCustomer({
      "name": fullName,
      "email": email,
      "password": password,
      "license_number": licenseNumber,
      "id_passport_number": passportNumber,
      "license_expiry_date": experiyDate,
    }, _licenseImage);

    print(response);

    if (response.isNotEmpty) {
      if (response["refresh"] != null &&
          response["access"] &&
          response["user"]) {
        AppSnackbar.show(
          context,
          title: "Signup Customer",
          message: "Signup Success",
          type: SnackType.success,
        );
        return true;
      } else if (response.containsKey("email")) {
        // Extract the error message from the list
        List<dynamic> emailErrors = response["email"];
        String errorMessage = emailErrors.isNotEmpty
            ? emailErrors[0]
            : "Email error";
        AppSnackbar.show(
          context,
          title: "Signup Customer",
          message: errorMessage,
          type: SnackType.error,
        );
        return false;
      }
    } else {
      return false;
    }
    return false;
  }

}