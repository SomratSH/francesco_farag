import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/ui/agent/model/rental_request_model.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class RentalsPage extends StatefulWidget {
  const RentalsPage({super.key});

  @override
  State<RentalsPage> createState() => _RentalsPageState();
}

class _RentalsPageState extends State<RentalsPage> {
  String selectedStatus = "pending";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgentProvider>().getRentalRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
    final model = provider.rentalRequestsModel;

    // --- MODIFIED: Filter logic to include awaiting_payment in the Pending tab ---
    final filteredList =
        model?.requests?.where((req) {
          if (selectedStatus == "pending") {
            return req.status == "pending" ||
                req.status == "quotation_sent" ||
                req.status == "awaiting_payment";
          }
          // Ensure this matches the status string used in the tabs below
          return req.status == selectedStatus;
        }).toList() ??
        [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Rentals',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTab(
                        'Pending (${(model?.counts?.pending ?? 0) + (0)})',
                        isActive: selectedStatus == "pending",
                        onTap: () => setState(() => selectedStatus = "pending"),
                      ),
                      _buildTab(
                        'Approved (${model?.counts?.active ?? 0})',
                        isActive:
                            selectedStatus ==
                            "approved", // Changed from "approved" to match standard status
                        onTap: () =>
                            setState(() => selectedStatus = "approved"),
                      ),
                      _buildTab(
                        'Rejected (${model?.counts?.rejected ?? 0})',
                        isActive: selectedStatus == "rejected",
                        onTap: () =>
                            setState(() => selectedStatus = "rejected"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredList.isEmpty
                      ? const Center(child: Text("No requests found"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final request = filteredList[index];
                            return BookingCard(request: request);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildTab(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4A80F0) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isActive ? null : Border.all(color: Colors.grey.shade200),
          gradient: isActive ? AppColors().gradientBlue : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final RentalRequest request;

  const BookingCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
    final String currentStatus = request.status ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50),
      ),
      child: Column(
        children: [
          // Header: Customer Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF81D4FA),
                  child: Text(
                    request.customer?.fullName?.isNotEmpty == true
                        ? request.customer!.fullName![0].toUpperCase()
                        : "?",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.customer?.fullName ?? "Unknown Customer",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Requested booking',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Car Image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                request.car?.featuredImageUrl ??
                    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=2070&auto=format&fit=crop',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.directions_car, size: 50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.car?.carName ?? "Car Name",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusBadge(currentStatus),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(
                      ' ${request.car?.averageRating ?? 0.0}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  'Pickup',
                  request.pickupDateFormatted ?? "",
                ),
                _buildInfoRow(
                  Icons.history_outlined,
                  'Return',
                  request.returnDateFormatted ?? "",
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${request.car?.seats ?? 0} seats - ${request.car?.transmission ?? ""}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        Text(
                          ' Airport Terminal 1',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (request.notes != null && request.notes!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Note: ${request.notes}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF1E88E5),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 12),

                // --- MODIFIED: Button Logic for all statuses ---
                if (currentStatus == "pending" ||
                    currentStatus == "quotation_sent")
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: AppColors().gradientBlue,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final response = await provider.getBookingDetails(
                                request.id!.toString(),
                              );
                              if (response) {
                                context.push(AppRoute.crateQuatation);
                              } else {
                                AppSnackbar.show(
                                  context,
                                  title: "Quotation",
                                  message: "Something went wrong, try again",
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              'Create Quotation',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (currentStatus == "awaiting_payment")
                  // Added "Awaiting Payment" visual state
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_top_rounded,
                          color: Colors.amber.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Awaiting Customer Payment",
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (currentStatus == "active")
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors().gradientBlue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    String label = status;

    if (status == "active") {
      color = Colors.green;
      label = "Active";
    } else if (status == "rejected") {
      color = Colors.red;
      label = "Rejected";
    } else if (status == "quotation_sent") {
      color = Colors.blue;
      label = "Quoted";
    } else if (status == "awaiting_payment") {
      color = Colors.amber.shade700;
      label = "Awaiting Payment";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class Counts {
  int? pending;
  int? active;
  int? rejected;
  int?
  awaitingPayment; // Ensure this matches your API key (e.g., 'awaiting_payment')

  Counts({this.pending, this.active, this.rejected, this.awaitingPayment});

  Counts.fromJson(Map<String, dynamic> json) {
    pending = json['pending'] ?? 0;
    active = json['active'] ?? 0;
    rejected = json['rejected'] ?? 0;
    // Map the specific payment status count here
    awaitingPayment = json['awaiting_payment'] ?? json['awaitpayment'] ?? 0;
  }
}
