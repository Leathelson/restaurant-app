import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
///=== NEW IMPORTS START ===///
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import '../../models/reservation_model.dart' as model;
///=== NEW IMPORTS END ===///
import '../../models/app_data.dart';
import '../dashboard/dashboard_screen.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  int _guests = 2;
  ///=== NEW VARIABLE START ===///
  bool _isLoading = false;  // Add this for loading state
  ///=== NEW VARIABLE END ===///

  final List<String> _availableTimes = [
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
  ];



  ///=== NEW METHOD 1: _makeReservation (async version) START ===///
  Future<void> _makeReservation() async {
  if (_selectedTime == null) return;

  setState(() => _isLoading = true);

  try {
    print('===== STARTING RESERVATION =====');
    
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.email}');
    
    if (user == null) {
      print('❌ No user logged in');
      _showErrorDialog('Not Logged In', 'Please log in to make a reservation');
      setState(() => _isLoading = false);
      return;
    }

    String phoneNumber = user.phoneNumber ?? '';
    print('Phone number: $phoneNumber');

    String reservationId = FirebaseFirestore.instance
        .collection('reservations')
        .doc()
        .id;
    print('Generated reservation ID: $reservationId');

    String formattedDate = '${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}';
    print('Formatted date: $formattedDate');

    // Create reservation
    final reservation = model.Reservation(
      id: reservationId,
      userId: user.uid,
      customerName: user.displayName ?? 'Customer',
      customerEmail: user.email!,
      customerPhone: phoneNumber,
      date: _selectedDay,
      time: _selectedTime!,
      guests: _guests,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    print('Reservation object created');

    // Save to Firestore
    print('Attempting to save to Firestore...');
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .set(reservation.toJson());
    print('✅ Reservation saved to Firestore successfully!');

    // Send email
    print('Attempting to send email...');
    await _sendEmail(
      email: user.email!,
      name: user.displayName ?? 'Customer',
      date: formattedDate,
      time: _selectedTime!,
      guests: _guests,
      reservationId: reservationId,
    );

    AppData.cart.clear();
    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Sent!'),
        content: Text(
          'Your reservation request for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year} at $_selectedTime for $_guests guests has been sent.\n\n'
          'We\'ll email you at ${user.email} within 2 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
                (route) => false,
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

  } catch (e) {
    print('❌ ERROR in _makeReservation: $e');
    print('❌ Error type: ${e.runtimeType}');
    setState(() => _isLoading = false);
    _showErrorDialog('Error', 'Failed to make reservation: $e');
  }
}
  ///=== NEW METHOD 1 END ===///

  ///=== NEW METHOD 2: _sendEmail START ===///
  Future<void> _sendEmail({
    required String email,
    required String name,
    required String date,
    required String time,
    required int guests,
    required String reservationId,
  }) async {
    try {
      // REPLACE THESE WITH YOUR ACTUAL EMAILJS CREDENTIALS
      print('Sending email to: $email');
    
      await emailjs.send(
        'service_4c1aafl',     // Get from EmailJS dashboard
        'template_xr4owsp',    // Get from EmailJS dashboard
        {
          'to_email': email,
          'to_name': name,
          'date': date,
          'time': time,
          'guests': guests.toString(),
          'reservation_id': reservationId,
        },
        const emailjs.Options(
          publicKey: 'ZvZFRKQC3NOezfVE9',  // Get from EmailJS dashboard
          privateKey: 'gPqaVMjHo6CO-q2hsk6cL', // Get from EmailJS dashboard
        ),
      );
      print('Email sent successfully');
  } catch (error) {
    print('Error sending email: $error');
  }
}
  ///=== NEW METHOD 2 END ===///

  ///=== NEW METHOD 3: _showErrorDialog START ===///
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  ///=== NEW METHOD 3 END ===///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserve Table')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... (your existing calendar code stays exactly the same)
                  Text(
                    'Select Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 30)),
                    focusedDay: _selectedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _selectedTime = null;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Number of Guests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guests > 1
                            ? () => setState(() => _guests--)
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '$_guests guests',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: _guests < 8
                            ? () => setState(() => _guests++)
                            : null,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Times',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTimes
                        .map(
                          (time) => ChoiceChip(
                            label: Text(time),
                            selected: _selectedTime == time,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTime = selected ? time : null;
                              });
                            },
                            selectedColor: Colors.amber,
                            backgroundColor: Colors.grey[200],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                ///=== UPDATED BUTTON ONPRESSED START ===///
                onPressed: _selectedTime != null && !_isLoading 
                    ? _makeReservation 
                    : null,
                ///=== UPDATED BUTTON ONPRESSED END ===///
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                ///=== UPDATED BUTTON CHILD START ===///
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Text(
                        'CONFIRM RESERVATION',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                ///=== UPDATED BUTTON CHILD END ===///
              ),
            ),
          ),
        ],
      ),
    );
  }
}