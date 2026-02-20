import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
 static String get _userId => FirebaseAuth.instance.currentUser?.uid ?? 'guest';

static Stream<Set<String>> getFavoriteIdsStream() {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(_userId)
      .collection('Favorites')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
}

static Future<bool> toggleFavorite(String foodId) async {
  final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(_userId)
      .collection('Favorites')
      .doc(foodId);
  
  final doc = await ref.get();
  if (doc.exists) {
    await ref.delete();
    return false; // Now not a favorite
  } else {
    await ref.set({'addedAt': FieldValue.serverTimestamp()});
    return true; // Now a favorite
  }
}

  static Future<bool> isFavorite(String foodId) async {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('Favorites')
        .doc(foodId);
    
    final doc = await ref.get();
    return doc.exists;
  }
}