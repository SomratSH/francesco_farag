import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/ui/authentication/customer_login.dart';
import 'package:francesco_farag/ui/customer/customer_provider.dart';
import 'package:francesco_farag/utils/custom_loading_dialog.dart';
import 'package:francesco_farag/utils/custom_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerRequestQuatation extends StatefulWidget {
  const CustomerRequestQuatation({super.key});

  @override
  State<CustomerRequestQuatation> createState() =>
      _CustomerRequestQuatationState();
}

class _CustomerRequestQuatationState extends State<CustomerRequestQuatation> {
  bool showSummary = false;
  // final Map<String, bool> _extraServices = {
  //   'Extra Insurance': false,
  //   'GPS Navigation': false,
  //   'Child Seat': false,
  //   'Additional Driver': false,
  // };

  // final Map<String, int> _prices = {
  //   'Extra Insurance': 15,
  //   'GPS Navigation': 10,
  //   'Child Seat': 8,
  //   'Additional Driver': 20,
  // };

  // Controllers
  final TextEditingController _pickupLoc = TextEditingController();
  final TextEditingController _dropoffLoc = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  // Date State
  DateTime? _pickupDateTime;
  DateTime? _dropoffDateTime;

  List<int> idList = [];

  List<double> extra = [];
  String getExtraTotal() {
    if (extra.isNotEmpty) {
      double totalExtra = extra.fold(
        0,
        (previous, current) => previous + current,
      );
      return totalExtra.toString();
    } else {
      return "0.0";
    }
  }

  double getTotalValue(double baseFase) {
    // Using .fold to sum up all elements in the 'extra' list
    double totalExtra = extra.fold(
      0,
      (previous, current) => previous + current,
    );

    return baseFase + totalExtra;
  }

  // --- SERVICE ID STORAGE ---
  final Map<int, bool> _serviceSelectionMap = {};

  @override
  void dispose() {
    _pickupLoc.dispose();
    _dropoffLoc.dispose();
    _notes.dispose();
    super.dispose();
  }

  // Formatting to: 2026-03-15T10:00:00Z
  String _formatToApi(DateTime? dt) {
    if (dt == null) return "";
    return "${dt.toIso8601String().split('.')[0]}Z";
  }

  Future<void> _selectDateTime(BuildContext context, bool isPickup) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (d != null && mounted) {
      final TimeOfDay? t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (t != null) {
        setState(() {
          final dt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
          isPickup ? _pickupDateTime = dt : _dropoffDateTime = dt;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: InkWell(
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back, color: Colors.black87),
          ),
          onPressed: () => setState(() => showSummary = false),
        ),
        title: const Text(
          'Request Quotation',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- 1. Car Preview Card ---
            _buildCarPreview(provider),
            const SizedBox(height: 16),

            // --- 2. Location Selection ---
            _buildSectionCard(
              child: Column(
                children: [
                  _buildLocationField(
                    'Pickup Location',
                    'Enter pickup location',
                    _pickupLoc,
                    () {},
                    readOnly: false,
                  ),
                  const SizedBox(height: 12),
                  _buildLocationField(
                    'Drop-off Location',
                    'Enter drop-off location',
                    _dropoffLoc,
                    () {},
                    readOnly: false,
                  ),

                  const SizedBox(height: 12),
                  _buildLocationField(
                    'Pickup Date',
                    'Enter pickup Date',
                    TextEditingController(
                      text: _pickupDateTime == null
                          ? ""
                          : _pickupDateTime
                                .toString()
                                .split("T")
                                .first
                                .toString(),
                    ),
                    () async {
                      await _selectDateTime(context, true);
                    },
                    isDate: true,
                  ),
                  const SizedBox(height: 12),
                  _buildLocationField(
                    'Drop-off Date',
                    'Enter drop-off Date',
                    TextEditingController(
                      text: _dropoffDateTime == null
                          ? ""
                          : _dropoffDateTime
                                .toString()
                                .split("T")
                                .first
                                .toString(),
                    ),
                    () {
                      _selectDateTime(context, false);
                    },

                    isDate: true,
                  ),
                  if (showSummary) ...[
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Duration: 00 days',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 3. Extra Services ---
            _buildSectionCard(
              title: 'Extra Services (optional)',
              child: Column(
                children: List.generate(
                  provider.carDetails!.availableServices!.length,
                  (index) => _buildServiceCheckbox(
                    provider.carDetails!.availableServices![index].name!,
                    provider.carDetails!.availableServices![index].pricePerDay
                        .toString(),
                    provider.carDetails!.availableServices![index].id!.toInt(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. Additional Notes ---
            _buildSectionCard(
              title: 'Additional Notes (optional)',
              child: TextField(
                controller: _notes,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any special requests or requirements...',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 5. Estimated Cost (Only in Summary State) ---
            if (idList.isNotEmpty) _buildEstimatedCost(provider),

            const SizedBox(height: 24),

            // --- 6. Action Button ---
            _buildActionButton(provider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCarPreview(CustomerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ), // Matches the subtle depth in
            blurRadius: 12, // Smooth spread for a modern look
            offset: const Offset(0, 4), // Slight downward push
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              provider.carDetails!.featuredImageUrl ??
                  'https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=2071&auto=format&fit=crop',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      provider.carDetails!.carName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.carDetails!.category!,
                      style: TextStyle(
                        color: Colors.pink.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 14),
                  Text(
                    provider.carDetails!.averageRating!.toString(),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${provider.carDetails!.seats} seats • ${provider.carDetails!.transmission}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${provider.carDetails!.pricePerDay}',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '/day',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({String? title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ), // Matches the subtle depth in
            blurRadius: 12, // Smooth spread for a modern look
            offset: const Offset(0, 4), // Slight downward push
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildLocationField(
    String label,
    String hint,
    TextEditingController controller,
    Function()? ontap, {
    bool readOnly = true,
    bool isDate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Material(
          // Added Material to ensure the InkWell splash effect shows up
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: readOnly ? ontap : null, // Pass the function directly
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IgnorePointer(
                // <--- THIS IS THE KEY
                ignoring:
                    readOnly, // When read-only, it lets the tap go to the InkWell
                child: TextField(
                  readOnly: readOnly,
                  controller: controller,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    icon: Icon(
                      isDate
                          ? Icons.calendar_month
                          : Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCheckbox(String label, String price, int id) {
    // 1. Check if this specific ID is currently selected
    bool isSelected = idList.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // 2. Change color based on selection, not label content
        color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        controlAffinity:
            ListTileControlAffinity.leading, // Moves checkbox to the left
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        secondary: Text(
          '\$$price/day',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        value: isSelected,
        activeColor: Colors.blue,
        onChanged: (bool? val) {
          setState(() {
            if (val == true) {
              idList.add(id); // Select
              extra.add(double.parse(price));
            } else {
              idList.remove(id); // Deselect
              extra.add(double.parse(price));
            }
          });
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildEstimatedCost(CustomerProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.04,
            ), // Matches the subtle depth in
            blurRadius: 12, // Smooth spread for a modern look
            offset: const Offset(0, 4), // Slight downward push
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estimated Cost',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _costRow(
            'Base rental (01 days)',
            '\$${provider.carDetails!.pricePerDay!}',
          ),
          _costRow('Extra services', '\$${getExtraTotal()}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${getTotalValue(double.parse(provider.carDetails!.pricePerDay!))}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '*Final price may vary based on agency\'s custom quotation',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
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

  Widget _buildActionButton(CustomerProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: !showSummary
            ? null
            : const LinearGradient(
                colors: [Color(0xFF64B5F6), Color(0xFF3949AB)],
              ),
        border: !showSummary ? Border.all(color: Colors.pink.shade100) : null,
        color: !showSummary ? Colors.pink.shade50.withOpacity(0.3) : null,
      ),
      child: ElevatedButton(
        onPressed: () async {
          // 1. Validation check before showing loading
          if (_pickupDateTime == null || _dropoffDateTime == null) {
            AppSnackbar.show(
              context,
              title: "Error",
              message: "Please select both dates",
              type: SnackType.error,
            );
            return;
          }

          CustomLoading.show(context);

          // 2. Format dates correctly for the API (ISO 8601)
          final String formattedPickup = _pickupDateTime!.toIso8601String();
          final String formattedReturn = _dropoffDateTime!.toIso8601String();

          final bool success = await provider.createRentalRequest(
            carId: provider.carDetails!.id!,
            pickupDate: formattedPickup,
            returnDate: formattedReturn,
            serviceIds: idList,
            notes: _notes.text.trim().isEmpty
                ? "No notes provided"
                : _notes.text.trim(),
            context: context,
          );

          // 3. Handle navigation safely
          if (context.mounted) {
            CustomLoading.hide(context);
            if (success) {
              if(context.mounted){context.go(AppRoute.homeCustomer);}
              
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          showSummary ? 'Submit Request' : 'Confirm',
          style: TextStyle(
            color: showSummary ? Colors.white : Colors.pink.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
