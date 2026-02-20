import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_restaurant_app/services/favorites_service.dart';
import 'package:luxury_restaurant_app/services/sound_service.dart';
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
  int selectedCategory = 0; // 0: Non-Veg, 1: Veg, 2: Salad

  // Map category index to Firestore filter value
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Luxury Restaurant',
          style: TextStyle(
            color: titleColor,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundImage: const AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.grey[200],
            ),
            onPressed: () {
              SoundService.playClick(); // Play click sound when profile icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search row (unchanged)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: gold, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        SoundService.playClick(); // Play click sound when search bar is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SearchScreen()),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Category chips (unchanged logic)
            Wrap(
              spacing: 10,
              children: [
                _categoryChip('Non-Veg', 0, Colors.black87),
                _categoryChip('Veg', 1, Colors.red[800]!),
                _categoryChip('Salad', 2, goldCard),
              ],
            ),

            const SizedBox(height: 18),

            //  Featured FoodModels -FIREBASE
            SizedBox(
              height: 280,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('FoodItems')
                    .where('Category', isEqualTo: _categoryFilter)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    );
                  }

                  // Empty state
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No featured items in ${_categoryFilter.toUpperCase()}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  // Data ready - map to your UI
                  final featuredItems = snapshot.data!.docs;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final doc = featuredItems[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final food = FoodModel.fromFirestore(data, doc.id);

                      return GestureDetector(
                          onTap: () {
                            SoundService.playClick(); // Play click sound when food item is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodDetailScreen(
                                  foodItem: food, // Pass real Firebase data
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: w * 0.56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: gold.withOpacity(0.18)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                    child: _buildFoodImage(data['Image']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 12, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          food.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (food.shortdescription.isNotEmpty)
                                          Text(
                                            food.shortdescription,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Rs ${food.price.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                color: gold,
                                                fontWeight: FontWeight.bold,
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
                                              padding: const EdgeInsets.all(3),
                                              child: StreamBuilder<Set<String>>(
                                                //Listen to favorites stream for real-time state
                                                stream: FavoritesService.getFavoriteIdsStream(),
                                                builder: (context, snapshot) {
                                                  final favoriteIds = snapshot.data ?? {};
                                                  final isFavorite = favoriteIds.contains(food.id);

                                                  return IconButton(
                                                    icon: Icon(
                                                      //Filled heart if favorited, outlined if not
                                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                                      color: isFavorite ? Colors.red : Colors.grey,
                                                      size: 18,
                                                    ),
                                                    onPressed: () async {
                                                      SoundService.playClick(); // Play click sound on tap
                                                      //Toggle and get the new state
                                                      final isNowFavorite = await FavoritesService.toggleFavorite(food.id);
                                                      
                                                      // Show  message
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
                          ));
                    },
                  );
                },
              ),
            ),

const SizedBox(height: 18),

// Divider accent
Container(
  height: 4,
  width: 46,
  decoration: BoxDecoration(
    color: gold.withOpacity(0.9),
    borderRadius: BorderRadius.circular(4),
  ),
),

const SizedBox(height: 12),

            //  Favourites Header
           Text(
              'Favourites',
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Favourites List
            SizedBox(
              height: 96,
              child: StreamBuilder<Set<String>>(
                stream: FavoritesService.getFavoriteIdsStream(), // Real-time favorites
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}', 
                          style: TextStyle(color: Colors.red[700], fontSize: 12)),
                    );
                  }

                  // ✅ Data ready - build list
                  final favDocs = snapshot.data ?? {};

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('FoodItems').snapshots(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (productsSnapshot.hasError || !productsSnapshot.hasData) {
                        return Center(
                          child: Text('Error loading products', 
                              style: TextStyle(color: Colors.red[700], fontSize: 12)),
                        );
                      }
                      
                      final docs = productsSnapshot.data!.docs;
                      final doc = docs
                      .where((doc) => favDocs.contains(doc.id))
                      .toList();

                      if (doc.isEmpty) {
                        return Center(
                          child: Text(
                            'No favorites yet. Tap the heart icon to add some!',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        );
                      }

                      //building list
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          final data = doc[index].data() as Map<String, dynamic>;
                          final food = FoodModel.fromFirestore(data, doc[index].id);

                      
                      
                      return Container(
                        width: w * 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
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
                              radius: 26,
                              backgroundImage: _getFoodImageProvider(food.image),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    food.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 16, color: Colors.amber),
                                      const SizedBox(width: 6),
                                      Text(
                                        food.rating.toStringAsFixed(1),
                                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                      )
                                    ],
                                  ),
                                ]
                              )
                            )
                          ]
                        )
                      );
                      }
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
    
                      

  // Helper: Build image widget (supports asset or network)
  Widget _buildFoodImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        height: 160,
        width: double.infinity,
        color: Colors.grey[100],
        child: const Icon(Icons.restaurant, size: 48, color: Colors.grey),
      );
    }
    if (imagePath.startsWith('http')) {
      return Image.network(imagePath, height: 160, fit: BoxFit.cover,
          loadingBuilder: (ctx, child, progress) {
        return progress == null
            ? child
            : const Center(child: CircularProgressIndicator());
      });
    }
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey[50], // Light background for empty areas
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: _buildImageWidget(imagePath),
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    final isNetwork = path.startsWith('http');

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background color
        Container(color: Colors.white),

        // Image centered and contained
        isNetwork
            ? Image.network(
                path,
                fit: BoxFit.contain, // Shows entire image, centered
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
                fit: BoxFit.contain, // Shows entire image, centered
                alignment: Alignment.center,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              ),
      ],
    );
  }

  // Helper: Get ImageProvider for CircleAvatar
  ImageProvider _getFoodImageProvider(String? imagePath) {
    if (imagePath == null) {
      return const AssetImage('assets/images/placeholder.png');
    }
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    return AssetImage(imagePath);
  }

  // Category chip widget (unchanged)
  Widget _categoryChip(String label, int idx, Color background) {
    final isSelected = selectedCategory == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          ),
        ),
      ),
    );
  }
}
