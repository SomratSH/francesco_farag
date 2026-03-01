import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';

class StepfourCheckin extends StatefulWidget {
  const StepfourCheckin({super.key});

  @override
  State<StepfourCheckin> createState() => _StepfourCheckinState();
}

class _StepfourCheckinState extends State<StepfourCheckin> {
  bool _isVerified = false;
  String _selectedDocType = "Driving License";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black),
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
              'Upload Documents',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Vehicle Entry',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // 1. Progress Stepper (Step 4 Active)
            const StepperWidget(currentStep: 4),
            const SizedBox(height: 24),

            // 2. Verification Status Card
            _buildVerificationCard(),
            const SizedBox(height: 20),

            // 3. Document Upload Boxes
            _buildUploadSection(),
            const SizedBox(height: 20),

            // 4. Document Information Form
            _buildDocInfoForm(),
            const SizedBox(height: 24),

            // 5. Navigation
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton("Previous", () => context.pop()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPrimaryButton("Next Step", () {
                    context.push(AppRoute.checkinFiveStep);
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

  Widget _buildVerificationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verification Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                'Mark document as verified',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          CupertinoSwitch(
            value: _isVerified,
            activeColor: const Color(0xFF2962FF),
            onChanged: (val) => setState(() => _isVerified = val),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
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
            'Document Uploads',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildDottedUploadBox("Document Front Image *", "Upload front image"),
          const SizedBox(height: 16),
          _buildDottedUploadBox("Document Back Image *", "Upload back image"),
        ],
      ),
    );
  }

  Widget _buildDottedUploadBox(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ), // Note: For true dotted use 'dotted_border' package
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_outlined, color: Colors.grey),
              Text(
                hint,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocInfoForm() {
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
            'Document Information',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildFieldLabel("Document Type"),
          _buildDropdownField(_selectedDocType),
          _buildFieldLabel("Document Number"),
          _buildTextField("DL-123456789"),
          _buildFieldLabel("Expiry Date"),
          _buildTextField("mm/dd/yyyy"),
        ],
      ),
    );
  }

  // Common UI Helpers (Consistent with previous steps)
  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
  );

  Widget _buildTextField(String hint) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _buildDropdownField(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(15),
    ),
    child: DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox(),
      items: [
        "Driving License",
        "Passport",
        "National ID",
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (val) => setState(() => _selectedDocType = val!),
    ),
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
