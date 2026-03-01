import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/utils/app_colors.dart';
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
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'All Agency Cars',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.black87),
          ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                    seats: "4",
                    door: "4",
                    engineType: "Eelectric",
                    gear: "Automatic",
                    name: 'Tesla Model 3',
                    type: 'Economy',
                    price: '89',
                    rating: '4.8',

                    imageUrl:
                        'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
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
  final String name,
      type,
      price,
      rating,
      seats,
      imageUrl,
      door,
      gear,
      engineType;

  const CarListItem({
    super.key,
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
    required this.seats,
    required this.imageUrl,
    required this.door,
    required this.engineType,
    required this.gear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Image & Badge
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: Colors.pink.shade400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/star.svg"),
                    SizedBox(width: 5),
                    Text(
                      "4.8",
                      style: TextStyle(color: Color(0xff6B7280), fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildFeatureRow(
                  Icons.group,
                  "$seats Seats",
                  "assets/icons/mdi_car-door.svg",
                  "$door Door",
                ),
                const SizedBox(height: 8),
                _buildFeatureRow(
                  null,
                  gear,
                  "assets/icons/bi_fuel-pump-diesel.svg",
                  engineType,
                  svgLeft: "assets/icons/gear_type.svg",
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$$price/',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const TextSpan(
                            text: 'day',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),

                    // Gradient "Request" Button
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors().gradientBlue,

                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: const Text(
                        'Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    IconData? iconLeft,
    String labelLeft,
    String svgRight,
    String labelRight, {
    String? svgLeft,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconText(iconLeft, labelLeft, svgLeft),
        _buildIconText(null, labelRight, svgRight),
      ],
    );
  }

  Widget _buildIconText(IconData? icon, String label, String? svgPath) {
    return Row(
      children: [
        svgPath != null
            ? SvgPicture.asset(
                svgPath,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              )
            : Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
