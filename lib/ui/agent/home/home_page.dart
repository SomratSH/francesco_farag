import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/ui/agent/home/widget/stats_card.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// Import the file created above

class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pink Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              decoration: BoxDecoration(
                gradient: AppColors().gradientPink,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Agent Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage your booking and rentals",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Horizontal Stats
                        StatCard(
                          icon: Icons.attach_money,
                          title: "Today's Revenue",
                          value:
                              "${provider.agentDashboardModel.todaysRevenue}",
                          showTrend: true,
                        ),
                        StatCard(
                          icon: Icons.access_time,
                          title: "Pending Bookings",
                          value: provider.agentDashboardModel.pendingBookings!
                              .toString(),
                        ),
                        StatCard(
                          icon: Icons.check_circle_outline,
                          title: "Today Active",
                          value: provider.agentDashboardModel.todayActive!
                              .toString(),
                        ),

                        const SizedBox(height: 24),

                        // Section Header
                        _buildSectionHeader("Today's Check-in", true),
                        const CheckInTile(
                          name: "John Smith",
                          carModel: "BMW 3 Series",
                          time: "10:00 AM",
                          initial: "J",
                        ),
                        const CheckInTile(
                          name: "Michael Brown",
                          carModel: "Mercedes C-Class",
                          time: "10:00 AM",
                          initial: "M",
                        ),

                        const SizedBox(height: 12),

                        Column(
                          children: [
                            _buildSectionHeader("Quick Access", false),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      context.push(AppRoute.bookingRequest),
                                  child: QuickAccessItem(
                                    title: "Booking\nStatus",
                                    icon: Icons.access_time,
                                    isPrimary: true,
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      context.push(AppRoute.checkinout),
                                  child: QuickAccessItem(
                                    title: "Check-in & Checkout",
                                    icon: Icons.directions_car,
                                    isPrimary: true,
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      context.push(AppRoute.createFine),
                                  child: QuickAccessItem(
                                    title: "Create Fine",
                                    icon: Icons.receipt_long,
                                    isPrimary: true,
                                  ),
                                ),
                                QuickAccessItem(
                                  title: "Customer Messages",
                                  icon: Icons.chat_bubble_outline,
                                  isPrimary: true,
                                ),
                              ],
                            ),
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

  Widget _buildSectionHeader(String title, bool isViewAll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          isViewAll
              ? TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View All →",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
