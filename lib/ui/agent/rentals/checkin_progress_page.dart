import 'package:flutter/material.dart';



class CheckInProcessScreen extends StatefulWidget {
  const CheckInProcessScreen({super.key});

  @override
  State<CheckInProcessScreen> createState() => _CheckInProcessScreenState();
}

class _CheckInProcessScreenState extends State<CheckInProcessScreen> {
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const Icon(Icons.arrow_back, color: Colors.black87),
        title: const Text('Check-in & Checkout', 
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Static Header
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Check-In Process', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Vehicle Entry', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          
          // Dynamic Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCurrentStep(),
            ),
          ),

          // Bottom Button Logic
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBottomButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 1: return _stepOneVehicleInspection();
      case 2: return _stepTwoConfirmAgreement();
      case 3: return _stepThreeSuccess();
      default: return Container();
    }
  }

  // --- STEP 1: VEHICLE INSPECTION ---
  Widget _stepOneVehicleInspection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Booking Info Card
        _sectionCard(child: const ListTile(
          leading: CircleAvatar(backgroundColor: Colors.blue, child: Text('JS', style: TextStyle(color: Colors.white))),
          title: Text('John Smith', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Tesla Model 3\nToday, 9:00 AM', style: TextStyle(fontSize: 12)),
        )),
        const SizedBox(height: 16),
        const Text('Step 1: Vehicle Inspection', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Inspection Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _photoUploadBox(Icons.add, 'Front'),
            _photoUploadBox(Icons.add, 'Back'),
            _photoUploadBox(Icons.add, 'Left'),
            _photoUploadBox(Icons.add, 'Right'),
            _photoUploadBox(Icons.add, 'Interior'),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network('https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop', fit: BoxFit.cover),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Starting KM', style: TextStyle(color: Colors.grey)), Text('12,344 KM', style: TextStyle(fontWeight: FontWeight.bold))],
        ),
        const LinearProgressIndicator(value: 0.3, backgroundColor: Color(0xFFE3F2FD), color: Colors.blue),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Fuel Level', style: TextStyle(color: Colors.grey)), Text('80%', style: TextStyle(fontWeight: FontWeight.bold))],
        ),
      ],
    );
  }

  // --- STEP 2: CONFIRM AGREEMENT ---
  Widget _stepTwoConfirmAgreement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 2: Confirm Agreement', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'Rental Summary',
          child: Column(
            children: [
              _summaryRow('Rental Period', '3 Days'),
              _summaryRow('Total Rental', '€ 240'),
              _summaryRow('Total Deposit', '€ 500'),
              const Divider(),
              _summaryRow('Security Deposit', 'Refundable', valueColor: Colors.green),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _sectionCard(
          child: Column(
            children: [
              CheckboxListTile(
                value: true, 
                onChanged: (v){}, 
                title: const Text('Confirm Rental Agreement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('I confirm that the car is in inspected condition...', style: TextStyle(fontSize: 11)),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: const Text('Ron Smith', style: TextStyle(fontFamily: 'Cursive', fontSize: 24)),
              ),
              Row(
                children: [
                  const Checkbox(value: true, onChanged: null),
                  const Text('Confirm', style: TextStyle(fontSize: 12)),
                  const Spacer(),
                  ElevatedButton(onPressed: (){}, child: const Text('Sign')),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- STEP 3: SUCCESS ---
  Widget _stepThreeSuccess() {
    return Center(
      child: _sectionCard(
        child: Column(
          children: [
            const CircleAvatar(radius: 30, backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.check, color: Colors.green, size: 40)),
            const SizedBox(height: 16),
            const Text('Check-In Successful', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
            const Text('Rental has been started and is now active.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Rental Status:'),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)), child: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 10)))
            ]),
            const Divider(height: 30),
            _summaryRow('Pickup Date', '9:00 AM', icon: Icons.calendar_today_outlined),
            _summaryRow('Total Rental', '3 Days', icon: Icons.access_time),
            _summaryRow('Paid Security Deposit', '€ 500', icon: Icons.wallet_outlined),
          ],
        ),
      ),
    );
  }

  // Helper UI methods
  Widget _buildBottomButton() {
    String label = currentStep == 1 ? 'Continue to Agreement' : currentStep == 2 ? 'Start Rental' : 'Return to Dashboard';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 15)),
        onPressed: () => setState(() { if(currentStep < 3) currentStep++; else currentStep = 1; }),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _sectionCard({String? title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const Divider()],
          child,
        ],
      ),
    );
  }

  Widget _photoUploadBox(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, color: Colors.blue), Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey))],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [if(icon != null) Icon(icon, size: 16, color: Colors.grey), if(icon != null) const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))]),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}