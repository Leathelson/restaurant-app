class Reservation {
  final String id;
  final String userId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime date;
  final String time;
  final int guests;
  final String status;
  final DateTime createdAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'date': date,
      'time': time,
      'guests': guests,
      'status': status,
      'createdAt': createdAt,
    };
  }
}