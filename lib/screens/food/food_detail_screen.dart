import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/models/food_model.dart';
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';
import '../cart/cart_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel foodItem;
  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _goldDark = Color(0xFFB8860B);
  static const Color _maroon = Color(0xFF800000);
  static const Color _darkSlate = Color(0xFF2C3E50);

  int _quantity = 1;
  final Set<String> _selectedExtras = {'Regular'};

  // These keys MUST exist in your AppData Spanish/English maps
  final Map<String, int> _extras = {
    'Regular': 0,
    'Extra Sauce': 150,
    'Extra Cheese': 200
  };

  double get _currentUnitPrice {
    double extraTotal =
        _selectedExtras.fold(0, (sum, key) => sum + (_extras[key] ?? 0));
    return widget.foodItem.price + extraTotal;
  }

  void _handleAddToCart() {
    SoundService.playClick();
    setState(() {
      AppData.cart.add(CartItem(
        food: widget.foodItem,
        quantity: _quantity,
        unitPrice: _currentUnitPrice,
        selectedExtras: _selectedExtras.toList(),
      ));
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CartScreen()));
  }

  // Helper to fetch translation and clean whitespace
  String tr(String key) => AppData.trans(key.trim());

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    // We translate the key FIRST, then capitalize
    String translated = tr(text);
    return translated[0].toUpperCase() + translated.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imgPath =
        'assets/images/FoodItems/${widget.foodItem.image.split('/').last}';
    final detail = AppData.getDishDetail(widget.foodItem.name);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomActionPanel(),
      body: Stack(
        children: [
          // Header Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Image.asset(imgPath, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.32),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: screenHeight * 0.68),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    tr(widget.foodItem.name).toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'serif',
                                        color: _darkSlate)),
                              ),
                              _buildStepper(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // FIX: Wrapped longdescription in tr()
                          Text(tr(widget.foodItem.longdescription),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'serif',
                                  color: Colors.grey[800],
                                  height: 1.5)),
                          const SizedBox(height: 20),
                          if (detail != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: _buildInfo(
                                        Icons.restaurant,
                                        'lbl_ingredients',
                                        detail.ingredientKeys
                                            .map((e) => tr(e))
                                            .join(', '),
                                        _goldDark)),
                                const SizedBox(width: 15),
                                Expanded(
                                    child: _buildInfo(
                                        Icons.warning_amber,
                                        'lbl_allergens',
                                        detail.allergenKeys
                                            .map((e) => tr(e))
                                            .join(', '),
                                        _maroon)),
                              ],
                            ),
                          const SizedBox(height: 25),
                          // FIX: Translated 'CUSTOMISATION' header
                          Text(tr('lbl_customisation').toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'serif',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1)),
                          ..._extras.keys.map((name) =>
                              _buildSelectionRow(name, _extras[name]!)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                    color: Colors.black45, shape: BoxShape.circle),
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(-1, 0),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData icon, String titleKey, String items, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(tr(titleKey).toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
                color: color))
      ]),
      Text(items,
          style: const TextStyle(
              fontSize: 12, fontFamily: 'serif', color: Colors.grey)),
    ]);
  }

  Widget _buildSelectionRow(String name, int price) {
    bool isSelected = _selectedExtras.contains(name);
    return InkWell(
      onTap: () => setState(() {
        if (name == 'Regular') {
          _selectedExtras.clear();
          _selectedExtras.add('Regular');
        } else {
          _selectedExtras.remove('Regular');
          isSelected ? _selectedExtras.remove(name) : _selectedExtras.add(name);
          if (_selectedExtras.isEmpty) _selectedExtras.add('Regular');
        }
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? _gold : Colors.grey[300], size: 18),
            const SizedBox(width: 10),
            // FIX: name is now translated inside _capitalizeFirst
            Text(_capitalizeFirst(name),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'serif',
                    color: isSelected ? _darkSlate : Colors.grey[700])),
            const Spacer(),
            if (price > 0)
              Text('+Rs $price',
                  style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      color: _goldDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFB8860B),
          borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        IconButton(
            onPressed: () => setState(() => _quantity > 1 ? _quantity-- : null),
            icon: const Icon(Icons.remove, color: Colors.white, size: 16)),
        Text('$_quantity',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'serif',
                fontWeight: FontWeight.bold)),
        IconButton(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add, color: Colors.white, size: 16)),
      ]),
    );
  }

  Widget _buildBottomActionPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 12, 25, 25),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
          ]),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FIX: Translated 'TOTAL PRICE' label
                  Text(tr('lbl_total_price').toUpperCase(),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.bold)),
                  Text(
                      'Rs ${(_currentUnitPrice * _quantity).toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w900,
                          color: _goldDark)),
                ]),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: _darkSlate,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _handleAddToCart,
                // FIX: Translated 'ADD TO CART' button
                child: Text(tr('lbl_add_to_cart').toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
