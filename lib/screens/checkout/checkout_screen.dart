import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../reservation/reservation_screen.dart';
import '../dashboard/dashboard_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Color get gold => const Color(0xFFB37C1E);
  Color get darkBg => const Color(0xFF2F2740);

  double get subtotal {
    return AppData.cart.fold(
      0,
      (sum, item) => sum + (item.food.price * item.quantity),
    );
  }

  double get tax => 100; // Fixed tax amount as shown in screenshot
  double get total => subtotal + tax;

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
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
          // Cart items list
          Expanded(
            child: ListView.separated(
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
                      // Food image
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                        child: Image.asset(
                          item.food.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.food.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs ${item.food.price}',
                                style: TextStyle(
                                  color: gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: gold.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.only(right: 12),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 20),
                              onPressed: () => _updateQuantity(index, false),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                            Text(
                              'x${item.quantity}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 20),
                              onPressed: () => _updateQuantity(index, true),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
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

          // Discount code
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Do you have any discount code?',
                hintStyle: TextStyle(color: Colors.black54),
                border: UnderlineInputBorder(),
              ),
            ),
          ),

          // Summary and checkout button
          Container(
            color: darkBg,
            padding: EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(color: Colors.white70)),
                      Text('Rs${subtotal}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax', style: TextStyle(color: Colors.white70)),
                      Text('Rs${tax}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Colors.white24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      Text('Rs${total}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  // ...existing code for _placeOrder and _reserveTable methods...
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
      builder: (context) => AlertDialog(
        title: Text('Order Placed!'),
        content: Text('Your order has been placed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _reserveTable();
            },
            child: Text('Reserve a Table'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen()),
                (route) => false,
              );
            },
            child: Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  void _reserveTable() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReservationScreen()),
    );
  }
}