import 'package:flutter/material.dart';

SnackBar costumSnackBar({
  required String title,
  required String content,
  required IconData icon,
  required Color color,
}) {
  return SnackBar(
    duration: Duration(seconds: 4),
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  maxLines: null,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
  );
}
