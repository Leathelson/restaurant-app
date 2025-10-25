import 'package:flutter/material.dart';
import '../../models/app_data.dart';
import '../checkout/checkout_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final dynamic
      foodItem; // expects your AppData.foodItems element (adjust type if you have a Food class)

  const FoodDetailScreen({Key? key, required this.foodItem}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int qty = 1;

  Color get gold => const Color(0xFFB37C1E);
  Color get darkBg => const Color(0xFF2F2740);

  void _addToCart() {
    // Attempt to create a CartItem - adjust constructor if your model differs.
    try {
      final cartItem = CartItem(food: widget.foodItem, quantity: qty);
      AppData.cart.add(cartItem);
    } catch (e) {
      // If your app uses a different cart model, update this accordingly.
      // As a fallback add a simple map (may break other code expecting CartItem).
      AppData.cart.add(CartItem(food: widget.foodItem, quantity: qty));
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('Item added to cart'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: darkBg),
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CheckoutScreen()),
              );
            },
            child: const Text('Go To Cart'),
          ),
        ],
      ),
    );
  }

  String _imagePath() {
    // Support several possible field names used in your app_data items
    final item = widget.foodItem;
    if (item == null) return 'assets/images/food1.png';
    if (item is Map) {
      return (item['image'] ??
          item['img'] ??
          item['imagePath'] ??
          'assets/images/food1.png') as String;
    }
    try {
      // try common property names
      final img = (item.image ?? item.img ?? item.imagePath) as String?;
      return img ?? 'assets/images/food1.png';
    } catch (_) {
      return 'assets/images/food1.png';
    }
  }

  String _title() {
    final item = widget.foodItem;
    if (item == null) return 'Delicious Dish';
    if (item is Map) return item['name'] ?? 'Delicious Dish';
    try {
      return item.name ?? 'Delicious Dish';
    } catch (_) {
      return 'Delicious Dish';
    }
  }

  String _desc() {
    final item = widget.foodItem;
    if (item == null) return '';
    if (item is Map) return item['description'] ?? '';
    try {
      return item.description ?? '';
    } catch (_) {
      return '';
    }
  }

  double _price() {
    final item = widget.foodItem;
    if (item == null) return 0;
    if (item is Map)
      return (item['price'] is num) ? (item['price'] as num).toDouble() : 0;
    try {
      return (item.price is num) ? (item.price as num).toDouble() : 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = _imagePath();
    final title = _title();
    final desc = _desc();
    final price = _price();

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // top area with back button and image rounded
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),

            // image card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  img,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // white detail panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // rating + quantity pill row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // rating pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                                color: gold.withOpacity(0.9), width: 2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 8),
                              Text('4.0',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),

                        // qty pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: gold,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove,
                                    color: Colors.white),
                                onPressed: () => setState(() {
                                  if (qty > 1) qty--;
                                }),
                                splashRadius: 18,
                              ),
                              Text('$qty',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () => setState(() => qty++),
                                splashRadius: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // title
                    Text(
                      title,
                      style: TextStyle(
                        color: const Color(0xFFB56A2E),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // description
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          desc,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // total price + add to cart button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Price',
                                style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            Text(
                              'Rs ${(price * qty).toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: gold),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _addToCart,
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: const Text('Add To Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBg,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
