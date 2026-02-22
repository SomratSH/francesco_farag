import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrivingLicenseScreen extends StatefulWidget {
  const DrivingLicenseScreen({super.key});

  @override
  State<DrivingLicenseScreen> createState() => _DrivingLicenseScreenState();
}

class _DrivingLicenseScreenState extends State<DrivingLicenseScreen> {
  // States: 'upload', 'pending', 'rejected', 'verified'
  String licenseStatus = 'upload'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('Driving License', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildCurrentStateUI(),
      ),
      // Bottom button only for the initial upload state
      bottomNavigationBar: licenseStatus == 'upload' 
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: _buildGradientButton('Submit for Verification', () {
              setState(() => licenseStatus = 'pending');
            }),
          ) 
        : null,
    );
  }

  Widget _buildCurrentStateUI() {
    switch (licenseStatus) {
      case 'upload': return _buildUploadState();
      case 'pending': return _buildStatusView('Pending', Colors.orange, 'Your license has been submitted and is currently under verification. This may take 24-48 hours.');
      case 'rejected': return _buildStatusView('Rejected', Colors.red, 'Your license could not be verified. Please ensure the photos are clear and all details are visible.');
      case 'verified': return _buildStatusView('Verified', Colors.green, 'Your license has been verified. You can now book cars!');
      default: return Container();
    }
  }

  // --- 1. UPLOAD STATE ---
  Widget _buildUploadState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('License Number', 'Enter your license number'),
        const SizedBox(height: 15),
        _buildTextField('Expiry Date', 'Enter your expiry date'),
        const SizedBox(height: 25),
        _buildUploadBox('License Front Side'),
        const SizedBox(height: 15),
        _buildUploadBox('License Back Side'),
        const SizedBox(height: 25),
        _buildImportantNote(),
      ],
    );
  }

  // --- 2. STATUS VIEW (Pending/Rejected/Verified) ---
  Widget _buildStatusView(String status, Color color, String message) {
    return Column(
      children: [
        // Blue Header Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Manage Driving License', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => licenseStatus = 'upload'), icon: const Icon(Icons.edit, color: Colors.white, size: 18)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Status Description Card
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Verification Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  _statusBadge(status, color),
                ],
              ),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Details Card
        _buildCard(
          title: 'License Details',
          child: const Column(
            children: [
              _detailRow('License Number', 'DL123456789'),
              _detailRow('Expiry Date', '2026-12-31'),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // Switch for demo purposes
        if (status == 'Pending') _buildGradientButton('Simulate Rejection', () => setState(() => licenseStatus = 'rejected')),
        if (status == 'Rejected') _buildGradientButton('Simulate Success', () => setState(() => licenseStatus = 'verified')),
      ],
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)))),
      ],
    );
  }

  Widget _buildUploadBox(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_outlined, color: Colors.grey),
              Text('Upload $label', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Text('PNG, JPG up to 10MB', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text('Ensure all details are clearly visible. Licenses must be valid for the rental period.', style: TextStyle(fontSize: 12, color: Colors.blue))),
        ],
      ),
    );
  }

  Widget _buildCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const Divider(height: 24)],
          child,
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onPress) {
    return Container(
      width: double.infinity, height: 50,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]), borderRadius: BorderRadius.circular(25)),
      child: ElevatedButton(onPressed: onPress, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent), 
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }
}

class _detailRow extends StatelessWidget {
  final String label, value;
  const _detailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}