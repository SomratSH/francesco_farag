import 'dart:io';
import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

// Ensure your AgentProvider is imported
// import 'package:your_app/providers/agent_provider.dart';

class StepthreeCheckin extends StatefulWidget {
  const StepthreeCheckin({super.key});

  @override
  State<StepthreeCheckin> createState() => _StepthreeCheckinState();
}

class _StepthreeCheckinState extends State<StepthreeCheckin> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(AgentProvider provider) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  provider.addInspectionPhoto(image.path);
                }
                if (mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  provider.addInspectionPhoto(image.path);
                }
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgentProvider>(context);
    final data = provider.customerData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
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

            const StepperWidget(currentStep: 3),
            const SizedBox(height: 24),

            _buildInspectionForm(provider, data),

            const SizedBox(height: 24),

            _buildPhotoInspectionSection(provider, data),

            const SizedBox(height: 24),

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

  Widget _buildInspectionForm(AgentProvider provider, Map data) {
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
          _buildTextField(
            "e.g., 45000",
            data['startingKm'],
            (val) => provider.updateCustomerField('startingKm', val),
          ),
          _buildFieldLabel("Fuel Level"),
          _buildDropdownField(
            data['fuelLevel'] ?? "full",
            ["Empty", "Half", "Full"],
            (val) => provider.updateCustomerField('fuelLevel', "full"),
          ),
          _buildFieldLabel("Car Condition"),
          _buildDropdownField(
            data['carCondition'] ?? "Good condition",
            ["Good condition", "Damaged"],
            (val) => provider.updateCustomerField('carCondition', "good"),
          ),
          _buildFieldLabel("Inspection Notes"),
          _buildTextArea(
            "Any damages...",
            data['inspectionNotes'],
            (val) => provider.updateCustomerField('inspectionNotes', val),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoInspectionSection(AgentProvider provider, Map data) {
    // Pull the list from provider
    final List<String> photos = List<String>.from(
      data['inspectionPhotos'] ?? [],
    );

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
            'Vehicle Inspection Photos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            // Number of photos + 1 for the 'Add' button
            itemCount: photos.length + 1,
            itemBuilder: (context, index) {
              if (index == photos.length) {
                // The "Add" button at the end
                return _buildUploadBox(
                  "Add Photo",
                  null,
                  () => _pickImage(provider),
                );
              }

              // The actual selected picture
              return _buildUploadBox(
                "Photo ${index + 1}",
                photos[index],
                () => provider.removeInspectionPhoto(index), // Tap to delete
              );
            },
          ),
          const SizedBox(height: 20),
          // _buildProgressRow("Starting KM", "12,344 KM", 0.3),
          // const SizedBox(height: 12),
          // _buildProgressRow("Fuel Level", "80%", 0.8),
        ],
      ),
    );
  }

  Widget _buildUploadBox(String label, String? imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: imagePath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(imagePath), fit: BoxFit.cover),
                  // Small red "X" to show it can be removed
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
  );

  Widget _buildTextField(
    String hint,
    String initialValue,
    Function(String) onChanged,
  ) => TextFormField(
    initialValue: initialValue,
    onChanged: onChanged,
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

  Widget _buildDropdownField(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox(),
      items: items
          .map((String val) => DropdownMenuItem(value: val, child: Text(val)))
          .toList(),
      onChanged: onChanged,
    ),
  );

  Widget _buildTextArea(
    String hint,
    String initialValue,
    Function(String) onChanged,
  ) => TextFormField(
    initialValue: initialValue,
    onChanged: onChanged,
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
    width: double.infinity,
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
