import 'package:francesco_farag/data/customer_imp.dart';
import 'package:francesco_farag/ui/customer/auth_provider.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final getIt = GetIt.instance;

class AppProvider {
  static List<SingleChildWidget> get provider => [
    ChangeNotifierProvider(create: (_) => AuthProvider(CustomerImp())),
    ChangeNotifierProvider(
      create: (_) => CustomerProvider()
        ..getFeatureCar()
        ..fetchRentalList()
        ..fetchCustomerProfile(),
    ),
  ];
}
