import 'package:flutter/material.dart';
import 'user_info_screen.dart';
import 'order_history_screen.dart';
import 'favorites_screen.dart';
import 'loyalty_screen.dart';
import 'payment_screen.dart';
import 'reservations_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  decoration: const BoxDecoration(
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
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered profile picture floating below the background
                const Positioned(
                  bottom: -120, // moves the avatar down
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      SizedBox(height: 12),
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
                        MaterialPageRoute(builder: (_) => const UserInfoScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Order History',
                    Icons.history,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OrderHistoryScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Favourite & Recommendation',
                    Icons.favorite_border,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Loyalty & Rewards',
                    Icons.card_giftcard,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoyaltyScreen())),
                    const Color(0xFF2F2740),
                  ),
                  _buildMenuOption(
                    context,
                    'Payment & Security',
                    Icons.payment,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PaymentScreen())),
                    gold,
                  ),
                  _buildMenuOption(
                    context,
                    'Reservation',
                    Icons.calendar_today,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReservationsScreen())),
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
