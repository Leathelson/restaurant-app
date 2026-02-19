import 'package:flutter/services.dart';

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

  static List<FoodModel> getFavorites() {
    return [
      FoodModel(
        id: 'placeholder_1',
        name: 'Grilled Sirloin Steak',
        image: 'assets/images/FoodItems/Grilled_Sirloin_Steak.png',
        shortdescription: 'Perfectly seared premium steak',
        longdescription: 'A juicy, tender sirloin steak grilled to perfection with herbs and garlic butter.',
        rating: 4.8,
        category: 'NonVeg',
        price: 1200,
        isFavorite: true,
      ),
      FoodModel(
        id: 'placeholder_2',
        name: 'East Coast Citrus-Garlic',
        image: 'assets/images/FoodItems/East_Coast_Citrus-Garlic.png',
        shortdescription: 'Fresh citrus with garlic infusion',
        longdescription: 'A light and flavorful dish featuring fresh citrus notes with aromatic garlic.',
        rating: 4.5,
        category: 'Veg',
        price: 1000,
        isFavorite: true,
      ),
      FoodModel(
        id: 'placeholder_3',
        name: 'Garden Fresh Salad',
        image: 'assets/images/FoodItems/Garden_Fresh_Salad.png',
        shortdescription: 'Crisp greens with house dressing',
        longdescription: 'A refreshing mix of seasonal vegetables tossed with our signature vinaigrette.',
        rating: 4.3,
        category: 'Salad',
        price: 450,
        isFavorite: true,
      ),
    ];
  }

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