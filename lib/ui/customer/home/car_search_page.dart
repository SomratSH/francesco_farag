import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/home/home_customer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CarSearchListPage extends StatelessWidget {
  const CarSearchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: carProvider.isSearchLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: carProvider.carsSearch.results!.length,
              itemBuilder: (ctx, i) {
                final car = carProvider.carsSearch.results![i];
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
              },
            ),
    );
  }
}
