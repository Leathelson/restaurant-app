import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/app_data.dart';
import '../dashboard/dashboard_screen.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  int _guests = 2;

  final List<String> _availableTimes = [
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
    '9:00 PM',
  ];

  void _makeReservation() {
    if (_selectedTime != null) {
      final reservation = Reservation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: _selectedDay,
        time: _selectedTime!,
        guests: _guests,
        status: 'Confirmed',
      );

      AppData.reservations.add(reservation);
      AppData.cart.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Reservation Confirmed!'),
          content: Text(
            'Your table has been reserved for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year} at $_selectedTime for $_guests guests.',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserve Table')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(Duration(days: 30)),
                    focusedDay: _selectedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _selectedTime = null;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Number of Guests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guests > 1
                            ? () => setState(() => _guests--)
                            : null,
                        icon: Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '$_guests guests',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: _guests < 8
                            ? () => setState(() => _guests++)
                            : null,
                        icon: Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Available Times',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
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
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedTime != null ? _makeReservation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'CONFIRM RESERVATION',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
