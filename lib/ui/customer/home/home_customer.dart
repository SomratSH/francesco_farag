import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class HomeCustomer extends StatelessWidget {
  const HomeCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              decoration: BoxDecoration(gradient: AppColors().gradientPink),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your Perfect Ride',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Book your self-drive car today',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            // --- Find Your Car Card (Overlapping) ---
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Find Your Car',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildLabel('Pickup Location'),
                      _buildDropdown('Select agency branches'),
                      const SizedBox(height: 12),
                      _buildLabel('Car Type'),
                      _buildDropdown('Select your car type'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTimeBox(
                              'Pickup Date',
                              'Select Date',
                              Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDateTimeBox(
                              'Time',
                              'Select Time',
                              Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateTimeBox(
                              'Return Date',
                              'Select Date',
                              Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDateTimeBox(
                              'Time',
                              'Select Time',
                              Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSearchButton(),
                      const SizedBox(height: 10),
                      _buildFilterButton(context),
                    ],
                  ),
                ),
              ),
            ),

            // --- Quick Access Grid ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _buildQuickAccessTile(
                    'My Rentals',
                    Icons.directions_car,
                    const Color(0xFFE91E63),
                    true,
                  ),
                  _buildQuickAccessTile(
                    'Fines',
                    Icons.attach_money,
                    Colors.blue,
                    false,
                  ),
                  _buildQuickAccessTile(
                    'Messages',
                    Icons.chat_bubble_outline,
                    Colors.blue,
                    false,
                  ),
                  InkWell(
                    onTap: () => context.push(AppRoute.driverLiencse),
                    child: _buildQuickAccessTile(
                      'License',
                      Icons.assignment_ind_outlined,
                      Colors.blue,
                      false,
                    ),
                  ),
                ],
              ),
            ),

            // --- Featured Cars Section ---
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Cars',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoute.allCarCustomer);
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24),
                children: const [
                  CarCard(
                    name: 'Tesla Model 3',
                    type: 'Economy',
                    price: '89',
                    seats: '5',
                    transmission: 'Automatic',
                  ),
                  CarCard(
                    name: 'BMW 5 Series',
                    type: 'Luxury',
                    price: '129',
                    seats: '5',
                    transmission: 'Automatic',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper UI Methods
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildDropdown(String hint) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text(hint, style: const TextStyle(fontSize: 13)),
        isExpanded: true,
        items: const [],
        onChanged: (v) {},
      ),
    ),
  );

  Widget _buildDateTimeBox(String label, String value, IconData icon) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildSearchButton() => Container(
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      gradient: AppColors().gradientPink,
      borderRadius: BorderRadius.circular(25),
    ),
    child: ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.search, color: Colors.white),
      label: const Text(
        'Search Cars',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
    ),
  );

  Widget _buildFilterButton(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton.icon(
      onPressed: () {
        context.push(AppRoute.advancedFilter);
      },
      icon: const Icon(Icons.tune, color: Colors.black87),
      label: const Text(
        'Advanced Filters',
        style: TextStyle(color: Colors.black87),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFF06292)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    ),
  );

  Widget _buildQuickAccessTile(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
  ) => Container(
    decoration: isSelected
        ? BoxDecoration(
            gradient: AppColors().gradientPink,
            borderRadius: BorderRadius.circular(15),
            border: isSelected ? null : Border.all(color: Colors.grey.shade100),
            boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
          )
        : BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: isSelected ? null : Border.all(color: Colors.grey.shade100),
            boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
          ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    gradient: AppColors().gradientBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
            child: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}

class CarCard extends StatelessWidget {
  final String name, type, price, seats, transmission;
  const CarCard({
    super.key,
    required this.name,
    required this.type,
    required this.price,
    required this.seats,
    required this.transmission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16, bottom: 10, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                        color: const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Color(0xFFE91E63),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$seats seats • $transmission',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$price/day',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors().gradientBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          minimumSize: const Size(80, 30),
                        ),
                        child: const Text(
                          'Request',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
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
