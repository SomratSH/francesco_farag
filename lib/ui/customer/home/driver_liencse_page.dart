import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/model/driviing_license_model.dart'; // Ensure correct spelling in your project
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart'; // Add this to pubspec.yaml for the dashed effect

class DrivingLicenseScreen extends StatefulWidget {
  const DrivingLicenseScreen({super.key});

  @override
  State<DrivingLicenseScreen> createState() => _DrivingLicenseScreenState();
}

class _DrivingLicenseScreenState extends State<DrivingLicenseScreen> {
  // To allow switching back to upload mode from the "Verified" state
  bool _forceEditMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().getDrivingLicense();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final license = provider.licenseModel;
    final details = license?.details;

    // Show status view if we have a license and we aren't explicitly trying to edit it
    bool showStatusView =
        license != null &&
        (license.status == 'verified' ||
            license.status == 'pending' ||
            license.status == 'rejected') &&
        !_forceEditMode;

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
          'Driving License',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: showStatusView
                  ? _buildStatusView(license!, details!)
                  : _buildUploadState(provider),
            ),
      bottomNavigationBar: !showStatusView && !provider.isLoading
          ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: _buildGradientButton(
                _forceEditMode
                    ? 'Update License'
                    : 'Verified', // Matching button text from image
                () {
                  // TODO: Implement actual upload logic
                  setState(() => _forceEditMode = false);
                },
              ),
            )
          : null,
    );
  }

  // --- 1. UPLOAD STATE (Matching image_89475d.png) ---
  Widget _buildUploadState(CustomerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputCard([
          _buildTextField('License Number', 'Enter your license number'),
          const SizedBox(height: 16),
          _buildTextField('Expiry Date', 'Enter your expiry date'),
        ]),
        const SizedBox(height: 20),
        _buildUploadBox('License Front side', 'Upload Front Side'), //
        const SizedBox(height: 16),
        _buildUploadBox(
          'License Front side',
          'Upload Front Side',
        ), // Repeated in your reference image
        const SizedBox(height: 16),
        _buildUploadBox(
          'License Back side',
          'Upload Front Side',
        ), // Text shows "Front" even on "Back" box in image
        const SizedBox(height: 24),
        _buildImportantNote(), //
      ],
    );
  }

  // --- 2. STATUS VIEW ---
  Widget _buildStatusView(DrivingLicenseModel data, LicenseDetails details) {
    Color statusColor = data.status == 'verified'
        ? Colors.green
        : (data.status == 'rejected' ? Colors.red : Colors.orange);

    return Column(
      children: [
        _buildCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Verification Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _statusBadge(data.status!.toUpperCase(), statusColor),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'License Details',
          trailing: IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.blue),
            onPressed: () => setState(() => _forceEditMode = true),
          ),
          child: Column(
            children: [
              _detailRow('License Number', details.licenseNumber ?? '---'),
              _detailRow('Expiry Date', details.licenseExpiryDate ?? '---'),
            ],
          ),
        ),
      ],
    );
  }

  // --- UI COMPONENTS FROM REFERENCE ---

  Widget _buildInputCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DottedBorder(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'PNG, JPG up to 10MB',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF7FF), // Light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Important',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _noteItem('Ensure all details are clearly visible'),
          _noteItem('License must be valid for the rental period'),
          _noteItem('Verification may take 24–48 hours'),
        ],
      ),
    );
  }

  Widget _noteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 4),
      child: Text(
        '• $text',
        style: const TextStyle(color: Colors.blue, fontSize: 12),
      ),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onPress) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF62A1FF), Color(0xFF4257FF)],
        ), // Blue gradient from image
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Reuse existing helper methods for Status View...
  Widget _buildCard({String? title, Widget? trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (trailing != null) trailing,
              ],
            ),
          if (title != null) const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
