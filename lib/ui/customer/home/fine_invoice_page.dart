import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/agent/model/rental_request_model.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/model/fine_model.dart';
import 'package:francesco_farag/ui/customer/payment_fine.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FineInvoicePage extends StatefulWidget {
  const FineInvoicePage({super.key});

  @override
  State<FineInvoicePage> createState() => _FineInvoicePageState();
}

class _FineInvoicePageState extends State<FineInvoicePage> {
  @override
  void initState() {
    super.initState();
    // Call the API when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchFinesAndInvoices();
    });
  }

  // Add these imports at the top

  // Inside _FineInvoicePageState class:

  Future<void> _pickAndPay(Fine fine, CustomerProvider provider) async {
    final ImagePicker picker = ImagePicker();

    // 1. Pick the image (License Front)
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Optional: compress to speed up upload
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // 2. Call the payFine API from your provider
      final String? checkoutUrl = await provider.payFine(
        fineId: fine.id!,
        imageFile: imageFile,
      );

      // 3. If we got a URL, launch it in the external browser
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentFine(url: checkoutUrl)),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment initialization failed")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Fines & Invoices",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: provider.isCarLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(provider.fineData),
                  const SizedBox(height: 20),
                  if (provider.fineData?.fines?.isEmpty ?? true)
                    const Center(child: Text("No active fines found"))
                  else
                    ...provider.fineData!.fines!.map(
                      (fine) => _buildFineItem(fine, provider),
                    ),
                  const SizedBox(height: 20),
                  // _buildPaymentMethods(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(FineInvoiceModel? data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF3F51B5)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Outstanding",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            data?.totalOutstanding ?? "\$0.00",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.white24, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusCol("Pending", data?.pendingCount?.toString() ?? "0"),
              _statusCol("Paid", data?.paidCount?.toString() ?? "0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- Updated Fine Item Card ---
  Widget _buildFineItem(Fine fine, CustomerProvider provider) {
    bool isPending = fine.status?.toLowerCase() == 'pending';

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fine.formattedType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _buildStatusBadge(fine.status ?? 'pending'),
            ],
          ),
          const SizedBox(height: 12),

          _fineRow(
            Icons.directions_car_outlined,
            "Vehicle",
            fine.vehicleName ?? "N/A",
          ),
          _fineRow(Icons.calendar_month, "Due Date", fine.dueDate!),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48, // Matches reference height
                  child: OutlinedButton.icon(
                    // Only enable if URL exists
                    onPressed: fine.invoiceUrl != null
                        ? () {
                            /* Launch fine.invoiceUrl */
                          }
                        : null,
                    icon: Icon(
                      Icons.download_rounded,
                      size: 18,
                      color: Colors.blueGrey.shade700,
                    ),
                    label: Text(
                      "Invoice",
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          Colors.grey.shade100, // Very light grey back
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 2. Pay Now Button (Blue style, only for pending)
              if (isPending)
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        _pickAndPay(fine, provider);
                      },
                      icon: const Icon(
                        Icons.credit_card_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3), // Bright Blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper: Card Container ---
  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // --- Helper: Status Badge ---
  Widget _buildStatusBadge(String status) {
    bool isPaid = status.toLowerCase() == 'paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isPaid ? Colors.green : Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _fineRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
