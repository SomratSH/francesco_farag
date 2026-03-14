abstract class CustomerRepository {
  Future<Map<String, dynamic>> login(Map<String, String> map);
  Future<Map<String, dynamic>> signUpCustomer(Map<String, dynamic> body);
}
