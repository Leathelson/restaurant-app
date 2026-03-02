import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_restaurant_app/services/favorites_service.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/main.dart'; // To access languageNotifier
import '../../models/food_model.dart';
import '../food/food_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

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

  // Calculate card width based on orientation
  double _getCardWidth(double screenWidth, bool isLandscape) {
    if (isLandscape) {
      return screenWidth * 0.28; // Show 3 cards in landscape
    } else {
      return screenWidth * 0.42; // Show 2 cards in portrait
    }
  }

  // Calculate card height based on orientation
  double _getCardHeight(bool isLandscape) {
    return isLandscape ? 240 : 280;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final cardWidth = _getCardWidth(w, isLandscape);
    final cardHeight = _getCardHeight(isLandscape);
  
    
  return ValueListenableBuilder<String>(
  valueListenable: languageNotifier,
  builder: (context, value, child) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppData.trans('Restaurant') ?? 'Luxury Restaurant',
          style: TextStyle(
            color: titleColor,
            fontSize: isLandscape ? 20 : 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  SoundService.playClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const ProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                splashColor: gold.withOpacity(0.3),
                highlightColor: gold.withOpacity(0.1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: gold, width: 2),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: isLandscape ? 16 : 18,
                    backgroundImage: const AssetImage('assets/images/profile.png'),
                    backgroundColor: Colors.white,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: gold,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 24 : 16,
          vertical: isLandscape ? 12 : 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: isLandscape ? 44 : 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: gold, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        SoundService.playClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white70, size: isLandscape ? 18 : 20),
                          SizedBox(width: 8),
                          Text(
                            AppData.trans('Search Food') ?? 'Search for food...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isLandscape ? 14 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isLandscape ? 10 : 14),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 6),
              child: Text(
                AppData.trans( 'Choose_Your_Option') ?? 'Choose Your Option',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isLandscape ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(height: isLandscape ? 4 : 6),
            Wrap(
              spacing: 10,
              children: [
                _categoryChip(AppData.trans('Non Veg') ?? 'Non-Veg', 0, Colors.black87, isLandscape),
                _categoryChip(AppData.trans('Veg') ?? 'Veg', 1, Colors.red[800]!, isLandscape),
                _categoryChip(AppData.trans('Salad') ?? 'Salad', 2, goldCard, isLandscape),
              ],
            ),
            SizedBox(height: isLandscape ? 14 : 18),
            SizedBox(
              height: isLandscape ? 260 : 320,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('FoodItems')
                    .where('Category', isEqualTo: _categoryFilter)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No featured items in ${_categoryFilter.toUpperCase()}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }
                  final featuredItems = snapshot.data!.docs;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredItems.length,
                    separatorBuilder: (_, __) => SizedBox(width: isLandscape ? 12 : 14),
                    itemBuilder: (context, index) {
                      final doc = featuredItems[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final food = FoodModel.fromFirestore(data, doc.id);
                      return GestureDetector(
                        onTap: () {
                          SoundService.playClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(
                                foodItem: food,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: cardWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: gold.withOpacity(0.18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: _buildFoodImage(data['Image'], isLandscape: isLandscape),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: isLandscape ? 12 : 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (food.shortdescription.isNotEmpty)
                                        Text(
                                          food.shortdescription,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: isLandscape ? 10 : 11,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      SizedBox(height: isLandscape ? 6 : 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rs ${food.price.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              color: gold,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isLandscape ? 12 : 14,
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            child: StreamBuilder<Set<String>>(
                                              stream: FavoritesService.getFavoriteIdsStream(),
                                              builder: (context, snapshot) {
                                                final favoriteIds = snapshot.data ?? {};
                                                final isFavorite = favoriteIds.contains(food.id);
                                                return IconButton(
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: isFavorite ? Colors.red : Colors.grey,
                                                    size: isLandscape ? 16 : 18,
                                                  ),
                                                  onPressed: () async {
                                                    SoundService.playClick();
                                                    final isNowFavorite =
                                                        await FavoritesService.toggleFavorite(
                                                            food.id);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          isNowFavorite
                                                              ? 'Added to favourites'
                                                              : 'Removed from favourites',
                                                        ),
                                                        duration: const Duration(seconds: 1),
                                                      ),
                                                    );
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: isLandscape ? 14 : 18),
            Container(
              height: 4,
              width: 46,
              decoration: BoxDecoration(
                color: gold.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: isLandscape ? 10 : 12),
            Text(
              AppData.trans('Favourites') ?? 'Your Favourites',
              style: TextStyle(
                color: titleColor,
                fontSize: isLandscape ? 18 : 22,
                fontWeight: FontWeight.w800,
                fontFamily: 'serif',
              ),
            ),
            SizedBox(height: isLandscape ? 10 : 12),
            SizedBox(
              height: isLandscape ? 80 : 96,
              child: StreamBuilder<Set<String>>(
                stream: FavoritesService.getFavoriteIdsStream(),
                builder: (context, favSnapshot) {
                  if (favSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (favSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${favSnapshot.error}',
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    );
                  }
                  final favDocs = favSnapshot.data ?? {};
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('FoodItems').snapshots(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (productsSnapshot.hasError || !productsSnapshot.hasData) {
                        return Center(
                          child: Text(
                            'Error loading products',
                            style: TextStyle(color: Colors.red[700], fontSize: 12),
                          ),
                        );
                      }
                      final docs = productsSnapshot.data!.docs;
                      final doc = docs.where((d) => favDocs.contains(d.id)).toList();
                      if (doc.isEmpty) {
                        return Center(
                          child: Text(
                            'No favorites yet. Tap the heart icon to add some!',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          final data = doc[index].data() as Map<String, dynamic>;
                          final food = FoodModel.fromFirestore(data, doc[index].id);
                          return Container(
                            width: isLandscape ? w * 0.35 : w * 0.6,
                            padding: EdgeInsets.symmetric(
                              horizontal: isLandscape ? 8 : 12,
                              vertical: isLandscape ? 6 : 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: gold.withOpacity(0.18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: isLandscape ? 22 : 26,
                                  backgroundImage: _getFoodImageProvider(food.image),
                                ),
                                SizedBox(width: isLandscape ? 8 : 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        food.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: isLandscape ? 12 : 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: isLandscape ? 4 : 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: isLandscape ? 14 : 16,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            food.rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: isLandscape ? 11 : 12,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  );
  }

  Widget _buildFoodImage(String? imagePath, {required bool isLandscape}) {
    final height = isLandscape ? 130.0 : 160.0;
    if (imagePath == null) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey[100],
        child: Icon(Icons.restaurant, size: isLandscape ? 40 : 48, color: Colors.grey),
      );
    }
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) {
          return progress == null
              ? child
              : const Center(child: CircularProgressIndicator());
        },
      );
    }
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[50],
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: _buildImageWidget(imagePath),
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    final isNetwork = path.startsWith('http');
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.white),
        isNetwork
            ? Image.network(
                path,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                loadingBuilder: (ctx, child, progress) {
                  return progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              )
            : Image.asset(
                path,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              ),
      ],
    );
  }

  ImageProvider _getFoodImageProvider(String? imagePath) {
    if (imagePath == null) {
      return const AssetImage('assets/images/placeholder.png');
    }
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    return AssetImage(imagePath);
  }

  Widget _categoryChip(String label, int idx, Color background, bool isLandscape) {
    final isSelected = selectedCategory == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 12 : 14,
          vertical: isLandscape ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? background : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : gold,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: isLandscape ? 12 : 14,
          ),
        ),
      ),
    );
  }
}
