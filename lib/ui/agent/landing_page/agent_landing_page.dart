import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';


class AgentLandingPage extends StatefulWidget {
  final Widget child;
  const AgentLandingPage({super.key, required this.child});

  @override
  State<AgentLandingPage> createState() => _AgentLandingPageState();
}
class _AgentLandingPageState extends State<AgentLandingPage> {
  int _selectedIndex = 0;

  // Constants for your specific colors
  static const Color _activeColor = Color(0xFF5592FB);
  static const Color _inactiveColor = Color(0xFF7F8186);

  final List<String> _pages = [
    AppRoute.home,
    AppRoute.rentals,
    AppRoute.message,
    AppRoute.profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        // Set text colors
        selectedItemColor: _activeColor,
        unselectedItemColor: _inactiveColor,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed, // Use fixed to ensure colors apply correctly
        onTap: (v) {
          if (_selectedIndex == v) return;
          setState(() => _selectedIndex = v);
          context.go(_pages[v]);
        },
        items: [
          _buildNavItem("assets/icons/home.svg", "Home", 0),
          _buildNavItem("assets/icons/rentals.svg", "Rentals", 1),
          _buildNavItem("assets/icons/message.svg", "Message", 2),
          _buildNavItem("assets/icons/profile.svg", "Profile", 3),
        ],
      ),
    );
  }

  // Helper method to handle SVG color filtering based on index
  BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    final Color color = _selectedIndex == index ? _activeColor : _inactiveColor;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}