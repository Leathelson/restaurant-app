class User {
  String name;
  String email;
  double totalSpent;
  int totalOrders;
  int loyaltyPoints;

  User({
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
  static User currentUser = User(name: "John Doe", email: "john@example.com");
  static List<CartItem> cart = [];
  static List<Order> orders = [];
  static List<Reservation> reservations = [];
  static String selectedLanguage = "English";

  static List<FoodItem> foodItems = [
    FoodItem(
      id: "1",
      name: "Truffle Risotto",
      category: "Starters",
      price: 28.99,
      image: "🍚",
      rating: 4.8,
      description: "Creamy arborio rice with black truffle shavings",
      isFavorite: true,
    ),
    FoodItem(
      id: "2",
      name: "Wagyu Beef Steak",
      category: "Non-Veg",
      price: 89.99,
      image: "🥩",
      rating: 4.9,
      description: "Premium A5 Wagyu beef, perfectly grilled",
    ),
    FoodItem(
      id: "3",
      name: "Lobster Thermidor",
      category: "Non-Veg",
      price: 65.99,
      image: "🦞",
      rating: 4.7,
      description: "Fresh lobster in rich cream sauce",
    ),
    FoodItem(
      id: "4",
      name: "Caviar Appetizer",
      category: "Starters",
      price: 45.99,
      image: "🥄",
      rating: 4.6,
      description: "Beluga caviar with traditional accompaniments",
    ),
  ];

  static List<String> categories = ["Starters", "Non-Veg", "Desserts", "Beverages"];
  
  static List<FoodItem> getFavorites() {
    return foodItems.where((item) => item.isFavorite).toList();
  }

  static List<FoodItem> getItemsByCategory(String category) {
    return foodItems.where((item) => item.category == category).toList();
  }
}
