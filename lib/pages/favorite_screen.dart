import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> _favoriteRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoriteData = prefs.getString('favorite_restaurants');
    if (favoriteData != null) {
      setState(() {
        _favoriteRestaurants = List<Map<String, dynamic>>.from(
          json.decode(favoriteData),
        );
      });
    }
  }

  Future<void> _removeFromFavorites(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteRestaurants.removeWhere((restaurant) => restaurant['id'] == id);
    });
    prefs.setString('favorite_restaurants', json.encode(_favoriteRestaurants));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Dihapus dari Favorite"),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Favorit"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: _favoriteRestaurants.isEmpty
          ? const Center(
              child: Text(
                "Belom ada Restoran Favorit.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: _favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _favoriteRestaurants[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      restaurant['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                  title: Text(
                    restaurant['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("City: ${restaurant['city']}"),
                );
              },
            ),
    );
  }
}
