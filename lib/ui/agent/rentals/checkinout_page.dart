import 'package:flutter/material.dart';
import 'package:francesco_farag/constant/app_urls.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/ui/agent/model/checkin_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  String _currentTab = "checkin"; // Values: "checkin" or "checkout"

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgentProvider>().getCheckInBookings(_currentTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
    final bookings = provider.checkInModel?.bookings ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
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
            // Custom Tab Row
            Row(
              children: [
                Expanded(child: _buildTab("Check-in", "checkin")),
                const SizedBox(width: 12),
                Expanded(child: _buildTab("Checkout", "checkout")),
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
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bookings.isEmpty
                  ? const Center(child: Text("No bookings available"))
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) => BookingCard(
                        booking: bookings[index],
                        type: _currentTab,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, String value) {
    bool isActive = _currentTab == value;
    return GestureDetector(
      onTap: () {
        setState(() => _currentTab = value);
        _fetchData();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                )
              : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: isActive ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final String type;

  const BookingCard({super.key, required this.booking, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isCheckIn = type == "checkin";
    Color statusColor = isCheckIn
        ? const Color(0xFF2196F3)
        : const Color(0xFFFF6D00);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Expanded(
                child: Text(
                  booking.customer?.fullName ?? "N/A",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isCheckIn ? "Pending Check-in" : "Pending Checkout",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RichDetail(label: "Booking ID", value: "BK${booking.id}"),
                    const SizedBox(height: 8),
                    _RichDetail(
                      label: "Plate",
                      value: booking.id.toString() ?? "N/A",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RichDetail(label: "Car", value: booking.vehicle ?? "N/A"),
                    const SizedBox(height: 8),
                    _RichDetail(
                      label: "Period",
                      value: "${booking.pickupDate} to ${booking.returnDate}",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.push(
              isCheckIn ? AppRoute.checkinFirstStep : AppRoute.checkinout,
              extra: isCheckIn ? booking : null,
            ),
            icon: const Icon(Icons.assignment_turned_in_outlined, size: 18),
            label: Text(isCheckIn ? "Check-in" : "Check-Out"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _RichDetail extends StatelessWidget {
  final String label, value;
  const _RichDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13, color: Colors.grey),
        children: [
          TextSpan(text: "$label: "),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
