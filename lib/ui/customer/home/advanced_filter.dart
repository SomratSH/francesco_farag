import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/home/home_customer.dart';
import 'package:francesco_farag/ui/customer/model/cars_model.dart';
import 'package:francesco_farag/utils/custom_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdvancedFilter extends StatefulWidget {
  const AdvancedFilter({super.key});

  @override
  State<AdvancedFilter> createState() => _AdvancedFilterState();
}

class _AdvancedFilterState extends State<AdvancedFilter> {
  // Filter States
  double _maxPrice = 500.0;
  String _selectedSeats = 'Any';
  bool _ecoFriendly = false;
  bool _availableOnly = true;
  bool isFilter = false;
  String _selectedTransmission = 'Any';
  String _selectedFuel = 'Any';

  final List<String> _transmissionOptions = ['Any', 'Automatic', 'Manual'];
  final List<String> _fuelOptions = [
    'Any',
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: isFilter
          ? Consumer<CustomerProvider>(
              builder: (context, provider, child) {
                final carList = provider.carsSearch.results ?? [];

                if (carList.isEmpty) {
                  return const Center(
                    child: Text("No cars match your criteria."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: carList.length,
                  itemBuilder: (context, index) {
                    final car = carList[index];
                    return CarCard(
                      image: car.featuredImageUrl == null
                          ? ""
                          : car.featuredImageUrl.toString(),
                      name: car.carName.toString(),
                      type: car.category!,
                      price: car.pricePerDay!,
                      seats: car.seats!.toString(),
                      gear: car.transmission!,
                      door: car.doors!,
                      engineType: car.fuelType!,
                    );
                    ; // Update this helper to accept Car data
                  },
                );
              },
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- Price Range Card ---
                  _buildFilterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(Icons.attach_money, 'Price Range (per day)'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '\$0',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '\$${_maxPrice.toInt()}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _maxPrice,
                          max: 500,
                          divisions: 20,
                          activeColor: Colors.blue,
                          onChanged: (val) => setState(() => _maxPrice = val),
                        ),
                      ],
                    ),
                  ),

                  // --- Number of Seats Card ---
                  _buildFilterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(null, 'Number of Seats'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              [
                                'Any',
                                '4 seats',
                                '5 seats',
                                '7 seats',
                                "9 Seats",
                              ].map((label) {
                                bool isSelected = _selectedSeats == label;
                                return _buildChoiceChip(label, isSelected);
                              }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // --- Dropdown Sections ---
                  _buildFilterCard(
                    child: _buildFilterCard(
                      child: _buildDropdownField(
                        label: 'Transmission Type',
                        value: _selectedTransmission,
                        items: _transmissionOptions,
                        onChanged: (val) =>
                            setState(() => _selectedTransmission = val!),
                      ),
                    ),
                  ),
                  _buildFilterCard(
                    child: _buildDropdownField(
                      label: 'Fuel Type',
                      value: _selectedFuel,
                      items: _fuelOptions,
                      onChanged: (val) => setState(() => _selectedFuel = val!),
                    ),
                  ),

                  // --- Toggle Section ---
                  _buildFilterCard(
                    child: Column(
                      children: [
                        _buildToggleRow(
                          'Eco-Friendly Only',
                          _ecoFriendly,
                          (v) => setState(() => _ecoFriendly = v),
                        ),
                        const Divider(height: 20),
                        _buildToggleRow(
                          'Available Only',
                          _availableOnly,
                          (v) => setState(() => _availableOnly = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- Apply Filter Button ---
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isFilter = true;
                        });

                        CustomLoading.show(context);

                        final provider = context.read<CustomerProvider>();

                        await provider.fetchFilteredCars(
                          category: "", // Ensure you have this variable
                          transmission:
                              _selectedTransmission, // Ensure you have this variable
                          minPrice: 0,
                          maxPrice: _maxPrice,
                          seats: _selectedSeats,
                        );

                        if (context.mounted) {
                          CustomLoading.hide(context);
                          setState(() {
                            isFilter =
                                true; // Switch view to show the results list
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Helper Widgets to keep code clean
  Widget _buildFilterCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _header(IconData? icon, String title) {
    return Row(
      children: [
        if (icon != null) Icon(icon, size: 18, color: Colors.blue),
        if (icon != null) const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSeats = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Switch(value: value, activeColor: Colors.blue, onChanged: onChanged),
      ],
    );
  }

  Widget _buildCarCard(Results car) {
    // Replace 'dynamic' with your 'Result' or 'Car' model class
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Car Image with Status Badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  car.featuredImageUrl ??
                      'https://via.placeholder.com/400x200', // Dynamic Image
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.directions_car,
                      size: 50,
                      color: Colors.grey,
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
                // --- Car Name and Category Badge ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        car.carName ?? 'Unnamed Car',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        car.category ?? 'General',
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // --- Ratings and Specs ---
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    Text(
                      ' ${car.averageRating ?? "0.0"}', // Dynamic Rating
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${car.seats ?? "0"} seats • ${car.transmission ?? "N/A"}', // Dynamic Specs
                  style: const TextStyle(color: Colors.grey),
                ),

                // --- Price and Request Button ---
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${car.pricePerDay ?? "0"}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
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
                    _buildRequestButton(car.id), // Pass ID for the request
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestButton(int? carId) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF857A6),
            Color(0xFFE91E63),
          ], // Matching your main pink theme
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle booking request for this carId
          print("Requesting car ID: $carId");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Request',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
