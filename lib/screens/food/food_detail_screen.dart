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
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              SoundService.playClick();
              Navigator.pop(context);
              Navigator.push(
                context,
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
    final price = _price();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: (isTablet && isLandscape)
            ? _buildTabletLandscapeLayout(size)
            : Column(children: [
                // top area with back button and image rounded
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        top: isLandscape
                            ? Radius.zero
                            : const Radius.circular(28),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Rating pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(22),
                                        border:
                                            Border.all(color: colors.primary),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
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
                                            onPressed: () =>
                                                setState(() => qty++),
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
                                  style: const TextStyle(
                                      fontSize: 13, height: 1.4),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Price',
                                            style: TextStyle(
                                                color: colors.onSurface)),
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
                                        style:
                                            TextStyle(color: colors.onSurface),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.secondary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Rating pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        borderRadius: BorderRadius.circular(22),
                                        border:
                                            Border.all(color: colors.primary),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
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
                                            onPressed: () =>
                                                setState(() => qty++),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Total Price',
                                            style: TextStyle(
                                                color: colors.onSurface)),
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
                                        style:
                                            TextStyle(color: colors.onSurface),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.primary,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
              ]),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: const Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              SizedBox(width: 8),
              Text('4.0', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () => setState(() {
                  if (qty > 1) qty--;
                }),
              ),
              Text(
                '$qty',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => setState(() => qty++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }

  Widget _buildPortraitLayout(Size size) {
    final img = _imagePath();
    final title = _title();
    final desc = _desc();

    final isTablet = size.width >= 600;

    return Column(
      children: [
        _buildBackButton(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 40 : 16,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              img,
              height: isTablet ? size.height * 0.45 : 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isTablet ? 40 : 18,
                24,
                isTablet ? 40 : 18,
                20,
              ),
              child: _buildContentColumn(title, desc),
            ),
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
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final entry = customizationOptions.entries.elementAt(index);
          final isSelected = selectedOption == entry.key;

          return ChoiceChip(
            label: Text(
              entry.value == 0
                  ? entry.key
                  : '${entry.key} (+Rs ${entry.value.toStringAsFixed(0)})',
            ),
            selected: isSelected,
            selectedColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.9),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            onSelected: (_) {
              setState(() => selectedOption = entry.key);
            },
          );
        },
      ),
    );
  }

  Widget _buildContentColumn(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopRow(),
        const SizedBox(height: 16),
        TTSText(
          text: title,
          style: const TextStyle(
            color: Color(0xFFB56A2E),
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
          buttonColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 14),
        TTSText(
          text: desc,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
          buttonColor: Theme.of(context).colorScheme.primary,
          showButton: desc.isNotEmpty,
        ),
        const SizedBox(height: 24),
        const Text(
          'Customisation',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildChips(),
        const SizedBox(height: 30),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildTabletLandscapeLayout(Size size) {
    final img = _imagePath();
    final title = _title();
    final desc = _desc();

    return Row(
      children: [
        // LEFT: BIG IMAGE
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                img,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // RIGHT: CONTENT
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(32),
            color: Colors.white,
            child: SingleChildScrollView(
              child: _buildContentColumn(title, desc),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Price', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text(
              'Rs ${totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _addToCart,
          icon: const Icon(Icons.shopping_cart_outlined),
          label: const Text('Add To Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        )
      ],
    );
  }
}
