import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';

class AllCarsCustomerPage extends StatefulWidget {
  const AllCarsCustomerPage({super.key});

  @override
  State<AllCarsCustomerPage> createState() => _AllCarsCustomerPageState();
}

class _AllCarsCustomerPageState extends State<AllCarsCustomerPage> {
  String selectedCategory = 'Economy';
  final List<String> categories = ['Login', 'Economy', 'Compact', 'Luxury'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('All Agency Cars', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: Colors.black87))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Category Filter Bar ---
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategory == categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => selectedCategory = categories[index]);
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),

          // --- Car List ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Replace with dynamic data
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => context.push(AppRoute.carDetails),
                  child: const CarListItem(
                    name: 'Tesla Model 3',
                    type: 'Economy',
                    price: '89',
                    rating: '4.8',
                    specs: '5 seats • Automatic',
                    imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CarListItem extends StatelessWidget {
  final String name, type, price, rating, specs, imageUrl;
  
  const CarListItem({
    super.key, 
    required this.name, 
    required this.type, 
    required this.price, 
    required this.rating, 
    required this.specs, 
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Image & Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Car Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(10)),
                      child: Text(type, style: TextStyle(color: Colors.pink.shade400, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(specs, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: '\$$price', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                          const TextSpan(text: '/day', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    // Gradient "Request" Button
                    Container(
                      width: 120,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, 
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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