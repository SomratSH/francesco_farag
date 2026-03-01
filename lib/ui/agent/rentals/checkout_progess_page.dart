import 'package:flutter/material.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class CheckoutProgessPage extends StatefulWidget {
  const CheckoutProgessPage({super.key});

  @override
  State<CheckoutProgessPage> createState() => _CheckoutProgessPageState();
}

class _CheckoutProgessPageState extends State<CheckoutProgessPage> {
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // --- Stepper Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check-Out Flow',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'John Smith - Tesla Model 3',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),
                _buildStepper(),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _stepIndicator(1, 'Inspection'),
        SizedBox(width: 10),
        // _stepConnector(currentStep > 1),
        _stepIndicator(2, 'Charges'),
        SizedBox(width: 10),
        // _stepConnector(currentStep > 2),
        _stepIndicator(3, 'Invoice'),
      ],
    );
  }

  Widget _stepIndicator(int step, String label) {
    bool isActive = currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00C853) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 1:
        return _stepFinalInspection();
      case 2:
        return _stepExtraCharges();
      case 3:
        return _stepFinalInvoice();
      default:
        return Container();
    }
  }

  // --- STEP 1: FINAL INSPECTION ---
  Widget _stepFinalInspection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          title: 'Step 1: Final Inspection',
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Check-In Data:',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Starting KM: 15420    Fuel: 100%',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Upload Return Photos:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _uploadPlaceholder('Front'),
                  _uploadPlaceholder('Back'),
                  _uploadPlaceholder('Left'),
                  _uploadPlaceholder('Right'),
                ],
              ),
              const SizedBox(height: 10),
              _fullWidthButton('Upload Interior Photo', isOutlined: true),
              const SizedBox(height: 20),
              _customInput('Ending Kilometer Reading', 'Enter ending KM'),
              const SizedBox(height: 20),
              const Text(
                'Fuel Level: 100%',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Slider(
                value: 1.0,
                onChanged: (v) {},
                activeColor: Colors.blue,
                inactiveColor: Colors.grey.shade200,
              ),
              _customInput(
                'Damage Notes (if any)',
                'Describe any new damage...',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _gradientButton(
                'Continue to Extra Charges',
                () => setState(() => currentStep = 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- STEP 2: EXTRA CHARGES ---
  Widget _stepExtraCharges() {
    return _sectionCard(
      title: 'Step 2: Extra Charges',
      child: Column(
        children: [
          _priceInputField('Damage Charge', '375'),
          _priceInputField('Late Return Charge', '375'),
          _priceInputField('Extra KM Charge', '375'),
          _priceInputField('Fuel Charge', '375'),
          _customInput('Description (e.g., Cleaning fee)', '75'),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _fullWidthButton(
                  'Back',
                  isOutlined: true,
                  onPress: () => setState(() => currentStep = 1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _gradientButton2(
                  'Continue to Invoice',
                  () => setState(() => currentStep = 3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- STEP 3: FINAL INVOICE ---
  Widget _stepFinalInvoice() {
    return _sectionCard(
      title: 'Step 3: Final Invoice',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Invoice Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _invoiceRow('Base Rental', '€287.00'),
          _invoiceRow('Damage Charge', '€-2.00'),
          _invoiceRow('Late Return', '€-2.00'),
          _invoiceRow('Extra KM', '€-4.00'),
          _invoiceRow('Fuel Charge', '€-4.00'),
          const Divider(),
          _invoiceRow(
            'Total Amount:',
            '€285.00',
            isBold: true,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            'Rental Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _invoiceRow('Duration:', '3 days'),
          _invoiceRow('KM Used:', '-15428 km'),
          _invoiceRow('Start KM:', '15420'),
          _invoiceRow('End KM:', '-8'),
          const SizedBox(height: 30),
          _fullWidthButton('Generate Final Invoice', isOutlined: true),
          const SizedBox(height: 10),
          _gradientButton2('Send to Client', () {}),
        ],
      ),
    );
  }

  // --- Helper UI Components ---

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 30),
          child,
        ],
      ),
    );
  }

  Widget _uploadPlaceholder(String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_outlined, color: Colors.grey),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _customInput(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _priceInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          TextField(
            decoration: InputDecoration(prefixText: '\$ ', hintText: value),
          ),
        ],
      ),
    );
  }

  Widget _invoiceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onPress) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xffFF67c2).withOpacity(0.15),
        border: Border.all(color: Color(0xffD3037F)),
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
            color: Color(0xffD3037F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _gradientButton2(String label, VoidCallback onPress) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: AppColors().gradientBlue,

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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _fullWidthButton(
    String label, {
    bool isOutlined = false,
    VoidCallback? onPress,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPress ?? () {},
        style: OutlinedButton.styleFrom(
          side: isOutlined ? const BorderSide(color: Color(0xff6891F4)) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
