import 'package:flutter/material.dart';
import '../food/food_detail_screen.dart';
import '../../models/food_model.dart';
import '../../services/product_repository.dart';
import '../../services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FoodModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
          // 1. Get all products from Firestore (cached)
          final allProducts = await ProductRepository.getAllProducts();
          
          // 2. Filter to only favorites using our new method
          final favorites = await FoodModel.getFavorites(allProducts: allProducts);
          
          setState(() {
            _favorites = favorites;
            _isLoading = false;
          });
        } catch (e) {
          print('Error loading favorites: $e');
          setState(() => _isLoading = false);
        }
  }

Future<void> _toggleFavorite(FoodModel food) async {
  // Toggle in Firestore
  final isNowFavorite = await FavoritesService.toggleFavorite(food.id);
  
  // Optional: Show user feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(isNowFavorite 
          ? 'Added to favorites' 
          : 'Removed from favorites'),
      duration: const Duration(seconds: 1),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          :_favorites.isEmpty
              ? _buildEmptyState()
              : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Color.fromARGB(255, 192, 177, 41)),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 110, 110, 110)),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any dish to add it here!',
            style: TextStyle(color: Color.fromARGB(255, 155, 155, 155)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
 Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final item = _favorites[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: _buildImage(item.image, size: 50),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${item.category} • Rs ${item.price.toStringAsFixed(0)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(item.rating.toStringAsFixed(1)),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: item.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(item),
                ),
              ],
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

  // Helper method to build images with proper error handling
  Widget _buildImage(String imagePath, {double? size, double? width}) {
    final displaySize = size ?? 120.0;
    
    return Container(
      width: width ?? displaySize,
      height: displaySize,
      color: Colors.grey[200],
      child: ClipRRect(
        borderRadius: size != null ? BorderRadius.circular(8) : BorderRadius.zero,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Show placeholder icon if image fails to load
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.restaurant,
                  size: displaySize * 0.4,
                  color: Colors.grey[400],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}