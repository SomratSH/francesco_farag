import 'package:flutter/material.dart';
import 'package:francesco_farag/network/api_service.dart';
import 'package:francesco_farag/ui/agent/model/agent_dashboard_model.dart';
import 'package:francesco_farag/ui/agent/model/agent_profile_model.dart';
import 'package:francesco_farag/ui/agent/model/booking_details_model.dart';
import 'package:francesco_farag/ui/agent/model/checkin_model.dart';
import 'package:francesco_farag/ui/agent/model/rental_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final response = await apiService.getData(
        '/agency-agent/rental-requests/$bookingId/create-quotation/',
        authToken: preferences.getString("authToken"),
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
  };

  Map<String, dynamic> get customerData => _checkInData;

  void updateCustomerField(String key, dynamic value) {
    _checkInData[key] = value;
    notifyListeners();
  }
}
