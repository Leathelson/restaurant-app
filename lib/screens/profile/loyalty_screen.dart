import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class LoyaltyScreen extends StatelessWidget {
  LoyaltyScreen({super.key});

  final Color maroonColor = const Color(0xFF63210B);
  final Color goldColor = const Color(0xFFA67117);
  final Color darkBlue = const Color(0xFF2D2942);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppData.trans('Rewards'),
          style: TextStyle(
              color: maroonColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // --- Points Display ---
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: darkBlue, width: 25),
                    ),
                  ),
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: CircularProgressIndicator(
                      value: 0.70,
                      strokeWidth: 25,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${AppData.currentUser.loyaltyPoints}',
                          style: TextStyle(
                              color: goldColor,
                              fontSize: 72,
                              fontWeight: FontWeight.bold)),
                      Text(AppData.trans('POINT').toUpperCase(),
                          style: TextStyle(
                              color: goldColor,
                              fontSize: 20,
                              letterSpacing: 2)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // --- Rewards List ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildRewardCard(
                      context,
                      'Grilled Sirloin Steak',
                      'For 2 persons',
                      'assets/images/FoodItems/GrilledSirloinSteak.png' // Check if this file exists in your folder!
                      ),
                  const SizedBox(height: 16),
                  _buildRewardCard(
                    context,
                    '50% discount on everything',
                    'Limited offer',
                    'assets/images/discount.png',
                    isIcon: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(
      BuildContext context, String title, String subtitle, String imagePath,
      {bool isIcon = false}) {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: goldColor.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: 85,
                height: 85,
                fit: isIcon ? BoxFit.contain : BoxFit.cover,
                // ERROR BUILDER: If you see the "restaurant" icon, the path is still wrong.
                errorBuilder: (context, error, stackTrace) {
                  print(
                      "Could not find image at: $imagePath"); // Check your console for this!
                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant, color: goldColor),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppData.trans(title),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(AppData.trans(subtitle),
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
          // Vertical Redeem Button
          Container(
            width: 48,
            height: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: darkBlue, borderRadius: BorderRadius.circular(15)),
            child: RotatedBox(
              quarterTurns: 3,
              child: Center(
                child: Text(AppData.trans('Redeem'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
