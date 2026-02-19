import '../models/food_model.dart';

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


class CartItem {
  FoodModel food;
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
  static User currentUser = User(name: "William Dafuk", email: "william@dafuk.com");
  static List<CartItem> cart = [];
  static List<Order> orders = [];
  static List<Reservation> reservations = [];
  static String selectedLanguage = "English";


  static List<String> categories = ["Starters", "Non-Veg", "Desserts", "Beverages"];
  
  
  //have a static list of food items to be used across the app
  //Favourites is required

}
