import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/authentication/widget/role_card.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // This centers horizontally
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ), // Increased padding for better look
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // This centers vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome to DriveNow",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose your role to continue using the self-drive rental system.",
                textAlign: TextAlign.center, // Centers the text lines
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors
                      .black54, // Softened the color slightly for hierarchy
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40), // More space before cards
              RoleCard(
                title: 'Customer',
                description:
                    'Rent a car for self-driving. You will collect the vehicle from the agency location.',
                icon: Icons.person_pin_rounded,
                gradient: AppColors().gradientPink,
                onTap: () {
                  context.push(AppRoute.customerLogin);
                },
              ),
              const SizedBox(height: 20),
              RoleCard(
                title: 'Agent',
                description:
                    'Manage booking requests, approvals, and vehicle check-in / check-out operations.',
                icon: Icons.stars_rounded,
                gradient: AppColors().gradientBlue,
                onTap: () {
                  context.push(AppRoute.agentLogin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
