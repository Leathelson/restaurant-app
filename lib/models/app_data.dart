class AppUser {
  String name;
  String email;
  double totalSpent;
  int totalOrders;
  int loyaltyPoints;

  AppUser({
    required this.name,
    required this.email,
    this.totalSpent = 0.0,
    this.totalOrders = 0,
    this.loyaltyPoints = 0,
  });
}

class FoodItem {
  String id;
  String name;
  String category;
  double price;
  String image;
  double rating;
  String description;
  bool isFavorite;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.description,
    this.isFavorite = false,
  });
}

class CartItem {
  FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class Order {
  String id;
  List<CartItem> items;
  double total;
  DateTime date;
  String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });
}

class Reservation {
  String id;
  DateTime date;
  String time;
  int guests;
  String status;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
  });
}

class AppData {
  static AppUser currentUser =
      AppUser(name: "William Dafuk", email: "william@dafuk.com");
  static List<CartItem> cart = [];
  static List<Order> orders = [];
  static List<Reservation> reservations = [];
  static String selectedLanguage = "English";

  static List<FoodItem> foodItems = [
    FoodItem(
      id: "1",
      name: "Grilled Sirloin Steak",
      category: "Starters",
      price: 1200.00,
      image: "assets/images/food1.png",
      rating: 4.8,
      description:
          "MEAT LOVERS DELIGHT! Juicy grilled sirloin steak with herbs",
      isFavorite: true,
    ),
    FoodItem(
      id: "2",
      name: "East Coast Citrus-Garlic",
      category: "Non-Veg",
      price: 1000.00,
      image: "assets/images/food2.png",
      rating: 4.9,
      description: "East Coast style citrus-garlic shrimp platter",
    ),
    // FoodItem(
    //   id: "3",
    //   name: "Lobster Thermidor",
    //   category: "Non-Veg",
    //   price: 65.99,
    //   image: "🦞",
    //   rating: 4.7,
    //   description: "Fresh lobster in rich cream sauce",
    // ),
    // FoodItem(
    //   id: "4",
    //   name: "Caviar Appetizer",
    //   category: "Starters",
    //   price: 45.99,
    //   image: "🥄",
    //   rating: 4.6,
    //   description: "Beluga caviar with traditional accompaniments",
    // ),
  ];

  static List<String> categories = [
    "Starters",
    "Non-Veg",
    "Desserts",
    "Beverages"
  ];

  static List<FoodItem> getFavorites() {
    return foodItems.where((item) => item.isFavorite).toList();
  }

  static List<FoodItem> getItemsByCategory(String category) {
    return foodItems.where((item) => item.category == category).toList();
  }
}
