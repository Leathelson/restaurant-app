import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../../models/food_model.dart';
import '../reservation/reservation_screen.dart';
// FIX: Using the correct file path while targeting the LuxuryDashboard class
import 'package:luxury_restaurant_app/screens/dashboard/dashboard_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Color get gold => const Color(0xFFB37C1E);
  Color get darkBg => const Color(0xFF2F2740);

  double get subtotal {
    return AppData.cart.fold<double>(
      0.0,
      (double sum, item) => sum + (item.food.price * item.quantity),
    );
  }

  double get tax => 100;
  double get total => subtotal + tax;

  String _fmt(double v) => v.toStringAsFixed(0);

  void _updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        AppData.cart[index].quantity++;
      } else if (AppData.cart[index].quantity > 1) {
        AppData.cart[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.shopping_cart_outlined, color: gold),
            const SizedBox(width: 8),
            Text(
              'My Cart List',
              style: TextStyle(color: gold, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppData.cart.isEmpty
                ? const Center(child: Text("Your cart is empty"))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: AppData.cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = AppData.cart[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: gold.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12)),
                              child: Image.asset(
                                item.food.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                // FIX: Changed variables to (_, __, ___) to avoid duplicate declaration
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.fastfood,
                                            color: Colors.grey)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.food.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rs ${_fmt(item.food.price)}',
                                      style: TextStyle(
                                          color: gold,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 20),
                                    onPressed: () =>
                                        _updateQuantity(index, false),
                                  ),
                                  Text('x${item.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 20),
                                    onPressed: () =>
                                        _updateQuantity(index, true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            color: darkBg,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                children: [
                  _summaryRow('Subtotal', 'Rs ${_fmt(subtotal)}'),
                  const SizedBox(height: 8),
                  _summaryRow('Tax', 'Rs ${_fmt(tax)}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.white24),
                  ),
                  _summaryRow('Total', 'Rs ${_fmt(total)}', isTotal: true),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Checkout',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isTotal ? Colors.white : Colors.white70,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }

  void _placeOrder() {
    if (AppData.cart.isEmpty) return;

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(AppData.cart),
      total: total,
      date: DateTime.now(),
      status: 'Processing',
    );

    setState(() {
      AppData.orders.add(newOrder);
      AppData.cart.clear();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: const Text('Your order has been placed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reserveTable();
            },
            child: const Text('Reserve a Table'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // FIX: Removed 'const' because products: [] is a dynamic list
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => LuxuryDashboard(products: [])),
                (route) => false,
              );
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  void _reserveTable() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReservationScreen()),
    );
  }
}
