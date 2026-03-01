import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  // 1. Track the current filter state
  String _currentFilter = "All";

  // 2. Mock Data List
  final List<Map<String, dynamic>> _allBookings = [
    {
      "name": "John Doe",
      "status": "Pending Check-in",
      "type": "Check-in", // Category for filtering
      "color": Colors.blue,
      "button": "Check-in",
      "icon": true,
    },
    {
      "name": "John Smith",
      "status": "Active",
      "type": "Check-in", // Usually counts as check-in data
      "color": Colors.green,
      "button": "View Details",
      "icon": false,
    },
    {
      "name": "Mike Johnson",
      "status": "Pending Checkout",
      "type": "Checkout", // Category for filtering
      "color": Colors.orange,
      "button": "Check-Out",
      "icon": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 3. Filter the list based on selection
    final filteredBookings = _allBookings.where((booking) {
      if (_currentFilter == "All") return true;
      return booking['type'] == _currentFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Check-in & Checkout',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // 4. Tab Row with GestureDetector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterTab("All"),
                _buildFilterTab("Check-in"),
                _buildFilterTab("Checkout"),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Bookings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Manage check-ins and active rentals',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // 5. Dynamic List
            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  final item = filteredBookings[index];
                  return BookingCard(
                    name: item['name'],
                    status: item['status'],
                    statusColor: item['color'],
                    buttonText: item['button'],
                    hasIcon: item['icon'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build tabs and handle clicks
  Widget _buildFilterTab(String label) {
    bool isActive = _currentFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = label; // Update state and rebuild
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                )
              : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isActive ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Reusable Card Widget (Same as before but cleaned up)
class BookingCard extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final String buttonText;
  final bool hasIcon;

  const BookingCard({
    super.key,
    required this.name,
    required this.status,
    required this.statusColor,
    required this.buttonText,
    required this.hasIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailItem(label: "Booking ID", value: "BK001"),
              _DetailItem(
                label: "Car",
                value: "Toyota Camry",
                crossAlign: CrossAxisAlignment.end,
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              if (status.toLowerCase() == "pending check-in") {
                context.push(AppRoute.checkinFirstStep);
              } else if (status.toLowerCase() == "pending checkout") {
                context.push(AppRoute.checkoutProgess);
              } else if (status.toLowerCase() == "active") {
                context.push(AppRoute.bookingDetails);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasIcon)
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  if (hasIcon) const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment crossAlign;
  const _DetailItem({
    required this.label,
    required this.value,
    this.crossAlign = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
