import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    SnackType type = SnackType.info,
  }) {
    final color = _bgColor(type);
    final icon = _icon(type);

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Color _bgColor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return Colors.green;
      case SnackType.error:
        return Colors.red;
      case SnackType.warning:
        return Colors.orange;
      case SnackType.info:
      default:
        return Colors.blue;
    }
  }

  static IconData _icon(SnackType type) {
    switch (type) {
      case SnackType.success:
        return Icons.check_circle;
      case SnackType.error:
        return Icons.error;
      case SnackType.warning:
        return Icons.warning;
      case SnackType.info:
      default:
        return Icons.info;
    }
  }
}
