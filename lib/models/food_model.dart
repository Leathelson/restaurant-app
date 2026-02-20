import '../services/favorites_service.dart';

class FoodModel {
  final String id;
  final String image;
  final String name;
  final String shortdescription;
  final String longdescription;
  final double rating;
  final String category;
  final double price;
  bool isFavorite;

  FoodModel({
    required this.id,
    required this.image,
    required this.name,
    required this.shortdescription,
    required this.longdescription,
    required this.rating,
    required this.category,
    required this.price,
    this.isFavorite = false,
  });

  // Create FoodModel from Firebase Document
  factory FoodModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return FoodModel(
      id: documentId,
      name: data['Name'] ?? 'No Name',
      image: data['Image'] ?? '',
      shortdescription: data['ShortDesc'] ?? 'No Short Description',
      longdescription: data['LongDesc'] ?? 'No Long Description',
      rating: (data['Rating'] ?? 0).toDouble(),
      category: data['Category'] ?? 'veg',
      price: (data['Price'] ?? 0).toDouble(),
      isFavorite: data['IsFavorite'] ?? false, // Read from Firestore if available
    );
  }

  FoodModel copyWith({
    String? id,
    String? image,
    String? name,
    String? shortdescription,
    String? longdescription,
    double? rating,
    String? category,
    double? price,
    bool? isFavorite,
  }) {
    return FoodModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      shortdescription: shortdescription ?? this.shortdescription,
      longdescription: longdescription ?? this.longdescription,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static Future<List<FoodModel>> getFavorites({
    required List<FoodModel> allProducts, // Pass your full product list
  }) async {
    final favoriteIds = await FavoritesService.getFavoriteIdsStream().first;
    
    // Filter allProducts to only include favorited items
    return allProducts
        .where((product) => favoriteIds.contains(product.id))
        .map((product) => product.copyWith(isFavorite: true)) // Mark as favorite
        .toList();
  }

  
  // Convert to Map for Firestore (if you need to write back)
  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'ShortDesc': shortdescription,
      'LongDesc': longdescription,
      'Rating': rating,
      'Price': price,
      'Image': image,
      'Category': category,
      'IsFavorite': isFavorite, // Optionally include this if you want to store it in Firestore
    };
  }
}