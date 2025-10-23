import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 19, minute: 0); // default 7:00 PM
  int guests = 2;
  int duration = 2;

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

  void _confirmReservation() {
    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: selectedDate,
      time: selectedTime.format(context),
      guests: guests,
      // duration: duration,
      status: "Confirmed",
    );

    setState(() {
      AppData.reservations.add(reservation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reservation confirmed")),
    );

    Navigator.pop(context); // go back to reservations list
  }

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFB37C1E);

    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Date Picker
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: gold),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text("Select Time",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Spacer(),
                    Text(
                      selectedTime.format(context),
                      style: TextStyle(
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            Spacer(),

            // Confirm & Cancel buttons
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 12, // extra safe margin
                top: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _confirmReservation,
                      child: Text("Confirm",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Times New Roman')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Times New Roman')),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _counterRow(
      String label, int value, Function(int) onChanged, Color gold) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white))),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.white),
            onPressed: () => onChanged(value - 1),
          ),
          Text("$value",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.white),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return "${["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][d.weekday % 7]}, ${d.day}/${d.month}/${d.year}";
  }
}
