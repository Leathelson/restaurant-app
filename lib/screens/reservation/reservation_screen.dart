import 'package:flutter/material.dart';
// FIX: Ensure the correct path to your dashboard file
import 'package:luxury_restaurant_app/screens/dashboard/dashboard_screen.dart';
import '../../models/app_data.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // ... (Keep your existing variables like date, time, guests, etc.)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve a Table'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleReservation,
          child: const Text('Confirm Reservation'),
        ),
      ),
    );
  }

  void _handleReservation() {
    // Logic to save reservation to AppData.reservations...

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Reservation Confirmed'),
        content: const Text('We look forward to seeing you!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog

              // FIX: Navigate to LuxuryDashboard and pass the required products list
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LuxuryDashboard(products: []),
                ),
                (route) => false,
              );
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }
}
