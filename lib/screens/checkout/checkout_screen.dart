import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../reservation/reservation_screen.dart';
import '../dashboard/dashboard_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double get total {
    return AppData.cart.fold(
      0,
      (sum, item) => sum + (item.food.price * item.quantity),
    );
  }

  void _placeOrder() {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(AppData.cart),
      total: total,
      date: DateTime.now(),
      status: 'Confirmed',
    );

    AppData.orders.add(order);
    AppData.currentUser.totalSpent += total;
    AppData.currentUser.totalOrders++;
    AppData.currentUser.loyaltyPoints += (total / 10).round();
    AppData.cart.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Confirmed!'),
        content: Text(
          'Your order has been placed successfully. Estimated delivery: 30-45 minutes.',
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

  void _reserveTable() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ...AppData.cart
                      .map(
                        (item) => Card(
                          child: ListTile(
                            leading: Text(
                              item.food.image,
                              style: TextStyle(fontSize: 24),
                            ),
                            title: Text(item.food.name),
                            subtitle: Text('Quantity: ${item.quantity}'),
                            trailing: Text(
                              '\$${(item.food.price * item.quantity).toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  SizedBox(height: 16),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'ORDER FOR DELIVERY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _reserveTable,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.amber),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'RESERVE TABLE & DINE IN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
