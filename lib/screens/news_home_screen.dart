import 'package:flutter/material.dart';
import 'package:newsapp/services/news_api.dart';
import 'package:newsapp/database/db_helper.dart';

class NewsHomeScreen extends StatefulWidget {
  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  final List<String> categories = [
    "Business",
    "Entertainment",
    "Health",
    "Science",
    "Sports",
    "Technology",
  ];
  String selectedCategory = "Business";
  late Future<List<dynamic>> newsFuture;

  @override
  void initState() {
    super.initState();
    newsFuture = NewsApi().fetchNews(selectedCategory.toLowerCase());
  }

  void onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      newsFuture = NewsApi().fetchNews(category.toLowerCase());
    });
  }

  void _addToFavorites(Map<String, dynamic> article) async {
    await DatabaseHelper.instance.insertFavorite({
      'title': article['title'],
      'description': article['description'],
      'url': article['url'],
      'imageUrl': article['urlToImage'] ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories Slider
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => onCategoryChanged(category),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == category ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // News Articles
          Expanded(
            child: FutureBuilder(
              future: newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final articles = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            article['title'] ?? 'No Title',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            article['description'] ?? 'No Description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: article['urlToImage'] != null
                              ? Image.network(
                                  article['urlToImage'],
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.article, size: 50),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () => _addToFavorites(article),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
