import 'package:flutter/material.dart';
import 'package:luxury_restaurant_app/models/food_model.dart';
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/screens/food/food_detail_screen.dart';

class LuxuryDashboard extends StatefulWidget {
  final List<FoodModel> products;

  const LuxuryDashboard({super.key, required this.products});

  @override
  State<LuxuryDashboard> createState() => _LuxuryDashboardState();
}

class _LuxuryDashboardState extends State<LuxuryDashboard> {
  static const Color _maroon = Color(0xFF800000);
  static const Color _gold = Color(0xFFD4AF37);

  String formatOutput(String rawText, {bool isTitle = false}) {
    String translated = AppData.trans(rawText);
    if (translated.isEmpty) return rawText;
    String formatted = translated[0].toUpperCase() + translated.substring(1);
    if (!isTitle && !RegExp(r'[.!?]$').hasMatch(formatted)) {
      formatted += '.';
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodModel> favoriteItems =
        widget.products.where((p) => p.isFavorite).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      // ─── APP BAR ───────────────────────────────────────────────────
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          formatOutput('app_title', isTitle: true),
          style: const TextStyle(
            color: _maroon,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      // ─── BODY ──────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── SEARCH + PROFILE ROW ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  // Search bar takes all remaining space
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: formatOutput('search_hint'),
                          hintStyle: const TextStyle(
                              color: Colors.black45, fontSize: 15),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black45),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Profile picture circle — loads profile.png
                  // Make sure 'assets/images/profile.png' is in pubspec.yaml
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        const AssetImage('assets/images/profile.png'),
                    onBackgroundImageError: (_, __) {},
                  ),
                ],
              ),
            ),

            // ── CATEGORY PILLS ────────────────────────────────────────
            // ALL THREE are solid-filled — zero transparency, zero outline
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _categoryPill(
                    formatOutput('cat_non_veg'),
                    const Color(0xFF34495E), // dark slate
                  ),
                  _categoryPill(
                    formatOutput('cat_veg'),
                    const Color(0xFF6B0000), // deep maroon red ✓
                  ),
                  _categoryPill(
                    formatOutput('cat_salad'),
                    const Color(0xFFB8860B), // dark gold ✓
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── FOOD HORIZONTAL SLIDER ────────────────────────────────
            // scrollDirection: Axis.horizontal  <-- this is the key fix
            SizedBox(
              height: 265,
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // HORIZONTAL SCROLL
                padding: const EdgeInsets.only(left: 16, right: 4),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final food = widget.products[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodDetailScreen(foodItem: food),
                      ),
                    ),
                    child: _foodCard(food),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Decorative gold gradient divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _gold.withOpacity(0.1),
                      _gold.withOpacity(0.7),
                      _gold.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),

            // ── FAVOURITES HEADING ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                formatOutput('favourites_title', isTitle: true),
                style: const TextStyle(
                  color: _maroon,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),

            // ── FAVOURITES LIST ───────────────────────────────────────
            // Uses shrinkWrap + NeverScrollableScrollPhysics so it sits
            // inside the outer SingleChildScrollView without conflict
            if (favoriteItems.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  formatOutput('no_fav_yet'),
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: favoriteItems.length,
                itemBuilder: (_, i) => _favoriteTile(favoriteItems[i]),
              ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // ─── SOLID CATEGORY PILL ────────────────────────────────────────────
  Widget _categoryPill(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      // color is the ONLY decoration — no border, no outline, no gradient
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ─── FOOD CARD ──────────────────────────────────────────────────────
  Widget _foodCard(FoodModel food) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image: fixed height, centre-aligned crop — consistent for all cards
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              width: 180,
              height: 130,
              child: Image.asset(
                food.image,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name wraps to 2 lines — never bleeds into price
                Text(
                  formatOutput(food.name, isTitle: true),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                // Price + favourite icon in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rs ${food.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: _maroon,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(
                      food.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: food.isFavorite ? _maroon : Colors.grey[400],
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── FAVOURITE TILE ─────────────────────────────────────────────────
  Widget _favoriteTile(FoodModel food) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image: fixed square crop for all tiles
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 62,
              height: 62,
              child: Image.asset(
                food.image,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Text expands, name wraps fully before price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatOutput(food.name, isTitle: true),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rs ${food.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Color(0xFFB37C1E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.favorite, color: _maroon, size: 20),
        ],
      ),
    );
  }
}
