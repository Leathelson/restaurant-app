import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = 'Credit Card';
  List<Map<String, String>> paymentMethods = [
    {'type': 'Credit Card', 'details': '**** **** **** 1234'},
    {'type': 'Debit Card', 'details': '**** **** **** 5678'},
    {'type': 'PayPal', 'details': 'john@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPaymentDialog();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Default Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  return Card(
                    child: RadioListTile<String>(
                      title: Text(method['type']!),
                      subtitle: Text(method['details']!),
                      value: method['type']!,
                      groupValue: selectedPayment,
                      activeColor: Colors.amber,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      secondary: Icon(_getPaymentIcon(method['type']!)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'Credit Card':
      case 'Debit Card':
        return Icons.credit_card;
      case 'PayPal':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Payment Method'),
        content: const Text('Payment method addition would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
