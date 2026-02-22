import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart' show AppRoute;
import 'package:go_router/go_router.dart';

class CarDetailsScreen extends StatelessWidget {
  const CarDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. Car Image Header ---
                Stack(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
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
                          onPressed: () {
                            context.pop();
                          },
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
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tesla Model 3', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(10)),
                              child: const Text('Economy', style: TextStyle(color: Color(0xFFE91E63), fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            const Text(' 4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text(' (480 reviews)', style: TextStyle(color: Colors.grey)),
                            const Spacer(),
                            const Text('\$89', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20)),
                            const Text('/day', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SpecIcon(Icons.people_outline, '5 Seats'),
                            _SpecIcon(Icons.settings_outlined, 'Automatic'),
                            _SpecIcon(Icons.ev_station, 'Electric'),
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
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.directions_car, color: Colors.red),
                    ),
                    title: const Text('EuroCar Rentals', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Verified Agency', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ),

                // --- 4. Features Section ---
                _buildSectionCard(
                  title: 'Features',
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    children: const [
                      _FeatureItem('Air Conditioning'),
                      _FeatureItem('Bluetooth'),
                      _FeatureItem('GPS Navigation'),
                      _FeatureItem('Parking Sensors'),
                      _FeatureItem('Cruise Control'),
                      _FeatureItem('Leather Seats'),
                    ],
                  ),
                ),

                // --- 5. Pickup Location ---
                _buildSectionCard(
                  title: 'Pickup Location',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('EuroDrive Agency', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Madrid Centro - Gran Via 45, 28013 Madrid', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'You must collect the car from this agency location. No home delivery available.',
                          style: TextStyle(color: Colors.blue, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 6. Rental Terms ---
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
                const SizedBox(height: 100), // Space for sticky button
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
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoute.customerRequestQuatation);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                child: const Text('Request Quotation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color ?? Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
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
      child: Text('• $text', style: const TextStyle(color: Colors.black54, fontSize: 13)),
    );
  }
}