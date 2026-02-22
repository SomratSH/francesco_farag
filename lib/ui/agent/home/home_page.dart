import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/home/widget/stats_card.dart';
import 'package:go_router/go_router.dart';
 // Import the file created above

class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pink Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
              decoration: const BoxDecoration(
                color: Color(0xFFE91E63),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Agent Dashboard", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Manage your booking and rentals", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Horizontal Stats
                  const StatCard(icon: Icons.attach_money, title: "Today's Revenue", value: "\$4256", showTrend: true),
                  const StatCard(icon: Icons.access_time, title: "Pending Bookings", value: "5"),
                  const StatCard(icon: Icons.check_circle_outline, title: "Today Active", value: "12"),

                  const SizedBox(height: 24),

                  // Section Header
                  _buildSectionHeader("Today's Check-in"),
                  const CheckInTile(name: "John Smith", carModel: "BMW 3 Series", time: "10:00 AM", initial: "J"),
                  const CheckInTile(name: "Michael Brown", carModel: "Mercedes C-Class", time: "10:00 AM", initial: "M"),

                  const SizedBox(height: 24),

                  _buildSectionHeader("Quick Access"),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children:  [
                      InkWell(
                        onTap: () => context.push(AppRoute.bookingRequest),
                    child: QuickAccessItem(title: "Booking Status", icon: Icons.access_time, isPrimary: true)),
                      InkWell(
                        onTap: () => context.push(AppRoute.checkinout),
                        child: QuickAccessItem(title: "Check-in & Checkout", icon: Icons.directions_car)),
                      InkWell(
                        onTap: () => context.push(AppRoute.createFine),
                        child: QuickAccessItem(title: "Create Fine", icon: Icons.receipt_long)),
                      QuickAccessItem(title: "Customer Messages", icon: Icons.chat_bubble_outline),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          TextButton(
            onPressed: () {},
            child: const Text("View All →", style: TextStyle(color: Colors.blue, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}