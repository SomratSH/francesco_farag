import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerRequestQuatation extends StatefulWidget {
  const CustomerRequestQuatation({super.key});

  @override
  State<CustomerRequestQuatation> createState() =>
      _CustomerRequestQuatationState();
}

class _CustomerRequestQuatationState extends State<CustomerRequestQuatation> {
  bool showSummary = false;
  final Map<String, bool> _extraServices = {
    'Extra Insurance': false,
    'GPS Navigation': false,
    'Child Seat': false,
    'Additional Driver': false,
  };

  final Map<String, int> _prices = {
    'Extra Insurance': 15,
    'GPS Navigation': 10,
    'Child Seat': 8,
    'Additional Driver': 20,
  };

  @override
  Widget build(BuildContext context) {
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
            _buildCarPreview(),
            const SizedBox(height: 16),

            // --- 2. Location Selection ---
            _buildSectionCard(
              child: Column(
                children: [
                  _buildLocationDropdown(
                    'Pickup Location',
                    'Enter pickup location',
                  ),
                  const SizedBox(height: 12),
                  _buildLocationDropdown(
                    'Drop-off Location',
                    'Enter drop-off location',
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
                children: _extraServices.keys.map((service) {
                  return _buildServiceCheckbox(service, _prices[service]!);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // --- 4. Additional Notes ---
            _buildSectionCard(
              title: 'Additional Notes (optional)',
              child: TextField(
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
            if (showSummary) _buildEstimatedCost(),

            const SizedBox(height: 24),

            // --- 6. Action Button ---
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarPreview() {
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
                  const Text(
                    'Tesla Model 3',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      'Economy',
                      style: TextStyle(
                        color: Colors.pink.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 14),
                  Text(
                    ' 4.8',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '5 seats • Automatic',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '\$89',
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

  Widget _buildLocationDropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              hint: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hint,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              items: const [],
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCheckbox(String label, int price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _extraServices[label]!
            ? const Color(0xFFF0F7FF)
            : Colors.transparent,
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        secondary: Text(
          '\$$price/day',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        value: _extraServices[label],
        activeColor: Colors.blue,
        onChanged: (val) => setState(() => _extraServices[label] = val!),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        dense: true,
      ),
    );
  }

  Widget _buildEstimatedCost() {
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
          _costRow('Base rental (01 days)', '\$89'),
          _costRow('Extra services', '\$15'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Estimated Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$104',
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

  Widget _buildActionButton() {
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
        onPressed: () => setState(() => showSummary = true),
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
