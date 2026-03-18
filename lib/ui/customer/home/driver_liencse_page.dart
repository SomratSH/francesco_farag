import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/model/driviing_license_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DrivingLicenseScreen extends StatefulWidget {
  const DrivingLicenseScreen({super.key});

  @override
  State<DrivingLicenseScreen> createState() => _DrivingLicenseScreenState();
}

class _DrivingLicenseScreenState extends State<DrivingLicenseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().getDrivingLicense();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final license = provider.licenseModel;
    final details = license?.details;

    // Logic: If status is 'verified', 'pending', or 'rejected', we show the status view.
    // Otherwise (or if null), we show the upload form.
    bool showStatusView =
        license != null &&
        (license.status == 'verified' ||
            license.status == 'pending' ||
            license.status == 'rejected');

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
          'Driving License',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: showStatusView
                  ? _buildStatusView(license!, details!)
                  : _buildUploadState(),
            ),
      bottomNavigationBar: !showStatusView && !provider.isLoading
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: _buildGradientButton('Submit for Verification', () {
                // TODO: Implement Upload API call
              }),
            )
          : null,
    );
  }

  // --- 1. UPLOAD STATE (The Form) ---
  Widget _buildUploadState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('License Number', 'Enter your license number'),
        const SizedBox(height: 15),
        _buildTextField('Expiry Date', 'YYYY-MM-DD'),
        const SizedBox(height: 25),
        _buildUploadBox('License Front Side'),
        const SizedBox(height: 15),
        _buildUploadBox('License Back Side'),
        const SizedBox(height: 25),
        _buildImportantNote(),
      ],
    );
  }

  // --- 2. STATUS VIEW (Dynamic Data from API) ---
  Widget _buildStatusView(DrivingLicenseModel data, LicenseDetails details) {
    Color statusColor;
    String statusLabel;
    String message;

    switch (data.status?.toLowerCase()) {
      case 'verified':
        statusColor = Colors.green;
        statusLabel = 'Verified';
        message = 'Your license has been verified. You can now book cars!';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusLabel = 'Rejected';
        message =
            details.licenseRejectionReason ??
            'Verification failed. Please re-upload.';
        break;
      default:
        statusColor = Colors.orange;
        statusLabel = 'Pending';
        message =
            'Your license is under review. This usually takes 24-48 hours.';
    }

    return Column(
      children: [
        // Blue Header Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manage Driving License',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (data.status == 'rejected')
                IconButton(
                  onPressed: () {
                    /* Logic to reset and allow re-upload */
                  },
                  icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Verification Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _statusBadge(statusLabel, statusColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCard(
          title: 'License Details',
          child: Column(
            children: [
              _DetailRow('License Number', details.licenseNumber ?? '---'),
              _DetailRow('Expiry Date', details.licenseExpiryDate ?? '---'),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER UI COMPONENTS ---

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_outlined, color: Colors.grey),
              Text(
                'Tap to upload image',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ensure all details are clearly visible. Licenses must be valid.',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(height: 24),
          ],
          child,
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onPress) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
        ),
        borderRadius: BorderRadius.circular(25),
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
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
