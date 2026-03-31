import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:francesco_farag/constant/app_urls.dart';
import 'package:francesco_farag/network/api_service.dart';
import 'package:francesco_farag/ui/agent/model/agent_dashboard_model.dart';
import 'package:francesco_farag/ui/agent/model/agent_profile_model.dart';
import 'package:francesco_farag/ui/agent/model/booking_details_model.dart';
import 'package:francesco_farag/ui/agent/model/checkin_model.dart';
import 'package:francesco_farag/ui/agent/model/rental_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AgentProvider extends ChangeNotifier {
  AgentDashboardModel agentDashboardModel = AgentDashboardModel();
  ApiService apiService = ApiService();

  bool isLoading = false;

  Future<void> fetchDashboard() async {
    isLoading = true;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await apiService.getData(
      "/agency-agent/dashboard/",
      authToken: preferences.getString("authToken"),
    );

    if (response.isNotEmpty) {
      agentDashboardModel = AgentDashboardModel.fromJson(response);
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  RentalRequestsModel? rentalRequestsModel;

  Future<void> getRentalRequests() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getData(
        "/agency-agent/rental-requests/",
        authToken: preferences.getString("authToken"),
      );

      print("Rental Requests Response: $response");

      if (response != null && response.isNotEmpty) {
        rentalRequestsModel = RentalRequestsModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Error fetching rental requests: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Inside AgentProvider class

  BookingDetailsModel? _bookingDetails;

  bool isQLoading = false;
  BookingDetailsModel? get bookingDetails => _bookingDetails;

  Future<bool> getBookingDetails(String bookingId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isQLoading = true;
    notifyListeners();
    // Assuming you have a loading setter
    try {
      final response = await apiService.getData(
        '/agency-agent/rental-requests/$bookingId/',
        authToken: preferences.getString("authToken"),
      );
      if (response.isNotEmpty) {
        _bookingDetails = BookingDetailsModel.fromJson(response);
        isQLoading = false;
        notifyListeners();
        return true;
      } else {
        isQLoading = false;
        notifyListeners();
        return false;
        // Handle error
        debugPrint("Error fetching booking: ${response}");
      }
    } catch (e) {
      isQLoading = false;
      notifyListeners();
      return false;
      debugPrint("Exception: $e");
    }
  }

  AgentProfileModel agentProfileModel = AgentProfileModel();
  Future<void> getAgentProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getData(
        "/agency-agent/profile/",
        authToken: preferences.getString("authToken"),
      );

      print("Rental Requests Response: $response");

      if (response != null && response.isNotEmpty) {
        agentProfileModel = AgentProfileModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Error fetching rental requests: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // inside AgentProvider class
  Future<bool> sendQuotation(String bookingId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      // Replace with your actual API client logic (Dio, Http, etc.)
      final response = await apiService.postApiWithoutBody(
        '/agency-agent/rental-requests/$bookingId/create-quotation/',

        preferences.getString("authToken").toString(),
      );

      if (response["message"] == "Quotation sent successfully.") {
        // Refresh the list so the status changes from 'pending' to 'quotation_sent'
        await getRentalRequests();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error sending quotation: $e");
      return false;
    }
  }

  CheckInBookingModel? checkInModel;
  bool isCheckinLoading = false;
  Future<void> getCheckInBookings(String tab) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      isCheckinLoading = true;
      notifyListeners();
      // API Call with tab parameter
      final response = await apiService.getData(
        '/agency-agent/checkin-bookings/?tab=$tab',
        authToken: preferences.getString("authToken"),
      );

      if (response.isNotEmpty) {
        checkInModel = CheckInBookingModel.fromJson(response);
        isCheckinLoading = false;
        notifyListeners();
      } else {
        isCheckinLoading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Check-in fetch error: $e");
    } finally {
      isCheckinLoading = false;
      notifyListeners();
    }
  }

  Booking selectCheckin = Booking();

  void selectCheckinBooking(Booking data) {
    selectCheckin = Booking();
    selectCheckin = data;
    notifyListeners();
  }

  Map<String, dynamic> get customerData => _checkInData;
  final Map<String, dynamic> _checkInData = {
    'fullName': '',
    'dob': '',
    'nationality': '',
    'address': '',
    'licenseNumber': '',
    'licenseExpiry': '',
    'idNumber': '',
    'idExpiry': '',
    'billingSameAsCustomer': true,
    'startingKm': '',
    'fuelLevel': 'Full',
    'carCondition': 'Good condition',
    "inspectionNotes": "",
    'inspectionPhotos': <String>[],
    'isVerified': false,
    'documentType': 'Driving License',
    'documentNumber': '',
    'documentExpiry': '',
    'docFrontImage': null, // Store path
    'docBackImage': null,
  };

  void updateDocImage(String key, String path) {
    _checkInData[key] = path;
    notifyListeners();
  }

  void addInspectionPhoto(String path) {
    // 1. Get the list (ensure it's not null)
    List<String> currentPhotos = List<String>.from(
      _checkInData['inspectionPhotos'] ?? [],
    );

    // 2. Add the new path
    currentPhotos.add(path);

    // 3. Update the map and notify UI
    _checkInData['inspectionPhotos'] = currentPhotos;
    notifyListeners();
  }

  void removeInspectionPhoto(int index) {
    List<String> currentPhotos = List<String>.from(
      _checkInData['inspectionPhotos'] ?? [],
    );
    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      _checkInData['inspectionPhotos'] = currentPhotos;
      notifyListeners();
    }
  }

  // Your existing update method
  void updateCustomerField(String key, dynamic value) {
    _checkInData[key] = value;
    notifyListeners();
  }

  Future<bool> submitCheckin(int bookingId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final url = Uri.parse(
      '${AppUrls.baseUrl}/agency-agent/checkin-bookings/$bookingId/',
    );

    try {
      var request = http.MultipartRequest('PATCH', url);

      request.headers.addAll({
        'Authorization':
            'Bearer ${preferences.getString("authToken")}', // Ensure 'token' is defined
        'Accept': 'application/json',
      });
      // 1. Text Fields Mapping
      request.fields['checkin_starting_km'] =
          _checkInData['startingKm']?.toString() ?? '0';
      request.fields['checkin_fuel_level'] =
          _checkInData['fuelLevel'] ?? 'full';
      request.fields['checkin_car_condition'] =
          _checkInData['carCondition'] ?? 'good';
      request.fields['checkin_inspection_notes'] =
          _checkInData['inspectionNotes'] ?? '';
      request.fields['document_type'] =
          _checkInData['documentType'] ?? 'Driving License';
      request.fields['document_number'] = _checkInData['documentNumber'] ?? '';
      request.fields['document_expiry_date'] =
          _checkInData['documentExpiry'] ?? '';
      request.fields['document_verified'] = (_checkInData['isVerified'] ?? true)
          .toString();

      // 2. Single Document Images
      if (_checkInData['docFrontImage'] != null) {
        File file = File(_checkInData['docFrontImage']);
        if (await file.exists()) {
          // <-- Check existence
          request.files.add(
            await http.MultipartFile.fromPath(
              'document_front_image',
              file.path,
            ),
          );
        } else {
          print("Warning: Front image file not found at ${file.path}");
        }
      }

      // 3. Inspection Photos List
      List<String> photos = List<String>.from(
        _checkInData['inspectionPhotos'] ?? [],
      );
      for (String path in photos) {
        File file = File(path);
        if (await file.exists()) {
          // <-- Check existence for each photo
          request.files.add(
            await http.MultipartFile.fromPath('inspection_photos', path),
          );
        } else {
          print("Warning: Inspection photo not found at $path");
        }
      }

      // 4. Send and Convert StreamedResponse to standard Response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 5. Decode JSON and Validate ID
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Checking if the returned ID matches the booking ID
        if (responseBody['id'] == bookingId) {
          print("Check-in Verified for Booking: ${responseBody['id']}");
          return true;
        } else {
          print(
            "ID Mismatch: Expected $bookingId but got ${responseBody['id']}",
          );
          return false;
        }
      } else {
        print("Server Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception during check-in: $e");
      return false;
    }
  }

  // Inside your AgentProvider class

  Map<String, dynamic> _checkoutData = {
    "checkout_ending_km": 0,
    "checkout_fuel_level": "full",
    "checkout_car_condition": "good",
    "checkout_damage_notes": "",
    "checkout_damage_charge": 0.0,
    "checkout_late_return_charge": 0.0,
    "checkout_extra_km_charge": 0.0,
    "checkout_fuel_charge": 0.0,
    "checkout_cleaning_fee": 0.0,
    "checkout_extra_charge_notes": "",
    "checkout_invoice_sent": true,
    "checkout_status": true,
  };

  Map<String, dynamic> get checkoutData => _checkoutData;

  void updateCheckoutField(String key, dynamic value) {
    _checkoutData[key] = value;
    notifyListeners();
  }

  Future<bool> submitCheckout(int bookingId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? token = preferences.getString("authToken");

    final url = Uri.parse(
      '${AppUrls.baseUrl}/agency-agent/checkout-bookings/$bookingId/',
    );

    try {
      // 1. Initialize MultipartRequest with PATCH method
      var request = http.MultipartRequest('PATCH', url);

      // 2. Add Headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // 3. Add Data to fields
      // Loop through the map and add everything as String
      _checkoutData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // 4. Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        // Verification logic
        if (data['id'].toString() == bookingId.toString()) {
          debugPrint("Checkout successful for booking: ${data['id']}");
          return true;
        } else {
          debugPrint("ID mismatch in response");
          return false;
        }
      } else {
        debugPrint("Server Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Checkout Exception: $e");
      return false;
    }
  }
}
