import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:francesco_farag/providers/agent_provider.dart'; // Ensure correct path

class StepsixCheckin extends StatelessWidget {
  const StepsixCheckin({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Access the provider and its data map
    final provider = Provider.of<AgentProvider>(context);
    final data = provider.customerData;

    // Helper to calculate photo count
    final int photoCount =
        (data['inspectionPhotos'] as List<dynamic>?)?.length ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
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

            // Stepper (Step 6 Active)
            const StepperWidget(currentStep: 6),
            const SizedBox(height: 24),

            // 2. Summary Sections with LIVE DATA
            _buildReviewSection("Customer Info", [
              _buildReviewRow("Name", data['fullName'] ?? "N/A"),
              _buildReviewRow("Nationality", data['nationality'] ?? "N/A"),
              _buildReviewRow("Address", data['address'] ?? "N/A"),
            ]),

            _buildReviewSection("Documents", [
              _buildReviewRow(
                "Type",
                data['documentType'] ?? "Driving License",
              ),
              _buildReviewRow("Number", data['documentNumber'] ?? "N/A"),
              _buildReviewRow("Expiry", data['documentExpiry'] ?? "N/A"),
              Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  _buildStatusChip(data['isVerified'] ?? false),
                ],
              ),
            ]),

            _buildReviewSection("Vehicle Condition", [
              _buildReviewRow("Condition", data['carCondition'] ?? "Good"),
              _buildReviewRow("Fuel Level", data['fuelLevel'] ?? "Full"),
              _buildReviewRow("Mileage", "${data['startingKm']} KM"),
              _buildReviewRow("Photos", "$photoCount uploaded"),
              _buildReviewRow("Notes", data['inspectionNotes'] ?? "None"),
            ]),

            _buildReviewSection("Rental Details", [
              _buildReviewRow("Booking ID", "BK-001"), // Static or from data
              _buildReviewRow("Vehicle", "Toyota Camry"),
              _buildReviewRow("Rental Period", "2/26/2026 - 3/2/2026"),
            ]),

            _buildIntegrationCard(),

            const SizedBox(height: 24),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton("Previous", () => context.pop()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      // Call API (Replace 235 with actual dynamic ID if available)
                      bool success = await provider.submitCheckin(
                        provider.selectCheckin.id!,
                      );

                      if (context.mounted) {
                        Navigator.pop(context); // Close loading dialog

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Check-in Completed Successfully!",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.go(AppRoute.home);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to sync with server."),
                            ),
                          );
                        }
                      }
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

  Widget _buildStatusChip(bool isVerified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isVerified ? "Verified" : "Pending",
        style: TextStyle(
          color: isVerified ? Colors.green : Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.bold,
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sync Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Ready to sync with CARGOS",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
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
