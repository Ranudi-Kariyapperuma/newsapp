import 'package:flutter/material.dart';
import 'package:newsapp/database/db_helper.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Map<String, dynamic>>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    refreshFavorites();
  }

  void refreshFavorites() {
    favoritesFuture = DatabaseHelper.instance.getFavorites();
    setState(() {}); // Refresh UI
  }

  // Add or Remove Favorite
  void toggleFavorite(Map<String, dynamic> item) async {
    bool isFavorite = await DatabaseHelper.instance.isFavorite(item['url']);
    if (isFavorite) {
      // Remove from favorites
      await DatabaseHelper.instance.deleteFavorite(item['id']);
    } else {
      // Add to favorites
      await DatabaseHelper.instance.insertFavorite(item);
    }
    refreshFavorites(); // Refresh after toggle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      favorite['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      favorite['description'] ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: favorite['imageUrl'] != null
                        ? Image.network(
                            favorite['imageUrl'],
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.article, size: 50),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => toggleFavorite(favorite),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
