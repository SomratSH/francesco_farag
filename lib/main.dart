import 'package:flutter/material.dart';
import 'package:francesco_farag/provider_list.dart';
import 'package:francesco_farag/routing/app_routing.dart';
import 'package:francesco_farag/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final router = await AppRouting.createRouter();
  setupServiceLocator();
  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.provider,
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
