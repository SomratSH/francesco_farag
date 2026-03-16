import 'dart:io';

import 'package:flutter/material.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/network/api_service.dart';
import 'package:francesco_farag/ui/customer/model/cars_model.dart';
import 'package:francesco_farag/ui/customer/model/customer_profile_mdel.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProvider extends ChangeNotifier {
  ApiService apiService = ApiService();
  bool isLoading = false;
  CustomerProfileModel? _userProfile;

  String? _errorMessage;

  CustomerProfileModel? get userProfile => _userProfile;

  String? get errorMessage => _errorMessage;

  CarsModel carsModel = CarsModel();

  Future<void> fetchCustomerProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final response = await apiService.getData(
      "/customer/profile/",
      authToken: preferences.getString('authToken'),
    );

    if (response.isNotEmpty) {
      _userProfile = CustomerProfileModel.fromJson(response);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFeatureCar() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();
    final response = await apiService.getData(
      "/customer/cars/",
      authToken: preferences.getString("authToken"),
    );
    print(response);
    if (response.isNotEmpty) {
      carsModel = CarsModel.fromJson(response);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
