import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:francesco_farag/constant/app_urls.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/network/api_service.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/customer/model/car_details_model.dart';
import 'package:francesco_farag/ui/customer/model/cars_model.dart';
import 'package:francesco_farag/ui/customer/model/customer_profile_mdel.dart';
import 'package:francesco_farag/ui/customer/model/driviing_license_model.dart';
import 'package:francesco_farag/ui/customer/model/fine_model.dart';
import 'package:francesco_farag/ui/customer/model/rental_model.dart';
import 'package:francesco_farag/utils/custom_loading_dialog.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  Future<bool> fetchCarDetails(int id, BuildContext context) async {
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
      final response = await apiService.postData(
        "/customer/rental-requests/create/",
        {
          "car_id": carId,
          "pickup_date": pickupDate,
          "return_date": returnDate,
          "service_ids": serviceIds,
          "notes": notes,
        },
        authToken: preferences.getString("authToken"),
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
        String errorMsg =
            response["non_field_errors"]?.first ?? "Failed to create request";

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
      final response = await apiService.getList(
        "/customer/rental-requests/",
        authToken: preferences.getString("authToken"),
      );

      if (response.isNotEmpty) {
        rentalList = response
            .map((data) => RentalRequest.fromJson(data))
            .toList();

        rentalList.forEach((e) {
          print(e.status);
          print(e.carDetails.carName);
        });
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

  DrivingLicenseModel licenseModel = DrivingLicenseModel();

  Future<void> getDrivingLicense() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getData(
        "/customer/driving-license/",
        authToken: preferences.getString("authToken"),
      );

      print("License Response: $response");

      if (response.isNotEmpty) {
        licenseModel = DrivingLicenseModel.fromJson(response);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching license: $e");
      // Handle error state if necessary
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  CarsModel carsSearch = CarsModel();

  bool isSearchLoading = false;

  Future<void> fetchSearchCars({
    required String pickupDate,
    required String returnDate,
    required BuildContext context,
  }) async {
    if (_selectedPickupDate == null || _selectedReturnDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select both dates")));
      return;
    }

    isSearchLoading = true;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await apiService.getData(
      "/customer/cars/?pickup_date=$pickupDate&return_date=$returnDate",
      authToken: preferences.getString("authToken"),
    );

    if (response.isNotEmpty) {
      carsSearch = CarsModel.fromJson(response);
      isSearchLoading = false;
      notifyListeners();
    } else {
      isSearchLoading = false;
      notifyListeners();
    }
  }

  DateTime? _selectedPickupDate;
  DateTime? _selectedReturnDate;

  String get pickupDateStr => _selectedPickupDate == null
      ? 'Select Date'
      : DateFormat('yyyy-MM-dd').format(_selectedPickupDate!);

  String get returnDateStr => _selectedReturnDate == null
      ? 'Select Date'
      : DateFormat('yyyy-MM-dd').format(_selectedReturnDate!);

  Future<void> selectDate(BuildContext context, bool isPickup) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isPickup) {
        _selectedPickupDate = picked;
      } else {
        _selectedReturnDate = picked;
      }
      notifyListeners();
    }
  }

  Future<void> fetchFilteredCars({
    String? category,
    String? transmission,
    double? minPrice,
    double? maxPrice,
    String? seats,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // 1. Build Dynamic Query Parameters
      final Map<String, String> queryParams = {};

      if (category != null && category != 'Any') {
        queryParams['category'] = category.toLowerCase();
      }
      if (transmission != null && transmission != 'Any') {
        queryParams['transmission'] = transmission.toLowerCase();
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toInt().toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toInt().toString();
      }

      // Extract digit from "4 seats" -> "4"
      if (seats != null && seats != 'Any') {
        queryParams['seats'] = seats.replaceAll(RegExp(r'[^0-9]'), '');
      }

      // 2. Construct the URL
      final String queryString = Uri(queryParameters: queryParams).query;
      final String url = "/customer/cars/?$queryString";

      // 3. API Call
      final response = await apiService.getData(
        url,
        authToken: preferences.getString("authToken"),
      );

      if (response != null && response.isNotEmpty) {
        carsSearch = CarsModel.fromJson(response);
      } else {
        carsSearch = CarsModel(); // Clear list if no results match
      }
    } catch (e) {
      debugPrint("Filter API Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  FineInvoiceModel? fineData;

  Future<void> fetchFinesAndInvoices() async {
    isLoading = true;
    notifyListeners();

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final response = await apiService.getData(
        "/customer/fines-invoices/",
        authToken: preferences.getString("authToken"),
      );

      if (response != null) {
        fineData = FineInvoiceModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Fines API Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> payFine({
    required int fineId,
    required File imageFile,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppUrls.baseUrl}/customer/fines-invoices/$fineId/pay/'),
      );

      // --- ADDED AUTHORIZATION TOKEN HERE ---
      // Replace 'yourTokenVariable' with wherever you store your session token
      request.headers.addAll({
        'Authorization':
            'Bearer ${preferences.getString("authToken")}', // Ensure 'token' is accessible in this scope
        'Accept': 'application/json', // Good practice for API requests
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'license_front_image',
          imageFile.path,
        ),
      );

      // 1. Send the request
      var streamedResponse = await request.send();

      // 2. Convert StreamedResponse to a standard Response to access the body
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 3. Decode the JSON body
        final Map<String, dynamic> data = jsonDecode(response.body);

        // 4. Extract and return the checkout_url
        return data['checkout_url'];
      } else {
        debugPrint("Payment failed with status: ${response.statusCode}");
        debugPrint(
          "Response body: ${response.body}",
        ); // Helpful for debugging 401/403 errors
        return null;
      }
    } catch (e) {
      debugPrint("Error paying fine: $e");
      return null;
    } finally {}
  }

  Future<String?> payBooking({required int bookingId}) async {
    isCarLoading = true;
    notifyListeners();

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/customer/pay-booking/$bookingId/'),
        headers: {
          'Authorization':
              'Bearer ${preferences.getString("authToken")}', // Your stored auth token
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Return the Stripe/Payment gateway URL
        return data['checkout_url'];
      } else {
        debugPrint("Booking payment failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error initializing booking payment: $e");
      return null;
    } finally {
      isCarLoading = false;
      notifyListeners();
    }
  }

  Future<bool> acceptQuotation({required int quotationId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isCarLoading = true;
    notifyListeners();

    final url = Uri.parse(
      '${AppUrls.baseUrl}/customer/quotations/$quotationId/accept/',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization':
              'Bearer ${preferences.getString("authToken")}', // Ensure your token is valid
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Strict check for the success message you provided
        if (data['message'] ==
            "Quotation accepted. Please proceed with payment.") {
          debugPrint("Quotation accepted successfully");
          return true;
        }
      }

      debugPrint("Failed to accept quotation: ${response.body}");
      return false;
    } catch (e) {
      debugPrint("Error in acceptQuotation: $e");
      return false;
    } finally {
      isCarLoading = false;
      notifyListeners();
    }
  }
}
