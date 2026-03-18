import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:go_router/go_router.dart';


import 'package:provider/provider.dart';


class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen to your provider
    final provider = context.watch<CustomerProvider>(); 
    final car = provider.carDetails;

  

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Stack(
                  children: [
                    Image.network(
                      car!.featuredImageUrl ?? 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop', // Dynamic Image
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => context.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),

                // --- 2. Main Info Card ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                car.carName ?? 'Unknown Car', // Dynamic Name
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                car.category ?? 'General', // Dynamic Category
                                style: const TextStyle(
                                  color: Color(0xFFE91E63),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            Text(
                              ' ${car.averageRating ?? 0.0}', // Dynamic Rating
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' (${car.totalReviews ?? 0} reviews)', // Dynamic Reviews
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(
                              '\$${car.pricePerDay ?? '0'}', // Dynamic Price
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Text('/day', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SpecIcon(Icons.people_outline, '${car.seats ?? 0} Seats'),
                              _SpecIcon(Icons.door_front_door, '${car.doors ?? 0} Door'), // Dynamic Seats
                            _SpecIcon(Icons.settings_outlined, car.transmission ?? 'N/A'), // Dynamic Transmission
                            _SpecIcon(Icons.ev_station, car.fuelType ?? 'N/A'), // Dynamic Fuel
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- 3. Provider Card ---
                _buildSectionCard(
                  title: 'Provided By',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.directions_car, color: Colors.red),
                    ),
                    title: Text(
                      car.agencyName ?? 'Unknown Agency', // Dynamic Agency
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Verified Agency',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),

                // --- 4. Features Section ---
                if (car.availableServices != null && car.availableServices!.isNotEmpty)
                _buildSectionCard(
                  title: 'Available Services',
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: car.availableServices!.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                    ),
                    itemBuilder: (context, index) {
                      final service = car.availableServices![index];
                      return _FeatureItem('${service.name} (\$${service.pricePerDay})');
                    },
                  ),
                ),

                // --- 5. Pickup Location ---
                _buildSectionCard(
                  title: 'Pickup Location',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car.agencyName ?? 'Agency Location',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  car.agencyLocation ?? 'Address not available', // Dynamic Location
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                   _buildSectionCard(

                  title: 'Rental Terms',

                  color: const Color(0xFFF0F7FF),

                  child: const Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      _TermItem('Valid driving license required'),

                      _TermItem('Minimum age: 21 years'),

                      _TermItem('Security deposit will be held'),

                      _TermItem('Full insurance included'),

                      _TermItem('24/7 roadside assistance'),

                    ],

                  ),

                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // --- Bottom Sticky Button ---
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
               context.push(AppRoute.customerRequestQuatation);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'Request Quotation',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... (keep your _buildSectionCard and Helper Classes exactly as they were)
}
 Widget _buildSectionCard({
    required String title,
    required Widget child,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.04,
              ), // Matches the subtle depth in
              blurRadius: 12, // Smooth spread for a modern look
              offset: const Offset(0, 4), // Slight downward push
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }
class _SpecIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecIcon(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String label;
  const _FeatureItem(this.label);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}

class _TermItem extends StatelessWidget {
  final String text;
  const _TermItem(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '• $text',
        style: const TextStyle(color: Colors.black54, fontSize: 13),
      ),
    );
  }
}
