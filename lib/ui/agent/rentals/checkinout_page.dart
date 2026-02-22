import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_route.dart';

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<CheckInOutScreen> createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  // Boolean to track which tab is active
  bool isCheckInActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('Check-in & Checkout', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // --- Custom Toggle Switch ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isCheckInActive = true),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isCheckInActive 
                            ? const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)])
                            : null,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Check-in',
                          style: TextStyle(
                            color: isCheckInActive ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isCheckInActive = false),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: !isCheckInActive 
                            ? const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)])
                            : null,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            color: !isCheckInActive ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // --- Dynamic List Content ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: isCheckInActive ? _buildCheckInList() : _buildCheckOutList(),
            ),
          ),
        ],
      ),
    );
  }

  // Demo Data for Check-in
  List<Widget> _buildCheckInList() {
    return  [
      InkWell(
        onTap: ()=> context.push(AppRoute.checkinProgress),
        child: StatusCard(
          name: 'Sarah Johnson',
          initial: 'S',
          car: 'BMW 3 Series',
          time: '10:00 AM',
          isActive: true, // First item highlighted in image
        ),
      ),
      InkWell(
         onTap: ()=> context.push(AppRoute.checkinProgress),
        child: StatusCard(name: 'David Martinez', initial: 'D', car: 'Mercedes C-Class', time: '04:00 PM')),
      InkWell(
         onTap: ()=> context.push(AppRoute.checkinProgress),
        child: StatusCard(name: 'Jhon Deo', initial: 'J', car: 'Mercedes C-Class', time: '12:00 PM')),
      InkWell(
         onTap: ()=> context.push(AppRoute.checkinProgress),
        child: StatusCard(name: 'Rokxin', initial: 'R', car: 'Mercedes C-Class', time: '10:00 AM')),
    ];
  }

  // Demo Data for Checkout
  List<Widget> _buildCheckOutList() {
    return  [
      InkWell(
        onTap: () => context.push(AppRoute.checkoutProgess),
        child: StatusCard(name: 'Michael Chen', initial: 'M', car: 'Audi A4', time: '09:00 AM')),
      InkWell(
        onTap: () => context.push(AppRoute.checkoutProgess),
        child: StatusCard(name: 'Emma Wilson', initial: 'E', car: 'Tesla Model 3', time: '02:30 PM')),
    ];
  }
}

class StatusCard extends StatelessWidget {
  final String name;
  final String initial;
  final String car;
  final String time;
  final bool isActive;

  const StatusCard({
    super.key, 
    required this.name, 
    required this.initial, 
    required this.car, 
    required this.time,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isActive 
          ? const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)])
          : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? null : Border.all(color: Colors.grey.shade100),
        boxShadow: [
          if (isActive) BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.white.withOpacity(0.3) : const Color(0xFFE3F2FD),
          child: Text(initial, 
            style: TextStyle(color: isActive ? Colors.white : Colors.blue, fontWeight: FontWeight.bold)),
        ),
        title: Text(
          name, 
          style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black87),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.directions_car_outlined, size: 14, color: isActive ? Colors.white70 : Colors.grey),
            const SizedBox(width: 4),
            Text(car, style: TextStyle(color: isActive ? Colors.white70 : Colors.grey)),
          ],
        ),
        trailing: Text(
          time,
          style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}