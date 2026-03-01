import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';

class SteponeCheckin extends StatelessWidget {
  const SteponeCheckin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          'Check-in',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Booking Summery', // Matching the typo in your image
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // 1. Progress Stepper
            const StepperWidget(currentStep: 1),

            const SizedBox(height: 32),

            // 2. Booking Details Card
            const BookingDetailsCard(),

            const Spacer(),

            // 3. Next Step Button
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoute.checkinSecondStep);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Next Step',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepperWidget extends StatelessWidget {
  final int currentStep;
  const StepperWidget({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        int stepNum = index + 1;
        bool isActive = stepNum == currentStep;

        return Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isActive
                    ? const Color(0xFF2962FF)
                    : Colors.grey.shade200,
                child: Text(
                  '$stepNum',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (index != 5) // Don't add a line after the last circle
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.grey.shade200,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class BookingDetailsCard extends StatelessWidget {
  const BookingDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow("Booking ID", "BK-002"),
          _buildDetailRow("Customer Name", "Sarah Johnson"),
          _buildDetailRow("Vehicle", "Honda CR-V"),
          _buildDetailRow("Pickup Date", "2/26/2026 02:00 PM"),
          _buildDetailRow("Return Date", "3/5/2026"),
          _buildDetailRow("Location", "Airport Branch"),
          _buildDetailRow("Assigned Agent", "Agent 001", isLast: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey.shade100, height: 1),
      ],
    );
  }
}
