import 'package:flutter/material.dart';
import 'food_model.dart';

// --- SUPPORTING DATA MODELS ---

class CartItem {
  final FoodModel food;
  int quantity;
  CartItem({required this.food, this.quantity = 1});
}

class Order {
  final String id;
  final String status;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Order({
    required this.id,
    required this.status,
    required this.items,
    required this.total,
    required this.date,
  });
}

class User {
  String name;
  String email;
  int loyaltyPoints;
  User({required this.name, required this.email, this.loyaltyPoints = 0});
}

class Reservation {
  final String id;
  final DateTime date;
  final String time;
  final int guests;
  final String status;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });
}

// --- MAIN APP DATA STORAGE & TRANSLATION ---

class AppData {
  static List<CartItem> cart = [];
  static List<Order> orders = [];
  static List<Reservation> reservations = [];
  static User currentUser = User(
    name: "Guest User",
    email: "guest@example.com",
    loyaltyPoints: 150,
  );

  static String selectedLanguage = 'es';

  static final Map<String, Map<String, String>> translations = {
    'en': {
      'Restaurant': 'Luxury Restaurant',
      'Search Food': 'Search for food...',
      'Non Veg': 'Non-Veg',
      'Veg': 'Veg',
      'Salad': 'Salad',
      'Favourites': 'Your Favourites',
      'No items': 'No items found in this category',
      'No favourites yet': 'No favorites added yet',
      'app_title': 'Luxury Restaurant',
      'search_hint': 'Search for food...',
      'cat_non_veg': 'Non-Veg',
      'cat_veg': 'Veg',
      'cat_salad': 'Salad',
      'favourites': 'Your Favourites',
      'no_items': 'No items found',
      'no_fav_yet': 'No favorites added yet',
      'login': 'Login',
      'register': 'Sign Up',
    },
    'es': {
      'Restaurant': 'Restaurante de Lujo',
      'Search Food': 'Buscar comida...',
      'Non Veg': 'No-Vegetariano',
      'Veg': 'Vegetariano',
      'Salad': 'Ensalada',
      'Favourites': 'Sus Favoritos',
      'No items': 'No se encontraron artículos',
      'No favourites yet': 'Aún no hay favoritos',
      'app_title': 'Restaurante de Lujo',
      'search_hint': 'Buscar comida...',
      'cat_non_veg': 'No-Vegetariano',
      'cat_veg': 'Vegetariano',
      'cat_salad': 'Ensalada',
      'favourites': 'Sus Favoritos',
      'no_items': 'No se encontraron artículos',
      'no_fav_yet': 'Aún no hay favoritos',
      'login': 'Iniciar Sesión',
      'register': 'Registrarse',
      'grilled sirloin steak': 'Solomillo de Ternera a la Parrilla',
      'beluga caviar': 'Caviar Beluga Imperial',
      'east coast citrus garlic': 'Ajo Cítrico del Atlántico',
      'wagyu a5 steak': 'Corte de Wagyu A5 de Kobe',
    },
    'fr': {
      'Restaurant': 'Restaurant de Luxe',
      'Search Food': 'Rechercher...',
      'Non Veg': 'Non-Végé',
      'Veg': 'Végé',
      'Salad': 'Salade',
      'Favourites': 'Vos Favoris',
      'No items': 'Aucun article trouvé',
      'No favourites yet': 'Pas encore de favoris',
      'app_title': 'Restaurant de Luxe',
      'search_hint': 'Rechercher...',
      'cat_non_veg': 'Non-Végé',
      'cat_veg': 'Végé',
      'cat_salad': 'Salade',
      'favourites': 'Vos Favoris',
      'no_items': 'Aucun article trouvé',
      'no_fav_yet': 'Pas encore de favoris',
      'login': 'Connexion',
      'register': 'S\'inscrire',
      'grilled sirloin steak': 'Surlonge de Boeuf Grillé',
      'beluga caviar': 'Caviar Beluga',
      'east coast citrus garlic': 'Ajo Cítrico del Atlántico',
      'east coast: citrus garlic': 'Ajo Cítrico del Atlántico',
      'east coast  citrus garlic': 'Ajo Cítrico del Atlántico',
      'east coast citrusgarlic': 'Ajo Cítrico del Atlántico',
      'wagyu a5 steak': 'Steak de Wagyu A5'
    }
  };

  static String trans(String key) {
    String cleanKey = key.toLowerCase().trim();

    // DEBUG PRINT: Open your "Debug Console" in VS Code to see this!
    print(
        "Looking for translation key: '$cleanKey' in language: $selectedLanguage");

    if (translations[selectedLanguage] != null &&
        translations[selectedLanguage]![cleanKey] != null) {
      return translations[selectedLanguage]![cleanKey]!;
    }

    return key; // Returns original if not found
  }
}
