import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:francesco_farag/providers/agent_provider.dart'; // Ensure correct path

class CheckoutProgessPage extends StatefulWidget {
  const CheckoutProgessPage({super.key});

  @override
  State<CheckoutProgessPage> createState() => _CheckoutProgessPageState();
}

class _CheckoutProgessPageState extends State<CheckoutProgessPage> {
  int currentStep = 1;
  double _fuelValue = 1.0; // 1.0 = Full, 0.5 = Half, 0.0 = Empty

  String _getFuelLabel(double value) {
    if (value >= 0.8) return "full";
    if (value >= 0.4) return "half";
    return "empty";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AgentProvider>(context);

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
              child: _buildStepContent(provider),
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
        const SizedBox(width: 10),
        _stepIndicator(2, 'Charges'),
        const SizedBox(width: 10),
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

  Widget _buildStepContent(AgentProvider provider) {
    switch (currentStep) {
      case 1:
        return _stepFinalInspection(provider);
      case 2:
        return _stepExtraCharges(provider);
      case 3:
        return _stepFinalInvoice(provider);
      default:
        return Container();
    }
  }

  // --- STEP 1: FINAL INSPECTION ---
  Widget _stepFinalInspection(AgentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          title: 'Step 1: Final Inspection',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                physics: const NeverScrollableScrollPhysics(),
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
              _customInput(
                'Ending Kilometer Reading',
                'Enter ending KM',
                onChanged: (v) => provider.updateCheckoutField(
                  'checkout_ending_km',
                  int.tryParse(v) ?? 0,
                ),
                isNumber: true,
              ),
              const SizedBox(height: 20),
              Text(
                'Fuel Level: ${(_fuelValue * 100).toInt()}% (${_getFuelLabel(_fuelValue)})',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Slider(
                value: _fuelValue,
                onChanged: (v) {
                  setState(() => _fuelValue = v);
                  provider.updateCheckoutField(
                    'checkout_fuel_level',
                    _getFuelLabel(v),
                  );
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey.shade200,
              ),
              _customInput(
                'Damage Notes (if any)',
                'No new damage',
                maxLines: 3,
                onChanged: (v) =>
                    provider.updateCheckoutField('checkout_damage_notes', v),
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
  Widget _stepExtraCharges(AgentProvider provider) {
    return _sectionCard(
      title: 'Step 2: Extra Charges',
      child: Column(
        children: [
          _priceInputField(
            'Damage Charge',
            '75',
            (v) => provider.updateCheckoutField(
              'checkout_damage_charge',
              double.tryParse(v) ?? 0,
            ),
          ),
          _priceInputField(
            'Late Return Charge',
            '0',
            (v) => provider.updateCheckoutField(
              'checkout_late_return_charge',
              double.tryParse(v) ?? 0,
            ),
          ),
          _priceInputField(
            'Extra KM Charge',
            '400',
            (v) => provider.updateCheckoutField(
              'checkout_extra_km_charge',
              double.tryParse(v) ?? 0,
            ),
          ),
          _priceInputField(
            'Fuel Charge',
            '40',
            (v) => provider.updateCheckoutField(
              'checkout_fuel_charge',
              double.tryParse(v) ?? 0,
            ),
          ),
          _priceInputField(
            'Cleaning Fee',
            '75',
            (v) => provider.updateCheckoutField(
              'checkout_cleaning_fee',
              double.tryParse(v) ?? 0,
            ),
          ),
          _customInput(
            'Description (Notes)',
            'Cleaning fee applied',
            onChanged: (v) =>
                provider.updateCheckoutField('checkout_extra_charge_notes', v),
          ),
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
  Widget _stepFinalInvoice(AgentProvider provider) {
    final data = provider.checkoutData;

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
          _invoiceRow('Damage Charge', '€${data['checkout_damage_charge']}'),
          _invoiceRow('Cleaning Fee', '€${data['checkout_cleaning_fee']}'),
          const Divider(),
          _invoiceRow(
            'Total Amount:',
            '€285.00', // You can calculate this dynamically
            isBold: true,
            color: Colors.blue,
          ),
          const SizedBox(height: 30),
          _fullWidthButton('Generate Final Invoice', isOutlined: true),
          const SizedBox(height: 10),
          _gradientButton2('Send to Client & Finalize', () async {
            // Show Loader
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );

            bool success = await provider.submitCheckout(413);

            if (mounted) {
              Navigator.pop(context); // Remove Loader
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Checkout Successful!"),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to update checkout."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
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
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 20),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _customInput(
    String label,
    String hint, {
    int maxLines = 1,
    Function(String)? onChanged,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          TextField(
            maxLines: maxLines,
            onChanged: onChanged,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEEEEEE)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceInputField(
    String label,
    String hint,
    Function(String)? onChanged,
  ) {
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
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '€ ',
              hintText: hint,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEEEEEE)),
              ),
            ),
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
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffFF67c2).withOpacity(0.1),
          border: Border.all(color: const Color(0xffD3037F)),
          borderRadius: BorderRadius.circular(25),
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
    return InkWell(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppColors().gradientBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
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
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
      ),
    );
  }
}
