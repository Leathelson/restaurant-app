import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Model imports
import 'package:luxury_restaurant_app/models/app_data.dart';
import 'package:luxury_restaurant_app/models/food_model.dart';

// Screen & Service imports
import 'package:luxury_restaurant_app/services/favorites_service.dart';
import 'package:luxury_restaurant_app/screens/auth/login_screen.dart';
import 'package:luxury_restaurant_app/screens/food/food_detail_screen.dart';
import 'package:luxury_restaurant_app/services/flutter_tts_service.dart';
import 'package:luxury_restaurant_app/theme/theme_provider.dart';
import 'package:luxury_restaurant_app/theme/theme.dart';

// 1. GLOBAL NOTIFIER: Controls the language state app-wide
final ValueNotifier<String> languageNotifier = ValueNotifier(
    AppData.selectedLanguage.isEmpty ? 'en' : AppData.selectedLanguage);

// The old global themeNotifier has been replaced by [ThemeProvider].
// A provider instance will be created in the widget tree.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (AppData.selectedLanguage.isEmpty) {
    AppData.selectedLanguage = 'en';
  }

  await TTSService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Provide our theme provider above the language listener so the
    // whole tree can access it.
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: ValueListenableBuilder<String>(
        valueListenable: languageNotifier,
        builder: (context, currentLanguage, child) {
          // theme information comes from the provider now
          final themeProv = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: AppData.trans('app_title'),
            theme: lightmode,
            darkTheme: darkmode,
            themeMode: themeProv.mode,
            home: const AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<auth.User?>(
      stream: auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

// =============================================================================
//  DASHBOARD SCREEN
// =============================================================================

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color _maroon = Color(0xFF800000);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _goldText = Color(0xFFB8860B);
  static const Color _darkSlate = Color(0xFF34495E);
  static const Color _deepRed = Color(0xFF6B0000);
  static const Color _heartRed = Color(0xFFE53935);

  String _selectedCategory = 'NonVeg';

  /// Translation helper with safe capitalization logic
  String tr(String key) {
    final String val = AppData.trans(key);
    if (val.isEmpty) return key;
    if (val.length < 2) return val.toUpperCase();
    return val[0].toUpperCase() + val.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          tr('app_title'),
          style: const TextStyle(
              color: _maroon, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchRow(),
            const SizedBox(height: 10),
            _buildCategoryRow(),
            const SizedBox(height: 20),
            _buildFoodSlider(),
            const SizedBox(height: 15),
            _buildGoldDivider(),
            const SizedBox(height: 10),
            _buildFavouritesSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/search'),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: _darkSlate,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _gold, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Text(tr('search_hint'),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 15)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: const CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _catBtn('NonVeg', 'cat_non_veg', _darkSlate),
          const SizedBox(width: 10),
          _catBtn('Veg', 'cat_veg', _deepRed),
          const SizedBox(width: 10),
          _catBtn('Salad', 'cat_salad', _gold),
        ],
      ),
    );
  }

  Widget _catBtn(String value, String key, Color activeColour) {
    final bool sel = _selectedCategory == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          decoration: BoxDecoration(
            color: sel ? activeColour : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: sel ? null : Border.all(color: _gold, width: 2),
          ),
          child: Center(
            child: Text(
              tr(key).toUpperCase(),
              style: TextStyle(
                  color: sel ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodSlider() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('FoodItems')
          .where('Category', isEqualTo: _selectedCategory)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData)
          return const SizedBox(
              height: 250, child: Center(child: CircularProgressIndicator()));
        final docs = snap.data!.docs;
        return StreamBuilder<Set<String>>(
          stream: FavoritesService.getFavoriteIdsStream(),
          builder: (context, favSnap) {
            final favIds = favSnap.data ?? {};
            return SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final food = FoodModel.fromFirestore(
                          docs[i].data() as Map<String, dynamic>, docs[i].id)
                      .copyWith(isFavorite: favIds.contains(docs[i].id));
                  return _foodCard(food);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _foodCard(FoodModel food) {
    final img = 'assets/images/FoodItems/${food.image.split('/').last}';
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(foodItem: food))),
      child: Container(
        width: 185,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _gold.withOpacity(0.8), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Column(
            children: [
              Image.asset(img, height: 180, width: 185, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr(food.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rs ${food.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: _goldText, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => FavoritesService.toggleFavorite(food.id),
                          child: Icon(
                              food.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: food.isFavorite ? _heartRed : Colors.grey,
                              size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(height: 1.5, width: 160, color: _gold.withOpacity(0.5)),
    );
  }

  Widget _buildFavouritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Text(tr('favourites_title'),
              style: const TextStyle(
                  color: _maroon, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        StreamBuilder<Set<String>>(
          stream: FavoritesService.getFavoriteIdsStream(),
          builder: (context, favSnap) {
            final favIds = favSnap.data ?? {};
            if (favIds.isEmpty)
              return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(tr('no_fav_yet')));
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('FoodItems')
                  .where(FieldPath.documentId, whereIn: favIds.toList())
                  .snapshots(),
              builder: (context, foodSnap) {
                if (!foodSnap.hasData) return const SizedBox(height: 110);
                final docs = foodSnap.data!.docs;
                return SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final food = FoodModel.fromFirestore(
                              docs[i].data() as Map<String, dynamic>,
                              docs[i].id)
                          .copyWith(isFavorite: true);
                      return _favTile(food);
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _favTile(FoodModel food) {
    final img = 'assets/images/FoodItems/${food.image.split('/').last}';
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _gold.withOpacity(0.8), width: 1.5),
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  Image.asset(img, width: 70, height: 70, fit: BoxFit.cover)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tr(food.name),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Rs ${food.price.toStringAsFixed(0)}',
                    style: const TextStyle(color: _goldText, fontSize: 13)),
              ],
            ),
          ),
          GestureDetector(
              onTap: () => FavoritesService.toggleFavorite(food.id),
              child: const Icon(Icons.favorite, color: _heartRed, size: 18)),
        ],
      ),
    );
  }
}
