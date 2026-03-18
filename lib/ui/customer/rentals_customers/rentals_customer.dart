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
class _RentalsCustomerState extends State<RentalsCustomer> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Fetch data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchRentalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    
    // Count items for tab labels
    int pendingCount = provider.rentalList.where((e) => e.status == 'pending').length;
    int approvedCount = provider.rentalList.where((e) => e.status == 'approved').length;
    int rejectedCount = provider.rentalList.where((e) => e.status == 'rejected').length;
    int completedCount = provider.rentalList.where((e) => e.status == 'completed').length;

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
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  
  // This removes the default underline
  indicatorSize: TabBarIndicatorSize.tab, 
  dividerColor: Colors.transparent, 
  
  // THE MAGIC: Custom Pill Indicator
  indicator: BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    gradient: const LinearGradient(
      colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  
  labelColor: Colors.white, // Color when selected
  unselectedLabelColor: Colors.grey.shade600, // Color when not selected
  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
  
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
  print(_tabController.index);
  print(tabIndex);
  // Check if this specific tab is the one currently selected
  bool isSelected = _tabController.index == tabIndex;

  return Tab(
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // If selected, make border transparent so it doesn't show over the gradient
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade200, 
          width: 1,
        ),
      ),
      child: Text('$label ($count)'),
    ),
  );
}
  Widget _buildRentalList(CustomerProvider provider, String status) {
    // Filter the list based on status
    final filteredList = provider.rentalList.where((rental) => rental.status == status).toList();

    if (filteredList.isEmpty) {
      return Center(child: Text("No $status rentals found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final rental = filteredList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RentalCard(rental: rental), // Pass the whole object
        );
      },
    );
  }
}


class RentalCard extends StatelessWidget {
  final RentalRequest rental; // Use your model here

  const RentalCard({super.key, required this.rental});

  @override
  Widget build(BuildContext context) {
    // Logic to handle null image or use placeholder
    String imageUrl = rental.carDetails.imageUrl ?? "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop";
    
    // Logic for price: use quotation price if available, otherwise base price
    String displayPrice = rental.quotation?.totalPrice ?? rental.carDetails.pricePerDay;

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
                    Expanded(
                      child: Text(rental.carDetails.carName, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    _buildStatusBadge(rental.status),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.calendar_today_outlined, 'Pickup', rental.pickupDate.split("T").first),
                _buildInfoRow(Icons.history_outlined, 'Return', rental.returnDate.split("T").first),
                _buildInfoRow(Icons.timer_outlined, 'Duration', "${rental.totalDays} Days"),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(color: Colors.grey)),
                    Text('\$$displayPrice', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActionButton(rental.status, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets (Same as yours but cleaner)
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending': color = Colors.orange; break;
      case 'approved': color = Colors.blue; break;
      case 'rejected': color = Colors.red; break;
      default: color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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
    String label = status.toLowerCase() == 'pending' ? 'View Assingment' : 'View Details';
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () => context.push(AppRoute.rentalsAssingment, extra: rental),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}