import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/model/rental_model.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Import your model path here
// import 'package:francesco_farag/ui/customer/model/rental_model.dart';

class RentalAssignmentScreen extends StatefulWidget {
  final dynamic rental; // Use RentalRequest rental if imported

  const RentalAssignmentScreen({super.key, required this.rental});

  @override
  State<RentalAssignmentScreen> createState() => _RentalAssignmentScreenState();
}

class _RentalAssignmentScreenState extends State<RentalAssignmentScreen> {
  bool _termsAccepted = false;
  bool _isSigned = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.rental;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text('Rental Assignment',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- 1. Rental Agreement Summary Card ---
            _buildAgreementSummary(r),
            const SizedBox(height: 20),

            // --- 2. Terms & Conditions Detail Section ---
            _buildDetailedTerms(r),
            const SizedBox(height: 120), // Space for sticky bottom actions
          ],
        ),
      ),
      bottomSheet: _buildBottomActions(),
    );
  }

  Widget _buildAgreementSummary(RentalRequest r) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text('Car Rental Agreement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text('Contract ID: #${r.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const Divider(height: 30),
          _infoRow('Agency:', r.carDetails.agencyName ?? 'N/A'),
          _infoRow('Vehicle:', r.carDetails.carName),
          _infoRow('Renter Email:', r.customerEmail ?? 'N/A'),
          _infoRow('Pickup:', '${r.pickupDate.split('T').first} at\n${r.carDetails.agencyLocation ?? "Agency Location"}'),
          _infoRow('Return:', r.returnDate.split('T').first),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount:', style: TextStyle(color: Colors.grey)),
              Text('\$${r.quotation?.totalPrice ?? r.carDetails.pricePerDay}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 20),

          // Terms Checkbox
          if (!_isSigned)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF0F7FF), borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      value: _termsAccepted,
                      onChanged: (v) => setState(() => _termsAccepted = v!),
                      activeColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'I have read and agree to all terms and conditions stated above. I understand that I am responsible for the vehicle during the rental period.',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

          if (_isSigned) _buildSignedBadge(),
        ],
      ),
    );
  }

  Widget _buildSignedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text('Agreement Signed', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          Text('Signed by Customer. Your rental is confirmed. You can collect the car on the pickup date.',
              style: TextStyle(fontSize: 11, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildDetailedTerms(dynamic r) {
    final pickup = r.pickupDate.split('T').first;
    final returnD = r.returnDate.split('T').first;
    final total = r.quotation?.totalPrice ?? r.carDetails.pricePerDay;
    final deposit = r.quotation?.securityDeposit ?? "500.00";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rental Agreement Terms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        _termParagraph('1. Rental Period', 
          'The rental period begins on $pickup and ends on $returnD. The vehicle must be returned by the agreed time. Late returns may incur additional charges.'),
        _termParagraph('2. Payment Terms', 
          'The total rental fee is \$$total, which includes the base rental charge and any additional services. A security deposit of \$$deposit will be held and refunded after the vehicle is returned in good condition.'),
        _termParagraph('3. Driver Requirements', 
          'The driver must possess a valid driving license and be at least 21 years old. The license must be presented at pickup.'),
        _termParagraph('4. Insurance Coverage', 
          'The rental includes insurance coverage as specified in the quotation. However, the renter is responsible for any damages caused by negligence or violation of traffic laws.'),
        _termParagraph('5. Vehicle Condition', 
          'The renter agrees to return the vehicle in the same condition as received, with the same fuel level.'),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _termParagraph(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isSigned)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _termsAccepted ? () => setState(() => _isSigned = true) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _termsAccepted ? Colors.blue : Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Agreement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          if (_isSigned)
            OutlinedButton.icon(
              onPressed: () {
                // Handle PDF Download
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Rental Agreement PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }
}