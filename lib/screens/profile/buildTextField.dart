import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String label;
  final Color bgColor;
  final void Function()? onPressed;
  final String text;
  final IconData? icon;

  const MyTextBox({
    super.key,
    required this.label,
    required this.bgColor,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.red.shade900,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 180, 124, 30),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: bgColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
