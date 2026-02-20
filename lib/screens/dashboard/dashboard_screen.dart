import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_restaurant_app/services/favorites_service.dart';
import '../../models/app_data.dart';
import '../../models/food_model.dart';
import '../food/food_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../../main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedCategory = 0;

  String get _categoryFilter {
    switch (selectedCategory) {
      case 0:
        return 'NonVeg';
      case 1:
        return 'Veg';
      case 2:
        return 'Salad';
      default:
        return 'NonVeg';
    }
  }

  Color get titleColor => const Color(0xFFB56A2E);
  Color get gold => const Color(0xFFB37C1E);
  Color get goldCard => const Color(0xFF906224);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<String>(
      valueListenable: languageNotifier,
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              AppData.trans('app_title'),
              style: TextStyle(
                color: titleColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                fontFamily: 'serif',
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      const AssetImage('assets/images/profile.png'),
                  backgroundColor: Colors.grey[200],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const ProfileScreen()),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  children: [
                    _categoryChip(
                        AppData.trans('cat_non_veg'), 0, Colors.black87),
                    _categoryChip(
                        AppData.trans('cat_veg'), 1, Colors.red[800]!),
                    _categoryChip(AppData.trans('cat_salad'), 2, goldCard),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 280,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('FoodItems')
                        .where('Category', isEqualTo: _categoryFilter)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            AppData.trans('no_items'),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      }

                      final featuredItems = snapshot.data!.docs;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final doc = featuredItems[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final food = FoodModel.fromFirestore(data, doc.id);
                          return _buildFoodCard(context, food, data, w);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  AppData.trans('favourites'),
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFavoritesSection(w),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: gold, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (c) => const SearchScreen())),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              AppData.trans('search_hint'),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(double w) {
    return SizedBox(
      height: 96,
      child: StreamBuilder<Set<String>>(
        stream: FavoritesService.getFavoriteIdsStream(),
        builder: (context, favSnapshot) {
          final favIds = favSnapshot.data ?? {};
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('FoodItems').snapshots(),
            builder: (context, prodSnapshot) {
              if (!prodSnapshot.hasData) return const SizedBox();
              final favItems = prodSnapshot.data!.docs
                  .where((d) => favIds.contains(d.id))
                  .toList();

              if (favItems.isEmpty) {
                return Center(
                  child: Text(
                    AppData.trans('no_fav_yet'),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: favItems.length,
                itemBuilder: (context, index) {
                  final food = FoodModel.fromFirestore(
                      favItems[index].data() as Map<String, dynamic>,
                      favItems[index].id);
                  return _buildFavoriteCircleItem(food, w);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _categoryChip(String label, int idx, Color background) {
    final isSelected = selectedCategory == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? background : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: isSelected ? Colors.transparent : gold, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodModel food,
      Map<String, dynamic> data, double w) {
    // UPDATED REGEX: Removes punctuation but PRESERVES spaces (\s)
    String cleanName = food.name
        .toLowerCase()
        .replaceAll(
            RegExp(r'[^\w\s]'), '') // Remove special chars but keep space
        .replaceAll(RegExp(r'\s+'), ' ') // Collapse multiple spaces to one
        .trim();

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(foodItem: food))),
      child: Container(
        width: w * 0.56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: gold.withOpacity(0.18)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: _buildFoodImage(data['Image']),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppData.trans(cleanName),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppData.trans('rs')} ${food.price.toStringAsFixed(0)}',
                        style:
                            TextStyle(color: gold, fontWeight: FontWeight.bold),
                      ),
                      _buildFavoriteButton(food),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(FoodModel food) {
    return StreamBuilder<Set<String>>(
      stream: FavoritesService.getFavoriteIdsStream(),
      builder: (context, snapshot) {
        final isFavorite = (snapshot.data ?? {}).contains(food.id);
        return IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey, size: 20),
          onPressed: () => FavoritesService.toggleFavorite(food.id),
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        );
      },
    );
  }

  Widget _buildFavoriteCircleItem(FoodModel food, double w) {
    // UPDATED REGEX: Matches the food card logic
    String cleanName = food.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: w * 0.6,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: gold.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 26, backgroundImage: _getFoodImageProvider(food.image)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppData.trans(cleanName),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodImage(String? path) {
    if (path == null)
      return Container(
          height: 160,
          color: Colors.grey[200],
          child: const Icon(Icons.restaurant));
    return path.startsWith('http')
        ? Image.network(path,
            height: 160, width: double.infinity, fit: BoxFit.cover)
        : Image.asset(path,
            height: 160, width: double.infinity, fit: BoxFit.cover);
  }

  ImageProvider _getFoodImageProvider(String? path) {
    if (path == null) return const AssetImage('assets/images/placeholder.png');
    return path.startsWith('http')
        ? NetworkImage(path)
        : AssetImage(path) as ImageProvider;
  }
}
