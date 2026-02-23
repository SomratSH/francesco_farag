import 'package:flutter/material.dart';
import 'package:francesco_farag/utils/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool showTrend;

  const StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.showTrend = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.05,
            ), // Very light opacity for a clean look
            blurRadius: 10, // Softens the shadow edge
            spreadRadius: 1, // Extends the shadow slightly
            offset: const Offset(0, 4), // Pushes the shadow downward
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors().gradientBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Color(0xff6B7280), fontSize: 13),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (showTrend)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.blue,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class CheckInTile extends StatelessWidget {
  final String name;
  final String carModel;
  final String time;
  final String initial;

  const CheckInTile({
    required this.name,
    required this.carModel,
    required this.time,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[50],
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                carModel,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPrimary;

  const QuickAccessItem({
    required this.title,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: isPrimary
          ? BoxDecoration(
              gradient: AppColors().gradientPink,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                ),
              ],
              border: isPrimary
                  ? null
                  : Border.all(color: Colors.grey.shade100),
            )
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                ),
              ],
              border: isPrimary
                  ? null
                  : Border.all(color: Colors.grey.shade100),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isPrimary
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xffF0FAFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon, color: Color(0xff167FF3)),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors().gradientBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon, color: Colors.white),
                  ),
                ),
          SizedBox(height: 10),
          isPrimary
              ? Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff1A1A1A),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
        ],
      ),
    );
  }
}
