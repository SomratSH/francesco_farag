import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';

class StepthreeCheckin extends StatefulWidget {
  const StepthreeCheckin({super.key});

  @override
  State<StepthreeCheckin> createState() => _StepthreeCheckinState();
}

class _StepthreeCheckinState extends State<StepthreeCheckin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
          leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text(
          'Check-in',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Info',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Vehicle Entry',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // 1. Progress Stepper (Step 3 Active)
            const StepperWidget(currentStep: 3),
            const SizedBox(height: 24),

            // 2. Car Inspection Form Card
            _buildInspectionForm(),

            const SizedBox(height: 24),

            // 3. Vehicle Photo Inspection Card
            _buildPhotoInspectionSection(),

            const SizedBox(height: 24),

            // 4. Navigation
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton("Previous", () => context.pop()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPrimaryButton("Next Step", () {
                    context.push(AppRoute.checkinFourStep);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInspectionForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                'Car Inspection',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFieldLabel("Starting Kilometers"),
          _buildTextField("e.g., 45000"),
          _buildFieldLabel("Fuel Level"),
          _buildDropdownField("Full"),
          _buildFieldLabel("Car Condition"),
          _buildDropdownField("Good condition"),
          _buildFieldLabel("Inspection Notes"),
          _buildTextArea("Any damages, scratches, or concerns..."),
        ],
      ),
    );
  }

  Widget _buildPhotoInspectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 1: Vehicle Inspection',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildUploadBox("Front"),
              _buildUploadBox("Back"),
              _buildUploadBox("Left"),
              _buildUploadBox("Right"),
              _buildUploadBox("Interior"),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://placeholder.com/car_thumb.png',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      Container(color: Colors.grey.shade200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressRow("Starting KM", "12,344 KM", 0.3),
          const SizedBox(height: 12),
          _buildProgressRow("Fuel Level", "80%", 0.8),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
  );

  Widget _buildTextField(String hint) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );

  Widget _buildDropdownField(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox(),
      items: [value]
          .map((String val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
      onChanged: (_) {},
    ),
  );

  Widget _buildTextArea(String hint) => TextField(
    maxLines: 4,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );

  Widget _buildUploadBox(String label) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add, color: Colors.blue),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    ),
  );

  Widget _buildProgressRow(
    String label,
    String value,
    double progress,
  ) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
      const SizedBox(height: 6),
      LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey.shade200,
        color: Colors.blue,
        minHeight: 6,
        borderRadius: BorderRadius.circular(10),
      ),
    ],
  );

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) => Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
      ),
      borderRadius: BorderRadius.circular(30),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) =>
      OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      );
}
