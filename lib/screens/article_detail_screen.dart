import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'] ?? 'Article Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(article['title'] ?? 'No Title', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8.0),
            Text('Published at: ${article['publishedAt'] ?? 'Unknown'}'),
            const SizedBox(height: 8.0),
            Text(article['description'] ?? 'No Description'),
            const SizedBox(height: 8.0),
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : const SizedBox.shrink(),

                
          ],
        ),
      ),
    );
  }
}
