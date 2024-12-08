import 'package:flutter/material.dart';
import '../services/news_api.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<dynamic>> searchResults;
  late String searchQuery;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch search query from arguments
    searchQuery = ModalRoute.of(context)?.settings.arguments as String;
    _searchNews(searchQuery); // Perform the search immediately after getting query
  }

  // Function to handle search when the user types
  void _searchNews(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchResults = NewsApi().searchNews(query); // Fetch search results from the API
      });
    } else {
      setState(() {
        searchResults = Future.value([]); // Clear results if query is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final articles = snapshot.data as List<dynamic>;
                  if (articles.isEmpty) {
                    return const Center(child: Text('No results found.'));
                  }
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
