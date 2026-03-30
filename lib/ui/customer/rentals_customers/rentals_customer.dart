import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/model/rental_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RentalsCustomer extends StatefulWidget {
  const RentalsCustomer({super.key});

  @override
  State<RentalsCustomer> createState() => _RentalsCustomerState();
}

class _RentalsCustomerState extends State<RentalsCustomer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update tab borders
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchRentalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    // Count items for tab labels
    int pendingCount = provider.rentalList
        .where(
          (e) =>
              e.status == 'pending' ||
              e.status == "quotation_sent" ||
              e.status == "awaiting_payment",
        )
        .length;
    int approvedCount = provider.rentalList
        .where((e) => e.status == 'approved')
        .length;
    int rejectedCount = provider.rentalList
        .where((e) => e.status == 'rejected')
        .length;
    int completedCount = provider.rentalList
        .where((e) => e.status == 'completed')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'My Rentals',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          tabs: [
            _buildCustomTab('Pending', pendingCount, 0),
            _buildCustomTab('Approved', approvedCount, 1),
            _buildCustomTab('Rejected', rejectedCount, 2),
            _buildCustomTab('Completed', completedCount, 3),
          ],
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRentalList(provider, 'pending'),
                _buildRentalList(provider, 'approved'),
                _buildRentalList(provider, 'rejected'),
                _buildRentalList(provider, 'completed'),
              ],
            ),
    );
  }

  Widget _buildCustomTab(String label, int count, int tabIndex) {
    bool isSelected = _tabController.index == tabIndex;
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Text('$label ($count)'),
      ),
    );
  }

  Widget _buildRentalList(CustomerProvider provider, String tabStatus) {
    final filteredList = provider.rentalList.where((rental) {
      final status = rental.status.toLowerCase();
      if (tabStatus == 'pending') {
        return status == 'pending' ||
            status == 'quotation_sent' ||
            status == 'awaiting_payment';
      }
      return status == tabStatus;
    }).toList();

    if (filteredList.isEmpty) {
      return Center(child: Text("No ${tabStatus} rentals found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final rental = filteredList[index];
        // For Pending Tab, use the larger "Request" style card
        if (tabStatus == 'pending') {
          return InkWell(
            onTap: () =>
                context.push(AppRoute.rentalRequestDetails, extra: rental),
            child: _buildPendingRentalCard(rental, rental.status),
          );
        }
        // For Approved/Others, use the RentalCard with details-only view
        return RentalCard(rental: rental);
      },
    );
  }

  Widget _buildPendingRentalCard(RentalRequest rental, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100), // Subtle border
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
          // --- Image & Status Badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  rental.carDetails.imageUrl ??
                      'https://hips.hearstapps.com/hmg-prod/images/ferrari-e-suv-2-copy-680287cac36b2.jpg?crop=1.00xw:0.838xh;0,0.0673xh',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFFFF9C4,
                    ).withOpacity(0.9), // Light Yellow
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Car Name ---
                Text(
                  rental.carDetails.carName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Rating Row ---
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${rental.carDetails.averageRating ?? 4.8}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // --- Pickup & Date Row ---
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pickup',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      rental.pickupDate.split('T').first,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --- Specs & Location Row ---
                Row(
                  children: [
                    Text(
                      '${rental.carDetails.seats} seats • ${rental.carDetails.transmission}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Airport Terminal 1",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Gradient Action Button ---
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffFF67C2), Color(0xffD3037F)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffD3037F).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push(
                      AppRoute.rentalRequestDetails,
                      extra: rental,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "View Booking Status",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),

                // --- Pricing Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${rental.carDetails.pricePerDay}',
                            style: const TextStyle(
                              color: Color(0xFF2196F3), // Match the blue price
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: '/day',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RentalCard extends StatelessWidget {
  final RentalRequest rental;

  const RentalCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        rental.carDetails.imageUrl ??
        'https://hips.hearstapps.com/hmg-prod/images/ferrari-e-suv-2-copy-680287cac36b2.jpg?crop=1.00xw:0.838xh;0,0.0673xh'; // Placeholder logic

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade100,
        ), // Subtle border like image
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
          // --- 1. Top Section: Image with Badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  height: 180, // Matches large card style
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Dynamic Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: _buildStatusBadge(rental.status),
              ),
            ],
          ),

          // --- 2. Bottom Section: Info & Price ---
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rental.carDetails.carName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      '${rental.carDetails.averageRating ?? 4.8}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Rental Period Row
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pickup',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${rental.pickupDate.split('T').first}', // Format YYYY-MM-DD
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Specs & Location Row
                Row(
                  children: [
                    Text(
                      '${rental.carDetails.seats} seats • ${rental.carDetails.transmission}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rental.carDetails.agencyLocation ?? 'Terminal 1',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- 3. View Booking Status Button ---
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(
                      AppRoute.rentalRequestDetails,
                      extra: rental,
                    ),
                    icon: const Icon(Icons.access_time, size: 18),
                    label: const Text("View Booking Status"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(
                        0xFF3949AB,
                      ), // Darker Blue Text
                      side: BorderSide(color: Colors.blue.shade100),
                      backgroundColor: Colors.blue.shade50.withOpacity(
                        0.3,
                      ), // Very light fill
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const Divider(height: 32), // Separator
                // --- 4. Pricing Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${rental.quotation?.totalPrice ?? 104}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 24,
                            ),
                          ),
                          const TextSpan(
                            text: '/day',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'approved':
        color = Colors.blue;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.green; // Completed
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Translucent fill
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
