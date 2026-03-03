import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class ReceiptScreen extends StatelessWidget {
  final List<dynamic> items;
  final double total;

  const ReceiptScreen({super.key, required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    // UI Colors
    const Color luxeGold = Color(0xFFB8860B);
    const Color darkSlate = Color(0xFF34495E);
    const Color maroonTitle = Color(0xFF63210B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline,
                  color: Color.fromARGB(255, 40, 136, 90), size: 70),
              const SizedBox(height: 15),
              Text(
                AppData.trans("PAYMENT SUCCESSFUL"),
                style: const TextStyle(
                    color: Color(0xFF34495E),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 237, 237),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      AppData.trans("DIGITAL RECEIPT"),
                      style: const TextStyle(
                          color: maroonTitle,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    const Divider(height: 30, thickness: 1),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final dynamic item = items[index];
                          String displayName = "Product";
                          double price = 0.0;

                          try {
                            displayName = AppData.trans(item.food.name);
                            price = (item.unitPrice ?? 0.0).toDouble() *
                                (item.quantity ?? 1);
                          } catch (e) {
                            displayName = AppData.trans("Product");
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                // FIX: Expanded prevents the name from pushing the price off-screen
                                Expanded(
                                  child: Text(
                                    "${item.quantity}x $displayName",
                                    style: const TextStyle(
                                        fontSize: 12, color: maroonTitle),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Rs ${price.toInt()}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: maroonTitle,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),
                    _receiptRow(
                        AppData.trans("Transaction ID"),
                        "#TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
                        maroonTitle),
                    _receiptRow(
                        AppData.trans("Date"),
                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        maroonTitle),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 221, 221),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppData.trans("TOTAL PAID"),
                            style: const TextStyle(
                                color: darkSlate,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            "Rs ${total.toInt()}",
                            style: const TextStyle(
                                color: luxeGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: luxeGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    AppData.cart.clear();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    AppData.trans("BACK TO HOME"),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // FIX: Expanded ensures long labels (like in French) don't overflow
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: themeColor.withOpacity(0.7),
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
                color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
