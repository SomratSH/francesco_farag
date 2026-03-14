import 'package:francesco_farag/data/customer_imp.dart';
import 'package:francesco_farag/domain/repository/customer_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<CustomerRepository>(() => CustomerImp());

  // Repository

  // // Providers / Controllers
  // getIt.registerFactory<LoginProvider>(() => LoginProvider());
  // getIt.registerFactory<SignupProvider>(
  //   () => SignupProvider(getIt<AuthRepository>()),
  // );
  // getIt.registerFactory<ChangePasswordProvider>(() => ChangePasswordProvider());
  // getIt.registerFactory<MenuListProvider>(() => MenuListProvider());
  // getIt.registerFactory<DriverMenuProvider>(() => DriverMenuProvider());
  // getIt.registerFactory<DriverSettingsProvider>(() => DriverSettingsProvider());
}
