import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';
import '../../models/app_data.dart';
import '../checkout/checkout_screen.dart';
import 'package:luxury_restaurant_app/services/flutter_tts_service.dart';
import 'package:luxury_restaurant_app/widgets/tts_text.dart';

class FoodDetailScreen extends StatefulWidget {
  final dynamic foodItem;

  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int qty = 1;
  String selectedOption = 'Regular';

  final Map<String, double> customizationOptions = {
    'Regular': 0,
    'Extra Sauce': 150,
    'Cheese Topping': 200,
  };

  final TTSService _tts = TTSService.instance;

  Color get gold => const Color(0xFFB37C1E);
  Color get darkBg => const Color(0xFF2F2740);

  @override
  void initState() {
    super.initState();
    _tts.setLanguage(AppData.selectedLanguage);

    if (_tts.isEnabled) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _tts.speak('${_title()}. ${_desc()}');
        }
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _addToCart() {
    final cartItem = CartItem(food: widget.foodItem, quantity: qty);
    AppData.cart.add(cartItem);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('Item added to cart'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: darkBg),
            onPressed: () {
              SoundService.playClick();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CheckoutScreen()),
              );
            },
            child: const Text('Go To Cart'),
          ),
        ],
      ),
    );
  }

  String _imagePath() {
    final item = widget.foodItem;
    if (item is Map) {
      return item['image'] ??
          item['img'] ??
          item['imagePath'] ??
          'assets/images/food1.png';
    }
    try {
      return item.image ?? item.img ?? item.imagePath;
    } catch (_) {
      return 'assets/images/food1.png';
    }
  }

  String _title() {
    final item = widget.foodItem;
    if (item is Map) return item['name'] ?? 'Delicious Dish';
    try {
      return item.name ?? 'Delicious Dish';
    } catch (_) {
      return 'Delicious Dish';
    }
  }

  String _desc() {
    final item = widget.foodItem;
    if (item is Map) return item['longdesc'] ?? '';
    try {
      return item.longdescription ?? '';
    } catch (_) {
      return '';
    }
  }

  double _price() {
    final item = widget.foodItem;
    if (item is Map && item['price'] is num) {
      return (item['price'] as num).toDouble();
    }
    try {
      return (item.price as num).toDouble();
    } catch (_) {
      return 0;
    }
  }

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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      SoundService.playClick();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            if (!isLandscape)
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

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: isLandscape
                        ? Radius.zero
                        : const Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(),
                      const SizedBox(height: 12),

                      TTSText(
                        text: title,
                        style: const TextStyle(
                          color: Color(0xFFB56A2E),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        buttonColor: gold,
                        buttonSize: 22,
                      ),

                      const SizedBox(height: 10),

                      TTSText(
                        text: desc,
                        style: const TextStyle(
                            fontSize: 13, height: 1.4),
                        buttonColor: gold,
                        buttonSize: 18,
                        showButton: desc.isNotEmpty,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Customisation',
                        style: TextStyle(
                            fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 8),

                      _buildChips(),

                      const SizedBox(height: 20),

                      _buildBottomRow(),
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

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: gold.withOpacity(0.9), width: 2),
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
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove,
                    color: Colors.white),
                onPressed: () =>
                    setState(() {
                      if (qty > 1) qty--;
                    }),
              ),
              Text(
                '$qty',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.add,
                    color: Colors.white),
                onPressed: () =>
                    setState(() => qty++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: customizationOptions.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final entry =
              customizationOptions.entries.elementAt(index);
          final isSelected =
              selectedOption == entry.key;

          return ChoiceChip(
            label: Text(
              entry.value == 0
                  ? entry.key
                  : '${entry.key} (+Rs ${entry.value.toStringAsFixed(0)})',
            ),
            selected: isSelected,
            selectedColor: gold.withOpacity(0.9),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black,
            ),
            onSelected: (_) {
              setState(() =>
                  selectedOption = entry.key);
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text('Total Price',
                style: TextStyle(
                    color: Colors.black54)),
            const SizedBox(height: 6),
            Text(
              'Rs ${totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: gold),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _addToCart,
          icon: const Icon(
              Icons.shopping_cart_outlined),
          label: const Text('Add To Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: darkBg,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),
          ),
        )
      ],
    );
  }
}