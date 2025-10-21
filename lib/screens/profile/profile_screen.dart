import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import 'user_info_screen.dart';
import 'order_history_screen.dart';
import 'favorites_screen.dart';
import 'loyalty_screen.dart';
import 'payment_screen.dart';
import 'reservations_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: Text(
                      AppData.currentUser.name[0],
                      style: TextStyle(fontSize: 24, color: Colors.amber),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppData.currentUser.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(AppData.currentUser.email),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Profile Options
            _buildProfileOption(
              context,
              'User Info',
              Icons.person,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInfoScreen()),
              ),
            ),
            _buildProfileOption(
              context,
              'Order History',
              Icons.history,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
              ),
            ),
            _buildProfileOption(
              context,
              'Favorites',
              Icons.favorite,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              ),
            ),
            _buildProfileOption(
              context,
              'Loyalty',
              Icons.card_giftcard,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoyaltyScreen()),
              ),
            ),
            _buildProfileOption(
              context,
              'Payment',
              Icons.payment,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentScreen()),
              ),
            ),
            _buildProfileOption(
              context,
              'Reservations',
              Icons.table_restaurant,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservationsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
