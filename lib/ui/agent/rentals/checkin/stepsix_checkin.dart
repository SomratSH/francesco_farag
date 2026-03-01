import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';

class StepsixCheckin extends StatelessWidget {
  const StepsixCheckin({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review & Sync',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Vehicle Entry',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // 1. Progress Stepper (Step 6 Active)
            const StepperWidget(currentStep: 6),
            const SizedBox(height: 24),

            // 2. Summary Sections
            _buildReviewSection("Customer Info", [
              _buildReviewRow("Name", "John Smith"),
              _buildReviewRow("Email", "js@example.com"),
              _buildReviewRow("Phone", "+4562000000000"),
              _buildReviewRow("Address", "123 USB City More"),
            ]),

            _buildReviewSection("Billing Info", [
              const Text(
                "Same as customer address",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ]),

            _buildReviewSection("Documents", [
              _buildReviewRow("Type", "National ID"),
              _buildReviewRow("Number", "659999962"),
              _buildReviewRow("Expiry", "02-05-2028"),
              Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Pending",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ]),

            _buildReviewSection("Vehicle Condition", [
              _buildReviewRow("Exterior", "Good"),
              _buildReviewRow("Interior", "Good"),
              _buildReviewRow("Fuel Level", "Full"),
              _buildReviewRow("Mileage", "km"),
              _buildReviewRow("Photos", "0 uploaded"),
            ]),

            // 3. Payment & Deposit Card (Stand-alone style)
            _buildPaymentSummaryCard(),

            _buildReviewSection("Rental Details", [
              _buildReviewRow("Booking ID", "BK-001"),
              _buildReviewRow("Vehicle", "Toyota Camry"),
              _buildReviewRow("Rental Period", "2/26/2026 - 3/2/2026"),
              _buildReviewRow("Location", "Downtown Branch"),
            ]),

            // 4. CARGOS Integration Card
            _buildIntegrationCard(),

            const SizedBox(height: 24),

            // 5. Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton("Previous", () => context.pop()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(AppRoute.home);
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Complete Check-in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853), // Green
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF00C853),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 13),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.payment, size: 18),
              SizedBox(width: 8),
              Text(
                'Payment & Deposit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAmountRow("Rental Amount", "\$150"),
          _buildAmountRow("Deposit Amount", "\$500"),
          const Divider(),
          _buildAmountRow("Total Amount", "\$650", isTotal: true),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CARGOS Integration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sync Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Ready to sync with CARGOS",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Not Synced",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reuse existing Button styles
  Widget _buildAmountRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey,
              fontSize: 13,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isTotal ? Colors.blue : Colors.black,
              fontSize: isTotal ? 15 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) =>
      OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      );
}
