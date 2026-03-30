import 'package:flutter/material.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/ui/customer/model/rental_model.dart';
import 'package:francesco_farag/ui/customer/payment_fine.dart';
import 'package:provider/provider.dart';

class BookingStatusPage extends StatefulWidget {
  final RentalRequest request;

  const BookingStatusPage({super.key, required this.request});

  @override
  State<BookingStatusPage> createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  bool _hasAgreedToTerms = false; // Manages the agreement checkbox

  @override
  Widget build(BuildContext context) {
    final quote = widget.request.quotation;
    final car = widget.request.carDetails;
    final bookingId = widget.request.id!;
    final status = widget.request.status.toLowerCase();
    print(status);

    bool isApproved = status == 'approved';
    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Booking Status",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusBanner(status),
            const SizedBox(height: 16),

            _buildCarSummaryCard(car, widget.request.totalDays),
            const SizedBox(height: 16),

            // --- Approved View: Show strictly the essential details ---
            _buildRentalDetailsCard(car, widget.request),
            const SizedBox(height: 16),

            if (quote != null) ...[
              _buildPriceBreakdownCard(quote),
              const SizedBox(height: 16),
            ],

            // --- Hide Agreement and Timeline if Approved ---
            if (!isApproved) ...[
              if (status == 'quotation_sent') ...[
                _buildRentalAgreementCard(car, widget.request),
                const SizedBox(height: 16),
              ],
              _buildTimelineCard(widget.request),
            ],

            // --- Action Buttons (Only for Pending/Quotation states) ---
            if (status == 'awaiting_payment')
              _buildPaymentAction(
                bookingId: bookingId,
                provider: provider,
                context: context,
              ),

            if (status == 'quotation_sent')
              _buildSignAgreementAction(provider, context),

            // If approved, maybe add a "Download Voucher" or "Contact Support" button here
            if (isApproved) _buildApprovedFooter(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- New: Rental Agreement UI ---
  Widget _buildRentalAgreementCard(CarDetails car, RentalRequest request) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Car Rental Agreement",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Center(
            child: Text(
              "Contract ID: #${request.id}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const Divider(height: 32),
          _agreementRow("Agency:", car.agencyName),
          _agreementRow("Vehicle:", car.carName),
          _agreementRow("Pickup:", request.pickupDate),
          _agreementRow("Return:", request.returnDate),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount:", style: TextStyle(color: Colors.grey)),
              Text(
                "\$${request.quotation?.totalPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _hasAgreedToTerms,
                  onChanged: (v) => setState(() => _hasAgreedToTerms = v!),
                  activeColor: const Color(0xFF2196F3),
                ),
                const Expanded(
                  child: Text(
                    "I have read and agree to all terms and conditions stated above.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF0D47A1)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- New: Sign Agreement Button Logic ---
  Widget _buildSignAgreementAction(
    CustomerProvider provider,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: (_hasAgreedToTerms && !provider.isCarLoading)
              ? () async {
                  final success = await provider.acceptQuotation(
                    quotationId: widget.request.quotation!.id!,
                  );

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Agreement Signed! Proceeding to payment...",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // IMPORTANT: You should either refresh the previous list
                    // or pop the user back so they see the updated "Awaiting Payment" status.
                    Navigator.pop(context, true);
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Failed to accept quotation. Please try again.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasAgreedToTerms
                ? Colors.green
                : const Color(0xFFE0E0E0),
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: provider.isCarLoading
              ? const CircularProgressIndicator()
              : const Text(
                  "Sign Agreement",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _agreementRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // --- Your Existing UI Methods ---

  Widget _buildStatusBanner(String status) {
    Color bgColor;
    Color accentColor;
    String title;
    String desc;
    IconData icon;

    if (status == 'approved') {
      bgColor = const Color(0xFFE8F5E9);
      accentColor = Colors.green;
      title = "Booking Approved";
      desc =
          "Your rental is confirmed! Please have your ID ready at the pickup location.";
      icon = Icons.check_circle_outline;
    }
    // ... rest of your existing if/else logic (quotation_sent, awaiting_payment, etc.)
    else if (status == 'quotation_sent') {
      bgColor = const Color(0xFFE8F5E9);
      accentColor = Colors.green;
      title = "Quotation Sent";
      desc = "The agency has sent a price proposal. Please review it below.";
      icon = Icons.mark_email_read_outlined;
    } else if (status == 'awaiting_payment') {
      bgColor = const Color(0xFFE3F2FD);
      accentColor = Colors.blue;
      title = "Awaiting Payment";
      desc = "Please complete the payment to confirm your booking.";
      icon = Icons.payment_outlined;
    } else {
      bgColor = const Color(0xFFFFF3E0);
      accentColor = Colors.orange;
      title = "Booking Pending";
      desc = "The agency is currently reviewing your request.";
      icon = Icons.hourglass_empty_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: OutlinedButton.icon(
        onPressed: () {
          /* Add support logic */
        },
        icon: const Icon(Icons.support_agent),
        label: const Text("Contact Agency Support"),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentAction({
    required CustomerProvider provider,
    required int bookingId,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: () async {
            final response = await provider.payBooking(bookingId: bookingId);
            if (response!.isNotEmpty && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PaymentFine(url: response)),
              );
            }
          },
          icon: const Icon(Icons.credit_card, color: Colors.white),
          label: const Text(
            "Pay Booking Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildCarSummaryCard(CarDetails car, int days) {
    return _cardContainer(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              car.imageUrl ??
                  'https://hips.hearstapps.com/hmg-prod/images/ferrari-e-suv-2-copy-680287cac36b2.jpg?crop=1.00xw:0.838xh;0,0.0673xh',
              width: 100,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.carName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$days Days Rental",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalDetailsCard(CarDetails car, RentalRequest request) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rental Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _detailRow(
            Icons.location_on_outlined,
            "Pickup Location",
            car.agencyLocation,
          ),
          const SizedBox(height: 12),
          _detailRow(
            Icons.calendar_today_outlined,
            "Rental Period",
            "${request.pickupDate} → ${request.returnDate}",
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownCard(Quotation quote) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price Breakdown",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _priceLine("Base Price", "\$${quote.basePrice}"),
          _priceLine("Insurance", "\$${quote.insuranceCost}"),
          _priceLine("Extra Services", "\$${quote.extraServicesCost}"),
          const Divider(height: 24),
          _priceLine("Total Amount", "\$${quote.totalPrice}", isBold: true),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Security Deposit: \$${quote.securityDeposit}\nRefundable after return.",
              style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(RentalRequest request) {
    final status = request.status.toLowerCase();
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Request Timeline",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 16),
          _timelineItem("Request Submitted", request.createdAt, true),
          _timelineItem("Agency Review", "Finished", status != 'pending'),
          _timelineItem(
            "Quotation Sent",
            "Active",
            status == 'quotation_sent' || status == 'awaiting_payment',
          ),
          _timelineItem(
            "Payment Pending",
            "Waiting",
            status == 'awaiting_payment',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceLine(String label, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? Colors.black : Colors.grey.shade700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(
    String title,
    String sub,
    bool done, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? Colors.green : Colors.grey.shade300,
              size: 20,
            ),
            if (!isLast)
              Container(width: 2, height: 30, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: done ? Colors.black : Colors.grey,
              ),
            ),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
