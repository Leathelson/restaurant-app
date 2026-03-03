import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../profile/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color luxeGold = const Color(0xFFB8860B);
  final Color deepNavy = const Color(0xFF34495E);
  final Color maroonText = const Color(0xFF63210B);

  @override
  Widget build(BuildContext context) {
    double subtotal = AppData.cart
        .fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));
    double tax = 100.0;
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TRANSLATED: "My"
                    Text(AppData.trans("My"),
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: maroonText)),
                    // TRANSLATED: "Cart List"
                    Text(AppData.trans("Cart List"),
                        style: TextStyle(
                            fontSize: 24,
                            color: luxeGold,
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined,
                      color: Colors.redAccent, size: 30),
                  onPressed: () => setState(() => AppData.cart.clear()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AppData.cart.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: AppData.cart.length,
                    itemBuilder: (context, index) {
                      final item = AppData.cart[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) =>
                            setState(() => AppData.cart.removeAt(index)),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(25)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: _buildCartItem(item),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 100),
            decoration: BoxDecoration(
              color: const Color(0xFF34495E),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TRANSLATED: "Subtotal"
                _summaryRow(
                    AppData.trans("Subtotal"), "Rs ${subtotal.toInt()}"),
                const SizedBox(height: 12),
                // TRANSLATED: "Tax"
                _summaryRow(AppData.trans("Tax"), "Rs ${tax.toInt()}"),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(color: Colors.white24, thickness: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TRANSLATED: "Total"
                    Text(AppData.trans("Total"),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16)),
                    Text("Rs ${total.toInt()}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: luxeGold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentScreen())),
                    // TRANSLATED: "PROCEED TO CHECKOUT"
                    child: Text(AppData.trans("PROCEED TO CHECKOUT"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: luxeGold.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: luxeGold, width: 2),
            ),
            child: ClipOval(
              child: item.food.image.startsWith('http')
                  ? Image.network(item.food.image,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => _imagePlaceholder())
                  : Image.asset(item.food.image,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => _imagePlaceholder()),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TRANSLATED: Item Name (e.g., "beluga caviar")
                Text(AppData.trans(item.food.name),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("Rs ${item.unitPrice.toInt()}",
                    style: TextStyle(
                        color: luxeGold, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFFFDF7E7),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => item.quantity++),
                  child: Icon(Icons.add, size: 20, color: maroonText),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("${item.quantity}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    if (item.quantity > 1) item.quantity--;
                  }),
                  child: Icon(Icons.remove, size: 20, color: maroonText),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
      color: Colors.grey[100], child: Icon(Icons.restaurant, color: luxeGold));

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildEmptyState() => Center(
        // TRANSLATED: Empty state message
        child: Text(AppData.trans("Your palate awaits its first favourite.")),
      );
}
