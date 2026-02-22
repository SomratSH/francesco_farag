import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/home/home_page.dart';
import 'package:francesco_farag/ui/agent/landing_page/agent_landing_page.dart';
import 'package:francesco_farag/ui/agent/messge/chat_page.dart';
import 'package:francesco_farag/ui/agent/messge/message_page.dart';
import 'package:francesco_farag/ui/agent/profile/edit_profile_page.dart';
import 'package:francesco_farag/ui/agent/profile/profile_page.dart';
import 'package:francesco_farag/ui/agent/rentals/booking_page.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin_progress_page.dart';
import 'package:francesco_farag/ui/agent/rentals/checkinout_page.dart';
import 'package:francesco_farag/ui/agent/rentals/checkout_progess_page.dart';
import 'package:francesco_farag/ui/agent/rentals/create_fine_page.dart';
import 'package:francesco_farag/ui/agent/rentals/create_quatation_page.dart';
import 'package:francesco_farag/ui/agent/rentals/rentals_page.dart';
import 'package:francesco_farag/ui/authentication/agent_login.dart';
import 'package:francesco_farag/ui/authentication/create_new_password.dart';
import 'package:francesco_farag/ui/authentication/customer_login.dart';
import 'package:francesco_farag/ui/authentication/forgot_password.dart';
import 'package:francesco_farag/ui/authentication/otp_screen.dart';
import 'package:francesco_farag/ui/authentication/password_change.dart';
import 'package:francesco_farag/ui/authentication/signup_customer_screen.dart';
import 'package:francesco_farag/ui/authentication/splash_screen.dart';
import 'package:francesco_farag/ui/authentication/welcome_screen.dart';
import 'package:francesco_farag/ui/customer/home/all_cars_customer_page.dart';
import 'package:francesco_farag/ui/customer/home/car_details_page.dart';
import 'package:francesco_farag/ui/customer/home/customer_request_quatation.dart';
import 'package:francesco_farag/ui/customer/home/driver_liencse_page.dart';
import 'package:francesco_farag/ui/customer/home/home_customer.dart';
import 'package:francesco_farag/ui/customer/landing_customer/landing_customer.dart';
import 'package:francesco_farag/ui/customer/message_customer/customer_chat.dart';
import 'package:francesco_farag/ui/customer/message_customer/message_customer.dart';
import 'package:francesco_farag/ui/customer/profile_customer/edit_profile_customer.dart';
import 'package:francesco_farag/ui/customer/profile_customer/profile_customer.dart';
import 'package:francesco_farag/ui/customer/rentals_customers/renstals_assignment.dart';
import 'package:francesco_farag/ui/customer/rentals_customers/rentals_customer.dart';
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


      //agent 
        ShellRoute(
        builder: (context, state, child) => AgentLandingPage(child: child),
        routes: [
          GoRoute(
            path: AppRoute.home,
            builder: (context, state) => const AgentDashboardScreen(),
          ),
          GoRoute(
            path: AppRoute.rentals,
            builder: (context, state) => const RentalsPage(),
          ),
          GoRoute(
            path: AppRoute.message,
            builder: (context, state) => const MessagePage(),
          ),
          GoRoute(
            path: AppRoute.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.agentChat,
        name: 'agent-chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AppRoute.editProfile,
        name: 'agent-edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.bookingRequest,
        name: 'agent-booking-request',
        builder: (context, state) => const BookingRequestScreen(),
      ),
       GoRoute(
        path: AppRoute.crateQuatation,
        name: 'agent-create-quatation',
        builder: (context, state) => const CreateQuotationScreen(),
      ),
      GoRoute(
        path: AppRoute.createFine,
        name: 'agent-create-fine',
        builder: (context, state) => const CreateFineScreen(),
      ),
      GoRoute(
        path: AppRoute.checkinout,
        name: 'agent-check-inout',
        builder: (context, state) => const CheckInOutScreen(),
      ),
       GoRoute(
        path: AppRoute.checkinProgress,
        name: 'agent-check-inprogress',
        builder: (context, state) => const CheckInProcessScreen(),
      ),
        GoRoute(
        path: AppRoute.checkoutProgess,
        name: 'agent-check-outprogress',
        builder: (context, state) => const CheckoutProgessPage(),
      ),



      //customer shell
      ShellRoute(
        builder: (context, state, child) => LandingCustomer(child: child),
        routes: [
          GoRoute(
            path: AppRoute.homeCustomer,
            builder: (context, state) => const HomeCustomer(),
          ),
          GoRoute(
            path: AppRoute.rentalsCustomer,
            builder: (context, state) => const RentalsCustomer(),
          ),
          GoRoute(
            path: AppRoute.messageCustomer,
            builder: (context, state) => const MessageCustomer(),
          ),
          GoRoute(
            path: AppRoute.profileCustomer,
            builder: (context, state) => const ProfileCustomer(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.driverLiencse,
        name: 'driver-liencse',
        builder: (context, state) => const DrivingLicenseScreen(),
      ),
      GoRoute(
        path: AppRoute.customerChat,
        name: 'customer-chat',
        builder: (context, state) => const CustomerChat(),
      ),
       GoRoute(
        path: AppRoute.customerEditProfile,
        name: 'customer-edit-profile',
        builder: (context, state) => const EditProfileCustomer(),
      ),
       GoRoute(
        path: AppRoute.allCarCustomer,
        name: 'all-customer-car',
        builder: (context, state) => const AllCarsCustomerPage(),
      ),
      GoRoute(
        path: AppRoute.carDetails,
        name: 'car-details',
        builder: (context, state) => const CarDetailsScreen(),
      ),
       GoRoute(
        path: AppRoute.customerRequestQuatation,
        name: 'customer-request-quatation',
        builder: (context, state) => const CustomerRequestQuatation(),
      ),
       GoRoute(
        path: AppRoute.rentalsAssingment,
        name: 'rentals-assingment',
        builder: (context, state) => const RentalAssignmentScreen(),
      ),
    ],
  );
}
