import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import '../../models/app_data.dart';
import '../../models/reservation_model.dart' as model;

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 19, minute: 0);
  int guests = 2;
  int duration = 2;
  bool _isLoading = false;

  final Color gold = const Color(0xFFB37C1E);
  final Color darkText = const Color(0xFF34495E);
  final Color creamBg = const Color(0xFFFFF9F0);

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: gold),
          ),
          child: child!,
        );
      },
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

  Future<void> _sendEmail({
    required String email,
    required String name,
    required String date,
    required String time,
    required int guests,
    required String reservationId,
  }) async {
    try {
      await emailjs.send(
        'service_4c1aafl',
        'template_xr4owsp',
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
    } catch (error) {
      debugPrint('Error sending email: $error');
    }
  }

  void _confirmReservation() async {
    setState(() => _isLoading = true);

    try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppData.trans("Please log in first"))),
        );
        setState(() => _isLoading = false);
        return;
      }

      String reservationId =
          FirebaseFirestore.instance.collection('reservations').doc().id;
      String formattedDate =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      String formattedTime = selectedTime.format(context);

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

      // Save to Firebase
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .set(firebaseReservation.toJson());

      // Send Confirmation Email
      await _sendEmail(
        email: user.email!,
        name: user.displayName ?? 'Customer',
        date: formattedDate,
        time: formattedTime,
        guests: guests,
        reservationId: reservationId,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppData.trans("Reservation request sent! Check your email."))),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppData.trans("Error")}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppData.trans("Reservation"),
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Date Selection
            _buildPickerTile(
              label: AppData.trans("Select Date"),
              value:
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              icon: Icons.calendar_month,
              onTap: _selectDate,
              isPrimary: true,
            ),

            const SizedBox(height: 20),

            // Time Selection
            _buildPickerTile(
              label: AppData.trans("Arrival Time"),
              value: selectedTime.format(context),
              icon: Icons.access_time_filled,
              onTap: _selectTime,
              isPrimary: false,
            ),

            const SizedBox(height: 20),

            // Guests Counter
            _counterRow(AppData.trans("Number of Guests"), guests, (v) {
              setState(() => guests = v.clamp(1, 20));
            }),

            const SizedBox(height: 16),

            // Duration Counter
            _counterRow(AppData.trans("Reservation Duration [hrs]"), duration,
                (v) {
              setState(() => duration = v.clamp(1, 6));
            }),

            const SizedBox(height: 40),

            // Summary Text
            Text(
              "${_formatDate(selectedDate)} ${AppData.trans("at")} ${selectedTime.format(context)}",
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16, color: darkText),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: _isLoading ? null : _confirmReservation,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(AppData.trans("Confirm"),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppData.trans("Cancel"),
                        style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerTile(
      {required String label,
      required String value,
      required IconData icon,
      required VoidCallback onTap,
      required bool isPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isPrimary ? creamBg : darkText,
          borderRadius: BorderRadius.circular(15),
          border: isPrimary ? Border.all(color: gold.withOpacity(0.5)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: isPrimary ? gold : Colors.white70),
                const SizedBox(width: 15),
                Text(label,
                    style: TextStyle(
                        color: isPrimary ? Colors.black87 : Colors.white70,
                        fontSize: 16)),
              ],
            ),
            Text(value,
                style: TextStyle(
                    color: isPrimary ? Colors.black87 : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _counterRow(String label, int value, Function(int) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration:
          BoxDecoration(color: gold, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
            onPressed: () => onChanged(value - 1),
          ),
          Text("$value",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final List<String> dayKeys = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return "${AppData.trans(dayKeys[d.weekday - 1])}, ${d.day}/${d.month}/${d.year}";
  }
}
