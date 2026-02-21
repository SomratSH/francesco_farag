import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/authentication/agent_login.dart';
import 'package:francesco_farag/ui/authentication/create_new_password.dart';
import 'package:francesco_farag/ui/authentication/customer_login.dart';
import 'package:francesco_farag/ui/authentication/forgot_password.dart';
import 'package:francesco_farag/ui/authentication/otp_screen.dart';
import 'package:francesco_farag/ui/authentication/password_change.dart';
import 'package:francesco_farag/ui/authentication/signup_customer_screen.dart';
import 'package:francesco_farag/ui/authentication/splash_screen.dart';
import 'package:francesco_farag/ui/authentication/welcome_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouting {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoute.customerLogin,
        name: 'customer-login',
        builder: (context, state) => const CustomerLogin(),
      ),
      GoRoute(
        path: AppRoute.agentLogin,
        name: 'agent-login',
        builder: (context, state) => const AgentLogin(),
      ),
      GoRoute(
        path: AppRoute.signupCustomer,
        name: 'customer-signup',
        builder: (context, state) => const SignupCustomerScreen(),
      ),
      GoRoute(
        path: AppRoute.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.otpScreen,
        name: 'otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoute.createNewPassword,
        name: 'create-new-password',
        builder: (context, state) => const CreateNewPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.passwordChanged,
        name: 'password-changed',
        builder: (context, state) => const PasswordChange(),
      ),
    ],
  );
}
