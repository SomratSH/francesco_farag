import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:francesco_farag/ui/agent/agent_provider.dart';
import 'package:francesco_farag/utils/app_colors.dart';

class CreateQuotationScreen extends StatefulWidget {
  const CreateQuotationScreen({super.key});

  @override
  State<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final Set<int> _selectedServiceIds = {};

  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgentProvider>();
    final data = provider.bookingDetails;

    // Loading State
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Sync selected services from data once
    if (_selectedServiceIds.isEmpty && data.selectedExtraServices != null) {
      _selectedServiceIds.addAll(data.selectedExtraServices!.map((e) => e.id!));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppColors().gradientPink),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Create Quotation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Prepare and send quotation to client',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Customer Info ---
            SummaryCard(
              icon: Icons.person_outline,
              title: 'Customer Info',
              children: [
                InfoRow(
                  label: 'Name:',
                  value: data.customerInfo?.name ?? "N/A",
                ),
                InfoRow(
                  label: 'License Status:',
                  value: (data.customerInfo?.licenseStatus ?? "pending")
                      .toUpperCase(),
                  valueColor: data.customerInfo?.licenseStatus == 'verified'
                      ? Colors.green
                      : Colors.orange,
                ),
                InfoRow(label: 'Booking ID:', value: '#${data.bookingId}'),
              ],
            ),

            // --- Rental Details ---
            SummaryCard(
              icon: Icons.directions_car_outlined,
              title: 'Rental Details',
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.directions_car, color: Colors.blue),
                  title: Text(
                    data.carName ?? "N/A",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Selected Vehicle'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: DateBox(
                        label: 'Pickup Date',
                        date: formatDate(data.pickupDate),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DateBox(
                        label: 'Return Date',
                        date: formatDate(data.returnDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InfoRow(
                  label: 'Duration:',
                  value: '${data.durationDays ?? 0} days',
                  valueColor: Colors.blue,
                ),
              ],
            ),

            // --- Extra Services ---
            SummaryCard(
              icon: Icons.category_outlined,
              title: 'Extra Services',
              children: (data.availableExtraServices ?? []).map((service) {
                return ServiceTile(
                  label: service.name ?? "",
                  price: '€${service.pricePerDay}/day',
                  isSelected: _selectedServiceIds.contains(service.id),
                  onChanged: (val) {
                    setState(() {
                      if (val == true)
                        _selectedServiceIds.add(service.id!);
                      else
                        _selectedServiceIds.remove(service.id!);
                    });
                  },
                );
              }).toList(),
            ),

            // --- Pricing Breakdown (Direct from API Data) ---
            SummaryCard(
              icon: Icons.receipt_long_outlined,
              title: 'Pricing Breakdown',
              children: [
                PriceInputRow(
                  label: 'Base Price',
                  subLabel: 'Rental cost for ${data.durationDays} days',
                  value:
                      '€${data.pricingBreakdown?.basePrice?.toStringAsFixed(2)}',
                ),
                InfoRow(
                  label: 'Insurance Cost',
                  value:
                      '€${data.pricingBreakdown?.insuranceCost?.toStringAsFixed(2)}',
                ),
                InfoRow(
                  label: 'Extra Services',
                  value:
                      '€${data.pricingBreakdown?.extraServicesCost?.toStringAsFixed(2)}',
                ),
                const Divider(),
                InfoRow(
                  label: 'Subtotal',
                  value:
                      '€${data.pricingBreakdown?.subtotal?.toStringAsFixed(2)}',
                  isBold: true,
                ),
                InfoRow(
                  label: 'VAT (${data.pricingBreakdown?.vatPercentage}%)',
                  value:
                      '€${data.pricingBreakdown?.vatAmount?.toStringAsFixed(2)}',
                ),
                InfoRow(
                  label: 'Discount',
                  value:
                      '-€${data.pricingBreakdown?.discount?.toStringAsFixed(2)}',
                  valueColor: Colors.red,
                ),
                PriceInputRow(
                  label: 'Security Deposit',
                  value:
                      '€${data.pricingBreakdown?.securityDeposit?.toStringAsFixed(2)}',
                  valueColor: Colors.orange,
                ),
                const SizedBox(height: 16),
                // Total Price Highlight
                Container(
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
                        'Total Price',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '€${data.pricingBreakdown?.totalPrice?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // --- Actions ---
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined),
              label: const Text('Generate PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined, color: Colors.white),
                label: const Text(
                  'Send to Client',
                  style: TextStyle(color: Colors.white),
                ),
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

// --- Reusable Sub-Widgets (unchanged logic) ---

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
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
  const PriceInputRow({
    super.key,
    required this.label,
    this.subLabel,
    required this.value,
    this.valueColor,
  });

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
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
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
  final ValueChanged<bool?> onChanged;
  const ServiceTile({
    super.key,
    required this.label,
    required this.price,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isSelected,
      onChanged: onChanged,
      title: Text(label, style: const TextStyle(fontSize: 13)),
      secondary: Text(
        price,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
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
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.blue, fontSize: 10)),
          Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
