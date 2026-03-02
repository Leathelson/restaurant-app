import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';
import '../../models/app_data.dart';
import '../checkout/checkout_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final dynamic
      foodItem; // expects your AppData.foodItems element (adjust type if you have a Food class)

  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

//customisation options - you can replace these with actual options from your data model if needed
String selectedOption = 'Regular';

final Map<String, double> customizationOptions = {
  'Regular': 0,
  'Extra Sauce': 150,
  'Cheese Topping': 200,
};

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int qty = 1;

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
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              SoundService.playClick();
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
              );
            },
            child: Text(
              'Go To Cart',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
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
    if (item is Map) return item['longdesc'] ?? '';
    try {
      return item.longdescription ?? '';
    } catch (_) {
      return '';
    }
  }

  double _price() {
    final item = widget.foodItem;
    if (item == null) return 0;
    if (item is Map) {
      return (item['price'] is num) ? (item['price'] as num).toDouble() : 0;
    }
    try {
      return (item.price is num) ? (item.price as num).toDouble() : 0;
    } catch (_) {
      return 0;
    }
  }

//calculate total price based on base price, quantity, and any selected customisation options
  double get totalPrice {
    final base = _price();
    final extra = customizationOptions[selectedOption] ?? 0;
    return (base + extra) * qty;
  }

  @override
  Widget build(BuildContext context) {
    final img = _imagePath();
    final title = _title();
    final desc = _desc();
    final price = _price();

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // top area with back button and image rounded
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      SoundService.playClick();
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios,
                        color: colors.primary, size: 28),
                  ),
                ],
              ),
            ),

            // image card
            if (!isLandscape) ...[
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
            ],

            // white detail panel
            // ✅ White detail panel - Scrollable in landscape
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: isLandscape ? Radius.zero : const Radius.circular(28),
                  ),
                ),
                child: isLandscape
                    ? // ✅ Landscape: Scrollable content
                    SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Rating + quantity row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: colors.primary),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      SizedBox(width: 8),
                                      Text('4.0',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),

                                // Qty pill
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: colors.surface),
                                        onPressed: () => setState(() {
                                          if (qty > 1) qty--;
                                        }),
                                        splashRadius: 18,
                                      ),
                                      Text('$qty',
                                          style: TextStyle(
                                              color: colors.surface,
                                              fontWeight: FontWeight.w700)),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: colors.surface,
                                        ),
                                        onPressed: () => setState(() => qty++),
                                        splashRadius: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Title
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFFB56A2E),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Description
                            Text(
                              desc,
                              style: const TextStyle(fontSize: 13, height: 1.4),
                            ),

                            const SizedBox(height: 12),

                            // Customisation header
                            Text(
                              'Customisation',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // ✅ Horizontal scrollable chips
                            SizedBox(
                              height: 44,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: customizationOptions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final entry = customizationOptions.entries
                                      .elementAt(index);
                                  final isSelected =
                                      selectedOption == entry.key;

                                  return ChoiceChip(
                                    label: Text(
                                      entry.value == 0
                                          ? entry.key
                                          : '${entry.key} (+Rs ${entry.value.toStringAsFixed(0)})',
                                    ),
                                    selected: isSelected,
                                    selectedColor:
                                        colors.primary.withOpacity(0.9),
                                    backgroundColor: colors.surface,
                                    labelStyle: TextStyle(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onSelected: (_) {
                                      setState(
                                          () => selectedOption = entry.key);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Total price + add to cart button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Price',
                                        style:
                                            TextStyle(color: colors.onSurface)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Rs ${(totalPrice).toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: colors.onSurface),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: _addToCart,
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: colors.onSurface,
                                  ),
                                  label: Text(
                                    'Add To Cart',
                                    style: TextStyle(color: colors.onSurface),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.secondary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : // ✅ Portrait: Original scrollable layout
                    Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating + quantity row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: colors.primary),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      SizedBox(width: 8),
                                      Text('4.0',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),

                                // Qty pill
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
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
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        onPressed: () => setState(() => qty++),
                                        splashRadius: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Title
                            Text(
                              title,
                              style: const TextStyle(
                                color: Color(0xFFB56A2E),
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Description - Scrollable in portrait
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  desc,
                                  style: const TextStyle(
                                      fontSize: 13, height: 1.4),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Customisation header
                            Text(
                              'Customisation',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Horizontal scrollable chips
                            SizedBox(
                              height: 44,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: customizationOptions.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final entry = customizationOptions.entries
                                      .elementAt(index);
                                  final isSelected =
                                      selectedOption == entry.key;

                                  return ChoiceChip(
                                    label: Text(
                                      entry.value == 0
                                          ? entry.key
                                          : '${entry.key} (+Rs ${entry.value.toStringAsFixed(0)})',
                                    ),
                                    selected: isSelected,
                                    selectedColor: colors.primary,
                                    labelStyle: TextStyle(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onSelected: (_) {
                                      setState(
                                          () => selectedOption = entry.key);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Total price + add to cart button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Price',
                                        style:
                                            TextStyle(color: colors.onSurface)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Rs ${(totalPrice).toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: colors.primary),
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: _addToCart,
                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: colors.onSurface,
                                  ),
                                  label: Text(
                                    'Add To Cart',
                                    style: TextStyle(color: colors.onSurface),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
