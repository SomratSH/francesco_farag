import 'package:francesco_farag/constant/app_urls.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:francesco_farag/network/api_service.dart';

class CustomerImp implements CustomerRepository {

  final ApiService _apiService = ApiService();
   @override
  Future<Map<String, dynamic>> login(Map<String, String> map) async {
    final response = await _apiService.postDataRegular(AppUrls.login, map);
    return response;
  }
  @override
  Future<Map<String, dynamic>> signUpCustomer(Map<String, dynamic> body) async {
    final response = await _apiService.postData(AppUrls.signUpAgent, body);
    return response;
  }
}
