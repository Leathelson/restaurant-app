import 'package:flutter/material.dart';
import '../food/food_detail_screen.dart';
import '../../models/food_model.dart';
import '../../services/product_repository.dart';
import '../../services/favorites_service.dart';
import '../../models/app_data.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FoodModel> _favorites = [];
  bool _isLoading = true;

  // Grand Atelier Theme Colors
  final Color maroonColor = const Color(0xFF63210B);
  final Color goldColor = const Color(0xFFA67117);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final allProducts = await ProductRepository.getAllProducts();
      final favorites = await FoodModel.getFavorites(allProducts: allProducts);

      if (mounted) {
        setState(() {
          _favorites = favorites;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(FoodModel food) async {
    final isNowFavorite = await FavoritesService.toggleFavorite(food.id);
    _loadFavorites(); // Instant UI refresh

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: maroonColor,
        content: Text(AppData.trans(
            isNowFavorite ? 'Added to favorites' : 'Removed from favorites')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppData.trans('Favourites'),
          style: TextStyle(
              color: maroonColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: goldColor, size: 22),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: goldColor))
          : _favorites.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 60, color: goldColor.withOpacity(0.3)),
          const SizedBox(height: 15),
          Text(
            AppData.trans('no_fav_yet'),
            style: TextStyle(color: maroonColor.withOpacity(0.6), fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final item = _favorites[index];

        // --- Category Key Logic ---
        // database "Non Veg" -> becomes "non_veg"
        String categoryKey =
            item.category.trim().toLowerCase().replaceAll(' ', '_');
        // "non_veg" -> becomes "cat_non_veg" to match your AppData
        String fullTranslationKey = 'cat_$categoryKey';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: goldColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(item.image, size: 55),
            ),
            title: Text(
              AppData.trans(item.name.trim()),
              style: TextStyle(
                color: maroonColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppData.trans(fullTranslationKey),
                    style: TextStyle(
                        color: goldColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Rs ${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : Colors.grey,
                size: 22,
              ),
              onPressed: () => _toggleFavorite(item),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(foodItem: item),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImage(String imagePath, {double? size}) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[50],
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.restaurant, color: Colors.grey[300], size: 20);
        },
      ),
    );
  }
}
