import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateQuotationScreen extends StatelessWidget {
  const CreateQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFF06292), Color(0xFFD81B60)]),
          ),
        ),
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Create Quotation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Prepare and send quotation to client', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Customer Info ---
            const SummaryCard(
              icon: Icons.person_outline,
              title: 'Customer Info',
              children: [
                InfoRow(label: 'Name:', value: 'John Smith'),
                InfoRow(label: 'License Status:', value: 'Verified', valueColor: Colors.green),
                InfoRow(label: 'Booking ID:', value: 'book2'),
              ],
            ),

            // --- Rental Details ---
            const SummaryCard(
              icon: Icons.directions_car_outlined,
              title: 'Rental Details',
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.directions_car, color: Colors.blue),
                  title: Text('BMW 5 Series', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Selected Vehicle'),
                ),
                Row(
                  children: [
                    Expanded(child: DateBox(label: 'Pickup Date', date: '2026-02-20')),
                    SizedBox(width: 10),
                    Expanded(child: DateBox(label: 'Return Date', date: '2026-02-25')),
                  ],
                ),
                SizedBox(height: 10),
                InfoRow(label: 'Duration:', value: '5 days', valueColor: Colors.blue),
              ],
            ),

            // --- Extra Services ---
            SummaryCard(
              icon: Icons.category_outlined,
              title: 'Extra Services',
              children: [
                ServiceTile(label: 'GPS Navigation', price: '€5/day', isSelected: true),
                ServiceTile(label: 'Child Seat', price: '€8/day'),
                ServiceTile(label: 'Additional Driver', price: '€10/day'),
              ],
            ),

            // --- Pricing Breakdown ---
            SummaryCard(
              icon: Icons.receipt_long_outlined,
              title: 'Pricing Breakdown',
              children: [
                const PriceInputRow(label: 'Base Price', subLabel: '5 days x €120.00/day', value: '600'),
                const PriceInputRow(label: 'Insurance Cost', value: '50'),
                const InfoRow(label: 'Extra Services', value: '\$0.00'),
                const InfoRow(label: 'Subtotal', value: '\$650.00', isBold: true),
                const Divider(),
                const InfoRow(label: 'VAT 22%', value: '\$143.00'),
                const PriceInputRow(label: 'Discount', value: '0'),
                const PriceInputRow(label: 'Security Deposit', value: '300', valueColor: Colors.orange),
                const SizedBox(height: 10),
                // Total Price Highlight
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Price', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text('\$793.00', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),

            // --- Footer Buttons ---
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined),
              label: const Text('Generate PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF64B5F6), Color(0xFF3949AB)]),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined, color: Colors.white),
                label: const Text('Send to Client', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Sub-Widgets ---

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SummaryCard({super.key, required this.icon, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const InfoRow({super.key, required this.label, required this.value, this.valueColor, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? Colors.black87,
            fontSize: 14,
          )),
        ],
      ),
    );
  }
}

class PriceInputRow extends StatelessWidget {
  final String label;
  final String? subLabel;
  final String value;
  final Color? valueColor;

  const PriceInputRow({super.key, required this.label, this.subLabel, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (subLabel != null) Text(subLabel!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          Container(
            width: 80,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerRight,
            child: Text(value, style: TextStyle(color: valueColor ?? Colors.black87, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String label;
  final String price;
  final bool isSelected;

  const ServiceTile({super.key, required this.label, required this.price, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (val) {},
        title: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        secondary: Text(price, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final String label;
  final String date;

  const DateBox({super.key, required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.blue, fontSize: 10)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}