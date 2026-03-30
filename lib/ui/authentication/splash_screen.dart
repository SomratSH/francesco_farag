import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a small delay if you want the user to actually see the splash logo
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final role = prefs.getString('role');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == 'customer') {
        context.go(AppRoute.homeCustomer);
      } else {
        context.go(AppRoute.home);
      }
    } else {
      context.go(AppRoute.welcome); // Or wherever your login starts
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/image/splash_image.png")),
    );
  }
}
