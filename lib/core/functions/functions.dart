import 'package:flutter/material.dart';
import 'package:quiz_app/core/functions/costum_snack_bar.dart';

class Functions {
  static String formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  static void showSnackBar(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      costumSnackBar(
        title: title,
        content: content,
        icon: icon,
        color: color,
      ),
    );
  }
}
