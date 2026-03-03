// lib/widgets/menu_item_card.dart
import '../widgets/tts_text.dart';
import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name with optional TTS
                Expanded(
                  child: TTSText(
                    text: name,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(price, style: TextStyle(color: Colors.amber)),
              ],
            ),
            const SizedBox(height: 8),
            // Description with TTS (smaller button)
            TTSText(
              text: description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              buttonSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}