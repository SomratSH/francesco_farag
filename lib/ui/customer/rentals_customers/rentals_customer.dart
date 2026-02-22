import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';

class RentalsCustomer extends StatefulWidget {
  const RentalsCustomer({super.key});

  @override
  State<RentalsCustomer> createState() => _RentalsCustomerState();
}

class _RentalsCustomerState extends State<RentalsCustomer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
      
        title: const Text('My Rentals', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Pending (1)'),
            Tab(text: 'Approved (1)'),
            Tab(text: 'Rejected (1)'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRentalList('Pending'),
          _buildRentalList('Approved'),
          _buildRentalList('Rejected'),
          _buildRentalList('Completed'),
        ],
      ),
    );
  }

  Widget _buildRentalList(String status) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        RentalCard(
          carName: 'BMW 5 Series',
          status: status,
          pickupDate: '2026-02-15',
          returnDate: '2026-02-18',
          totalPrice: '104',
          imageUrl: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=2070&auto=format&fit=crop',
        ),
      ],
    );
  }
}

class RentalCard extends StatelessWidget {
  final String carName, status, pickupDate, returnDate, totalPrice, imageUrl;

  const RentalCard({
    super.key, 
    required this.carName, 
    required this.status, 
    required this.pickupDate, 
    required this.returnDate, 
    required this.totalPrice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(carName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    _buildStatusBadge(status),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today_outlined, 'Pickup', pickupDate),
                _buildInfoRow(Icons.history_outlined, 'Return', returnDate),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: const TextStyle(color: Colors.grey)),
                    Text('\$$totalPrice/day', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActionButton(status, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Pending': color = Colors.orange; break;
      case 'Approved': color = Colors.blue; break;
      case 'Rejected': color = Colors.red; break;
      default: color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label:', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String status, BuildContext context) {
    String label = status == 'Pending' ? 'View Booking Status' : 'View Assignment';
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.push(AppRoute.rentalsAssingment);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}