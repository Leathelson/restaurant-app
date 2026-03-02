import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs; // Make sure this is correct
import '../../models/app_data.dart';
import '../../models/reservation_model.dart' as model; // Keep 'as model'

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 19, minute: 0);
  int guests = 2;
  int duration = 2;
  bool _isLoading = false; // Keep this

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  // FIX 1: Add this method
  Future<void> _sendEmail({
    required String email,
    required String name,
    required String date,
    required String time,
    required int guests,
    required String reservationId,
  }) async {
    try {
      print('Sending email to: $email');

      await emailjs.send(
        'service_4c1aafl', // Your actual service ID
        'template_xr4owsp', // Your actual template ID
        {
          'to_email': email,
          'to_name': name,
          'date': date,
          'time': time,
          'guests': guests.toString(),
          'reservation_id': reservationId,
        },
        const emailjs.Options(
          publicKey: 'ZvZFRKQC3NOezfVE9',
          privateKey: 'gPqaVMjHo6CO-q2hsk6cL',
        ),
      );

      print('Email sent successfully');
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  // FIX 2: Update this method
  void _confirmReservation() async {
    // Show loading
    setState(() => _isLoading = true);

    try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please log in first")),
        );
        setState(() => _isLoading = false);
        return;
      }

      String reservationId =
          FirebaseFirestore.instance.collection('reservations').doc().id;

      String formattedDate =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      String formattedTime = selectedTime.format(context);

      // Create Firebase version (using model.Reservation)
      final firebaseReservation = model.Reservation(
        id: reservationId,
        userId: user.uid,
        customerName: user.displayName ?? 'Customer',
        customerEmail: user.email!,
        customerPhone: user.phoneNumber ?? '',
        date: selectedDate,
        time: formattedTime,
        guests: guests,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      // Create local AppData version (using regular Reservation)
      final localReservation = Reservation(
        id: reservationId,
        date: selectedDate,
        time: formattedTime,
        guests: guests,
        status: 'pending',
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .set(firebaseReservation.toJson());

      // Send email
      await _sendEmail(
        email: user.email!,
        name: user.displayName ?? 'Customer',
        date: formattedDate,
        time: formattedTime,
        guests: guests,
        reservationId: reservationId,
      );

      // Save to local AppData
      AppData.reservations.add(localReservation);

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reservation request sent! Check your email.")),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFB37C1E);

    //  Detect orientation for adaptive layout
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation"),
        elevation: 0,
        centerTitle: true,
      ),
      // ✅ Make entire body scrollable
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // ✅ Buttons stretch properly
          mainAxisSize:
              MainAxisSize.min, // ✅ Required for SingleChildScrollView
          children: [
            // Date Picker
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Time Picker
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text("Select Time",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const Spacer(),
                    Text(
                      selectedTime.format(context),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Number of Guests
            _counterRow("Number of Guests", guests, (v) {
              setState(() => guests = v.clamp(1, 20));
            }, gold),

            const SizedBox(height: 16),

            // Duration
            _counterRow("Reservation Duration [hrs]", duration, (v) {
              setState(() => duration = v.clamp(1, 6));
            }, gold),

            const SizedBox(height: 16),

            // Display final summary
            Text(
              "${_formatDate(selectedDate)}, ${selectedTime.format(context)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            // ✅ Remove Spacer - doesn't work with scroll
            // Instead, add fixed spacing
            SizedBox(height: isLandscape ? 24 : 48),

            // Confirm & Cancel buttons
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12,
                top: 12,
              ),
              child: isLandscape
                  ? // ✅ Landscape: Stack buttons vertically for better touch targets
                  Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _isLoading ? null : _confirmReservation,
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  "Confirm Reservation",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Times New Roman',
                                    fontSize: isLandscape ? 16 : 14,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Times New Roman',
                              fontSize: isLandscape ? 16 : 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : // ✅ Portrait: Keep original side-by-side buttons
                  Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _isLoading ? null : _confirmReservation,
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Times New Roman'),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(207, 255, 0, 0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Times New Roman'),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterRow(
      String label, int value, Function(int) onChanged, Color gold) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white))),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.white),
            onPressed: () => onChanged(value - 1),
          ),
          Text("$value",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return "${[
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ][d.weekday % 7]}, ${d.day}/${d.month}/${d.year}";
  }
}
