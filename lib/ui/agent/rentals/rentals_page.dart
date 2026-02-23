import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class RentalsPage extends StatefulWidget {
  const RentalsPage({super.key});

  @override
  State<RentalsPage> createState() => _RentalsPageState();
}

class _RentalsPageState extends State<RentalsPage> {
  String isSelected = "Pending (2)";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,

        title: const Text(
          'Rentals',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // --- Tab / Filter Row ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => setState(() {
                    isSelected = "Pending (2)";
                  }),
                  child: _buildTab(
                    'Pending (2)',
                    isSelected: isSelected == "Pending (2)" ? true : false,
                  ),
                ),
                InkWell(
                  onTap: () => setState(() {
                    isSelected = "Active (3)";
                  }),
                  child: _buildTab(
                    'Active (3)',
                    isSelected: isSelected == "Active (3)" ? true : false,
                  ),
                ),
                InkWell(
                  onTap: () => setState(() {
                    isSelected = "Rejected (1)";
                  }),
                  child: _buildTab(
                    'Rejected (1)',
                    isSelected: isSelected == "Rejected (1)" ? true : false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- Booking List ---
          isSelected == "Pending (2)"
              ? Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      BookingCard(
                        name: 'John Smith',
                        initial: 'J',
                        carName: 'BMW 5 Series',
                        status: "Pending",
                        carImage:
                            'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=2070&auto=format&fit=crop',
                      ),
                      BookingCard(
                        name: 'Den Smith',
                        initial: 'D',
                        status: "Pending",
                        carName: 'BMW V7 Series',

                        carImage:
                            'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?q=80&w=2070&auto=format&fit=crop',
                      ),
                      BookingCard(
                        name: 'Alice Cooper',
                        initial: 'A',
                        carName: 'Tesla Model 3',
                        status: "Pending",
                        carImage:
                            'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
                      ),
                    ],
                  ),
                )
              : isSelected == "Active (3)"
              ? Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      BookingCard(
                        name: 'Sarah Jenkins',
                        initial: 'S',
                        carName: 'Mercedes C-Class',
                        status: "Active",
                        carImage:
                            'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?q=80&w=2070&auto=format&fit=crop',
                      ),
                      BookingCard(
                        name: 'Michael Ross',
                        initial: 'M',
                        carName: 'Audi A4',
                        status: "Active",
                        carImage:
                            'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=2070&auto=format&fit=crop',
                      ),
                    ],
                  ),
                )
              : isSelected == "Rejected (1)"
              ? Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: const [
                      BookingCard(
                        name: 'Robert Fox',
                        initial: 'R',
                        carName: 'Range Rover Evoque',
                        status: "Rejected",
                        carImage:
                            'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?q=80&w=2070&auto=format&fit=crop',
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4A80F0) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        gradient: isSelected ? AppColors().gradientBlue : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String name;
  final String initial;
  final String carName;
  final String carImage;
  final String? status;

  const BookingCard({
    super.key,
    required this.name,
    this.status,
    required this.initial,
    required this.carName,
    required this.carImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50),
      ),
      child: Column(
        children: [
          // User Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF81D4FA),
                  child: Text(
                    initial,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Requested booking',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Car Image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                carImage,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      carName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    status == "Pending"
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Pending',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : status == "Active"
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffDCFCE7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/approved.svg"),
                                SizedBox(width: 5),
                                const Text(
                                  'Approved',
                                  style: TextStyle(
                                    color: Color(0xff008236),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : status == "Rejected"
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xffFFE2E2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/rejected.svg"),
                                SizedBox(width: 5),
                                const Text(
                                  'Rejected',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(
                      ' 4.8',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  'Pickup',
                  '2026-02-15',
                ),
                _buildInfoRow(Icons.history_outlined, 'Return', '2026-02-18'),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5 seats - Automatic',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        Text(
                          ' Airport Terminal 1',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Note
                status == "Rejected" || status == "Active"
                    ? SizedBox()
                    : Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'Customer Note: Need the car for a business trip',
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                // Buttons
                status == "Rejected" || status == "Active"
                    ? SizedBox()
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: AppColors().gradientBlue,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  context.push(AppRoute.crateQuatation);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: const Text(
                                  'Create Quotation',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                status == "Active"
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppColors().gradientBlue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
