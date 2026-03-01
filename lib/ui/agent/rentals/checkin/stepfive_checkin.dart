import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart';
import 'package:go_router/go_router.dart';

class StepfiveCheckin extends StatefulWidget {
  const StepfiveCheckin({super.key});

  @override
  State<StepfiveCheckin> createState() => _StepfiveCheckinState();
}

class _StepfiveCheckinState extends State<StepfiveCheckin> {
  String? _selectedPaymentMethod;

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
              'Billing Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Vehicle Entry',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // 1. Progress Stepper (Step 5 Active)
            const StepperWidget(currentStep: 5),
            const SizedBox(height: 24),

            // 2. Info Box: Using Customer Address
            _buildInfoBox(),
            const SizedBox(height: 20),

            // 3. Billing Information Form
            _buildBillingForm(),
            const SizedBox(height: 20),

            // 4. Payment & Deposit Card
            _buildPaymentCard(),
            const SizedBox(height: 24),

            // 5. Navigation
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton(
                    "Previous",
                    () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPrimaryButton("Next Step", () {
                    context.push(AppRoute.checkinSixStep);
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

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF2962FF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Using Customer Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Billing address is the same as customer address. You can skip this step or provide different billing information.',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingForm() {
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
                'Billing information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFieldLabel("Billing Name"),
          _buildTextField("Company or Full Name"),
          _buildFieldLabel("Billing Email"),
          _buildTextField("@example.com"),
          _buildFieldLabel("Billing Phone"),
          _buildTextField("12566666666"),
          _buildFieldLabel("Billing Address"),
          _buildTextField("123 Highland Dr"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("City"),
                    _buildTextField("New York"),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("Country"),
                    _buildTextField("USA"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
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
              Icon(Icons.payment, size: 20),
              SizedBox(width: 8),
              Text(
                'Payment & Deposit',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildAmountRow("Rental Amount", "\$150"),
                const SizedBox(height: 8),
                _buildAmountRow("Deposit Amount", "\$500"),
                const Divider(height: 24),
                _buildAmountRow("Total Amount", "\$650", isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFieldLabel("Payment Method"),
          _buildDropdownField("Select payment method"),
        ],
      ),
    );
  }

  // UI Helpers
  Widget _buildFieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
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

  Widget _buildAmountRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? const Color(0xFF2962FF) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String hint) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: DropdownButton<String>(
      hint: Text(hint, style: const TextStyle(fontSize: 14)),
      isExpanded: true,
      underline: const SizedBox(),
      items: [
        "Credit Card",
        "Cash",
        "Bank Transfer",
      ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (val) => setState(() => _selectedPaymentMethod = val),
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
