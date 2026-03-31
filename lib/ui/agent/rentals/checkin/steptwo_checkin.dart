import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:provider/provider.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/agent/rentals/checkin/stepone_checkin.dart'; // For StepperWidget
import 'package:go_router/go_router.dart';

class SteptwoCheckin extends StatefulWidget {
  const SteptwoCheckin({super.key});

  @override
  State<SteptwoCheckin> createState() => _SteptwoCheckinState();
}

class _SteptwoCheckinState extends State<SteptwoCheckin> {
  // 1. Define Controllers to manage text lifecycle
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _nationalityController;
  late TextEditingController _addressController;
  late TextEditingController _licenseController;
  late TextEditingController _licenseExpiryController;
  late TextEditingController _idController;
  late TextEditingController _idExpiryController;

  @override
  void initState() {
    super.initState();
    // 2. Initialize controllers with current values from Provider
    final data = context.read<AgentProvider>().customerData;

    _nameController = TextEditingController(text: data['fullName']);
    _dobController = TextEditingController(text: data['dob']);
    _nationalityController = TextEditingController(text: data['nationality']);
    _addressController = TextEditingController(text: data['address']);
    _licenseController = TextEditingController(text: data['licenseNumber']);
    _licenseExpiryController = TextEditingController(
      text: data['licenseExpiry'],
    );
    _idController = TextEditingController(text: data['idNumber']);
    _idExpiryController = TextEditingController(text: data['idExpiry']);
  }

  @override
  void dispose() {
    // 3. Clean up controllers
    _nameController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _licenseExpiryController.dispose();
    _idController.dispose();
    _idExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
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
            const SizedBox(height: 10),
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Vehicle Entry',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            const StepperWidget(currentStep: 2),

            const SizedBox(height: 24),

            // Billing Address Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Billing address same as customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Use customer address for billing',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: data['billingSameAsCustomer'],
                    activeColor: const Color(0xFF2962FF),
                    onChanged: (val) {
                      provider.updateCustomerField(
                        'billingSameAsCustomer',
                        val,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Input Fields synced with Provider
            _buildInputField("Full Name", "Enter full name", _nameController, (
              val,
            ) {
              provider.updateCustomerField('fullName', val);
            }),
            _buildInputField("Date of Birth", "mm/dd/yyyy", _dobController, (
              val,
            ) {
              provider.updateCustomerField('dob', val);
            }),
            _buildInputField(
              "Nationality",
              "Enter nationality",
              _nationalityController,
              (val) {
                provider.updateCustomerField('nationality', val);
              },
            ),
            _buildInputField("Address", "Enter address", _addressController, (
              val,
            ) {
              provider.updateCustomerField('address', val);
            }),
            _buildInputField(
              "Driving Licenses Number",
              "Enter licenses number",
              _licenseController,
              (val) {
                provider.updateCustomerField('licenseNumber', val);
              },
            ),
            _buildInputField(
              "Licenses Expiry Date",
              "Enter date",
              _licenseExpiryController,
              (val) {
                provider.updateCustomerField('licenseExpiry', val);
              },
            ),
            _buildInputField(
              "ID/Passport Number",
              "Enter number",
              _idController,
              (val) {
                provider.updateCustomerField('idNumber', val);
              },
            ),
            _buildInputField(
              "ID Expiry Date",
              "Enter date",
              _idExpiryController,
              (val) {
                provider.updateCustomerField('idExpiry', val);
              },
            ),

            const SizedBox(height: 24),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoute.checkingThreeStep),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Next Step',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: onChanged, // Save to provider on every change
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF2962FF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
