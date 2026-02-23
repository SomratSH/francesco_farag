import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateFineScreen extends StatelessWidget {
  const CreateFineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'Create Fine',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Select Booking ---
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const FormLabel(label: 'Select Booking'),
                    const CustomDropdown(hintText: 'Choose a booking...'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Fine Details ---
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Fine Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    const FormLabel(label: 'Fine Type *'),
                    const CustomDropdown(hintText: 'Select fine type'),

                    const SizedBox(height: 15),
                    const FormLabel(
                      label: 'Amount *',
                      icon: Icons.attach_money,
                    ),
                    const CustomTextField(hintText: 'Enter amount'),

                    const SizedBox(height: 15),
                    const FormLabel(
                      label: 'Due Date *',
                      icon: Icons.calendar_today_outlined,
                    ),
                    const CustomDropdown(hintText: '02/04/2026'),

                    // --- Fine Type Grid ---
                    const SizedBox(height: 25),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.05,
                            ), // Matches the subtle depth in
                            blurRadius: 14, // Smooth spread for a modern look
                            offset: const Offset(0, 5), // Slight downward push
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'Fine Type',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: const [
                                FineTypeTile(
                                  icon: Icons.local_hospital,
                                  label: 'Speeding Violation',
                                  color: Colors.red,
                                ),
                                FineTypeTile(
                                  icon: Icons.traffic,
                                  label: 'Traffic Light Violation',
                                  color: Colors.green,
                                ),
                                FineTypeTile(
                                  icon: Icons.local_parking,
                                  label: 'Parking Violation',
                                  color: Colors.blue,
                                ),
                                FineTypeTile(
                                  icon: Icons.warning_amber_rounded,
                                  label: 'ZTL Violation',
                                  color: Colors.orange,
                                ),
                                FineTypeTile(
                                  icon: Icons.directions_car,
                                  label: 'Toll Violation',
                                  color: Colors.green,
                                ),
                                FineTypeTile(
                                  icon: Icons.build_outlined,
                                  label: 'Vehicle Damage',
                                  color: Colors.grey,
                                ),
                                FineTypeTile(
                                  icon: Icons.assignment_outlined,
                                  label: 'Other',
                                  color: Colors.brown,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Upload PDF Section ---
                    const SizedBox(height: 25),
                    const SectionHeader(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'Upload Fine PDF',
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.upload_file_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload Fine Document',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'PDF format recommended',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // --- Additional Note ---
                    const SizedBox(height: 20),
                    const SectionHeader(
                      icon: Icons.note_add_outlined,
                      title: 'Additional Note',
                    ),
                    const TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Provide details about the fine...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEEEEEE)),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // --- Action Buttons ---
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Send Fine to Client',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- Notification Box ---
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'The customer will receive an email and in-app notification about this fine. They can pay directly through the app or download an invoice.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class FormLabel extends StatelessWidget {
  final String label;
  final IconData? icon;
  const FormLabel({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 16, color: Colors.blue),
          if (icon != null) const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String hintText;
  const CustomDropdown({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hintText, style: const TextStyle(color: Colors.black54)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  const CustomTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class FineTypeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const FineTypeTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
