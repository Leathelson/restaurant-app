import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/food_model.dart';
import '../../models/app_data.dart';
import '../food/food_detail_screen.dart';
import 'package:luxury_restaurant_app/main.dart'; // for languageNotifier

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<FoodModel> _searchResults = [];
  List<FoodModel> _allFood = [];
  bool _isLoading = true;

  // Palette
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _goldText = Color(0xFFB8860B);
  static const Color _darkSlate = Color(0xFF34495E);
  static const Color _deepRed = Color(0xFF6B0000);
  static const Color _darkGold = Color(0xFFB8860B);

  late VoidCallback _langListener;

  @override
  void initState() {
    super.initState();
    _loadAllFood();

    // Listen for language changes to update search results immediately
    _langListener = () {
      if (mounted) {
        setState(() {
          _performSearch(_searchController.text);
        });
      }
    };
    languageNotifier.addListener(_langListener);
  }

  @override
  void dispose() {
    languageNotifier.removeListener(_langListener);
    _searchController.dispose();
    super.dispose();
  }

  // ── Translation helper ────────────────────────────────────────────────────
  String tr(String key) {
    final v = AppData.trans(key);
    if (v.isEmpty) return key;
    return v[0].toUpperCase() + v.substring(1);
  }

  // ── Translated food name ──────────────────────────────────────────────────
  String _displayName(FoodModel item) {
    final key = item.name.toLowerCase().trim();
    final translated = AppData.trans(key);
    if (translated.isEmpty || translated == key) {
      return item.name[0].toUpperCase() + item.name.substring(1);
    }
    return translated[0].toUpperCase() + translated.substring(1);
  }

  // ── Load all food from Firestore ──────────────────────────────────────────
  Future<void> _loadAllFood() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('FoodItems').get();
      if (mounted) {
        setState(() {
          _allFood = snapshot.docs
              .map((doc) => FoodModel.fromFirestore(doc.data(), doc.id))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Search loading error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Search Logic (Fixed) ──────────────────────────────────────────────────
  void _performSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() {
      _searchResults = _allFood.where((item) {
        // 1. Search in the raw Database name
        final rawName = item.name.toLowerCase();

        // 2. Search in the translated name (the one the user actually sees)
        final translatedName =
            AppData.trans(item.name.toLowerCase()).toLowerCase();

        // 3. Search in the Category (just in case)
        final category = item.category.toLowerCase();

        return rawName.contains(q) ||
            translatedName.contains(q) ||
            category.contains(q);
      }).toList();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: _gold),
        title: Text(
          tr('search_hint'),
          style: const TextStyle(
            color: _gold,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _gold))
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _searchResults.isEmpty &&
                          _searchController.text.isNotEmpty
                      ? _buildEmptyState(false) // No results found
                      : _searchController.text.isEmpty
                          ? _buildEmptyState(true) // Initial state (empty)
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: _searchResults.length,
                              itemBuilder: (_, i) =>
                                  _buildResultCard(_searchResults[i]),
                            ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: _performSearch,
        cursorColor: _gold,
        style: const TextStyle(
            color: Colors.white, fontFamily: 'serif', fontSize: 16),
        decoration: InputDecoration(
          hintText: tr('search_food'),
          hintStyle: const TextStyle(
              color: Colors.white70, fontFamily: 'serif', fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          filled: true,
          fillColor: _darkSlate,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: _gold.withOpacity(0.5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: _gold.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: _gold, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(FoodModel item) {
    final String imgAsset =
        'assets/images/FoodItems/${item.image.split('/').last}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: _gold.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailScreen(foodItem: item)),
        ),
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _gold, width: 1.5)),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(imgAsset),
          ),
        ),
        title: Text(
          _displayName(item),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'serif'),
        ),
        subtitle: Row(
          children: [
            Text(
              'Rs ${item.price.toStringAsFixed(0)}',
              style: const TextStyle(
                  color: _goldText, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios_rounded, color: _gold, size: 16),
      ),
    );
  }

  Widget _buildEmptyState(bool isInitial) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isInitial ? Icons.search : Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            isInitial ? tr('search_hint') : tr('no_results'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
    );
  }
}
