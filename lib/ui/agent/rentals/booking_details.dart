import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // 1. Active Rental Status Header
            _buildStatusHeader(),
            const SizedBox(height: 20),

            // 2. Information Sections
            _buildSectionCard("Customer Information", Icons.person_outline, [
              _buildInfoRow("Name", "Michael Chen"),
              _buildInfoRow("Email", "michael.chen@example.com"),
              _buildInfoRow("Phone", "+1-555-0103"),
              _buildInfoRow("Nationality", "USA"),
            ]),

            _buildSectionCard(
              "Vehicle Information",
              Icons.directions_car_outlined,
              [
                _buildInfoRow(
                  "Vehicle",
                  "Tesla Model 3 2024",
                  isBoldValue: true,
                ),
                _buildInfoRow("Exterior Condition", "Good"),
                _buildInfoRow("Interior Condition", "Good"),
                _buildInfoRow("Fuel Level (Check-in)", "Full"),
                _buildInfoRow("Mileage (Check-in)", "15234 km"),
              ],
            ),

            _buildSectionCard("Rental Period", Icons.calendar_today_outlined, [
              _buildInfoRow("Pickup Date", "Feb 25, 2026 • 09:00 AM"),
              _buildInfoRow("Return Date", "Feb 28, 2026"),
              _buildInfoRow("Check-in Time", "Feb 25, 2026 • 09:00 AM"),
              _buildInfoRow(
                "Location",
                "Downtown Branch",
                icon: Icons.location_on_outlined,
              ),
            ]),

            _buildSectionCard(
              "Payment & Deposit",
              Icons.account_balance_wallet_outlined,
              [
                _buildInfoRow("Rental Amount", "\$150"),
                _buildInfoRow("Deposit Amount", "\$500"),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "\$650",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Payment Confirmed",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            // 3. Document Summary
            _buildSectionCard(
              "Document Information",
              Icons.description_outlined,
              [
                _buildInfoRow("Document Type", "Driving License"),
                _buildInfoRow("Document Number", "DL-CA-887654"),
                _buildInfoRow("Expiry Date", "5/15/2028"),
                _buildInfoRow(
                  "Verification Status",
                  "Verified",
                  statusColor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2962FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Active Rental",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.sync, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      "Synced",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time Remaining",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    "1d 19h remaining",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
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
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2962FF)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBoldValue = false,
    IconData? icon,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Row(
            children: [
              if (icon != null) Icon(icon, size: 14, color: Colors.grey),
              if (icon != null) const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: statusColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
