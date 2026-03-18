import 'dart:io';

import 'package:flutter/material.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/network/api_service.dart';
import 'package:francesco_farag/ui/customer/model/car_details_model.dart';
import 'package:francesco_farag/ui/customer/model/cars_model.dart';
import 'package:francesco_farag/ui/customer/model/customer_profile_mdel.dart';
import 'package:francesco_farag/ui/customer/model/rental_model.dart';
import 'package:francesco_farag/utils/custom_loading_dialog.dart';
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

  CarDetailsModel? _carDetails;
  
  bool isCarLoading = false;
CarDetailsModel? get carDetails => _carDetails;

// Change return type to Future<bool>
Future<bool> fetchCarDetails(int id,BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isCarLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
   
    final response = await apiService.getData(
      "/customer/cars/$id/", 
      authToken: preferences.getString('authToken'),
    );

    if (response != null && response.isNotEmpty) {
      _carDetails = CarDetailsModel.fromJson(response);
      isCarLoading = false;
 
      notifyListeners();
      return true; // Successfully got data
    } else {
      _errorMessage = "No data found";
      isCarLoading = false;
    
      notifyListeners();
      return false; // No data returned
    }
  } catch (e) {
    _errorMessage = e.toString();
    isCarLoading = false;
     
    notifyListeners();
    return false; // API Error
  }
}


Future<bool> createRentalRequest({
  required int carId,
  required String pickupDate,
  required String returnDate,
  required List<int> serviceIds,
  required String notes,
  required BuildContext context,
}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
 
  try {
    final response = await apiService.postData("/customer/rental-requests/create/", {
      "car_id": carId,
      "pickup_date": pickupDate,
      "return_date": returnDate,
      "service_ids": serviceIds,
      "notes": notes,
    },
    authToken: preferences.getString("authToken")
    );
    
    if (response["message"] == "Rental request created successfully") {
   

      if (context.mounted) {
        AppSnackbar.show(
          context,
          title: "Success",
          message: "Rental Request Created Successfully",
          type: SnackType.success,
        );
      }
      return true;
    } else {
      // Handle API errors (like that "date must be in future" error)
      String errorMsg = response["non_field_errors"]?.first ?? "Failed to create request";
      
      if (context.mounted) {
        AppSnackbar.show(
          context,
          title: "Error",
          message: errorMsg,
          type: SnackType.error,
        );
      }
     
      return false;
    }
  } catch (e) {
    debugPrint("Rental Creation Error: $e");
   
    return false;
  }
}

List<RentalRequest> rentalList = [];

Future<void> fetchRentalList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isLoading = true;
  notifyListeners();

  try {
    // Assuming your repository has a getRentals method that calls the URL
    final response = await apiService.getList("/customer/rental-requests/", authToken: preferences.getString("authToken"));

    if (response.isNotEmpty) {
      rentalList = response.map((data) => RentalRequest.fromJson(data)).toList();
       isLoading = false;
      notifyListeners();
    }
    
    isLoading = false;
    notifyListeners();
  } catch (e) {
    debugPrint("Error fetching rentals: $e");
    isLoading = false;
    notifyListeners();
  }
}
}


