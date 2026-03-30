import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/customer/home/home_customer.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Added
import 'package:francesco_farag/ui/customer/customer_provider.dart'; // Ensure path is correct

class AllCarsCustomerPage extends StatefulWidget {
  const AllCarsCustomerPage({super.key});

  @override
  State<AllCarsCustomerPage> createState() => _AllCarsCustomerPageState();
}

class _AllCarsCustomerPageState extends State<AllCarsCustomerPage> {
  String selectedCategory = 'All'; // Changed default to 'All'
  final List<String> categories = ['All', 'Economy', 'Compact', 'Luxury'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final allCars = provider.carsModel.results!;

    // Filter logic based on selectedCategory
    final filteredCars = selectedCategory == 'All'
        ? allCars
        : allCars.where((car) => car.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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

          // --- Dynamic Car List ---
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCars.isEmpty
                ? const Center(
                    child: Text("No cars available in this category"),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCars.length,
                    itemBuilder: (context, index) {
                      final car = filteredCars[index];
                      return InkWell(
                        onTap: () =>
                            context.push(AppRoute.carDetails, extra: car),
                        child: CarCard(
                          image:
                              provider
                                      .carsModel
                                      .results![index]
                                      .featuredImageUrl ==
                                  null
                              ? ""
                              : provider
                                    .carsModel
                                    .results![index]
                                    .featuredImageUrl
                                    .toString(),
                          name: provider.carsModel.results![index].carName
                              .toString(),
                          type: provider.carsModel.results![index].category!,
                          price:
                              provider.carsModel.results![index].pricePerDay!,
                          seats: provider.carsModel.results![index].seats!
                              .toString(),
                          gear:
                              provider.carsModel.results![index].transmission!,
                          door: provider.carsModel.results![index].doors!,
                          engineType:
                              provider.carsModel.results![index].fuelType!,
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
