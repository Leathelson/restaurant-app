import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class UserInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Info')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.amber,
                      child: Text(
                        AppData.currentUser.name[0],
                        style: TextStyle(fontSize: 32, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppData.currentUser.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppData.currentUser.email,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildStatRow(
                      'Total Orders',
                      '${AppData.currentUser.totalOrders}',
                    ),
                    _buildStatRow(
                      'Total Spent',
                      '\$${AppData.currentUser.totalSpent.toStringAsFixed(2)}',
                    ),
                    _buildStatRow(
                      'Loyalty Points',
                      '${AppData.currentUser.loyaltyPoints}',
                    ),
                    _buildStatRow('Member Since', 'January 2024'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
