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
  Color get gold => const Color(0xFFB37C1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with background (top half only)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background_profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, color: Colors.white),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SettingsScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered profile picture floating below the background
                Positioned(
                  bottom: -120, // moves the avatar down
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'William Dafuk',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Space so menu doesn't overlap avatar
            const SizedBox(height: 120),

            // Menu Options
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuOption(
                    context,
                    'User Info & Preferences',
                    Icons.person_outline,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => UserInfoScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Order History',
                    Icons.history,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderHistoryScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Favourite & Recommendation',
                    Icons.favorite_border,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavoritesScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Loyalty & Rewards',
                    Icons.card_giftcard,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoyaltyScreen())),
                    const Color(0xFF2F2740),
                  ),
                  _buildMenuOption(
                    context,
                    'Payment & Security',
                    Icons.payment,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PaymentScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Reservation',
                    Icons.calendar_today,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReservationsScreen())),
                    gold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    Color backgroundColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
