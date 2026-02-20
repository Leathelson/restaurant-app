import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';



//load products and share them for getfavorites()
class ProductRepository {
  static List<FoodModel>? _cachedProducts;

  static Future<List<FoodModel>> getAllProducts() async {
    if (_cachedProducts != null) return _cachedProducts!;
    
    final snapshot = await FirebaseFirestore.instance
        .collection('FoodItems')
        .get();
    
    _cachedProducts = snapshot.docs
        .map((doc) => FoodModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ))
        .toList();
    
    return _cachedProducts!;
  }

  static void clearCache() => _cachedProducts = null;
}