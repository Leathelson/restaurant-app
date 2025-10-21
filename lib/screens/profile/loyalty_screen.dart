import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class LoyaltyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loyalty Program')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Your Points',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${AppData.currentUser.loyaltyPoints}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Points available'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Available Rewards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRewardCard(
                    'Free Appetizer',
                    100,
                    'Get any starter for free',
                  ),
                  _buildRewardCard(
                    '10% Off Next Order',
                    200,
                    'Save 10% on your next purchase',
                  ),
                  _buildRewardCard(
                    'Free Dessert',
                    150,
                    'Choose any dessert on the house',
                  ),
                  _buildRewardCard(
                    'Priority Reservation',
                    300,
                    'Skip the wait with priority booking',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(String title, int points, String description) {
    final canRedeem = AppData.currentUser.loyaltyPoints >= points;

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.card_giftcard,
          color: canRedeem ? Colors.amber : Colors.grey,
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$points pts', style: TextStyle(fontWeight: FontWeight.bold)),
            if (canRedeem)
              Text(
                'Available',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
          ],
        ),
        onTap: canRedeem
            ? () {
                // Redeem reward logic
              }
            : null,
      ),
    );
  }
}
