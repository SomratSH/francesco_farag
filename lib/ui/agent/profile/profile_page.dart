import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:francesco_farag/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Profile Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration:  BoxDecoration(
                gradient: AppColors().gradientPink,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 47,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=john'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'John Smith',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'john@example.com',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- Personal Information Section ---
                  const SectionCard(
                    title: 'Personal Information',
                    showEdit: true,
                    children: [
                      InfoTile(icon: Icons.person_outline, label: 'Full Name', value: 'Sahrah Johnson'),
                      InfoTile(icon: Icons.mail_outline, label: 'Email', value: 'sarah@eurocar.com'),
                      InfoTile(icon: Icons.phone_outlined, label: 'Phone', value: '+1234567890'),
                    ],
                  ),

                  // --- Agency Information ---
                  const SectionCard(
                    title: 'Agency Information',
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFFECEFF1),
                          child: Text('🚗', style: TextStyle(fontSize: 20)),
                        ),
                        title: Text('EuroCar Rentals', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Verified Partner', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),

                  // --- Quick Actions ---
                  const SectionCard(
                    title: 'Quick Actions',
                    children: [
                      ActionTile(icon: Icons.description_outlined, color: Colors.blue, label: 'Manage Bookings'),
                      ActionTile(icon: Icons.chat_outlined, color: Colors.orange, label: 'Customer Messages'),
                      ActionTile(icon: Icons.assignment_turned_in_outlined, color: Colors.blueGrey, label: 'Booking Status'),
                    ],
                  ),

                  // --- Terms & Support ---
                  const SectionCard(
                    children: [
                      TextLink(label: 'Terms & Conditions'),
                      TextLink(label: 'Privacy Policy'),
                      TextLink(label: 'Help & Support'),
                      TextLink(label: 'About Us'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Logout Button ---
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF06292), Color(0xFFD81B60)]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class SectionCard extends StatelessWidget {
  final String? title;
  final bool showEdit;
  final List<Widget> children;

  const SectionCard({super.key, this.title, this.showEdit = false, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (showEdit) InkWell(
                  onTap: () => context.push(AppRoute.editProfile),
                  child: const Icon(Icons.edit_note, color: Colors.black54)),
              ],
            ),
          if (title != null) const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: const Color(0xFF3F51B5), size: 20),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const ActionTile({super.key, required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class TextLink extends StatelessWidget {
  final String label;
  const TextLink({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
    );
  }
}