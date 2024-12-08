import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApi {
  final String apiKey = "34b9eab5d2214e95878b0f84f44dd8ba";
  final String baseUrl = "https://newsapi.org/v2";

  // Fetch news by category (top headlines)
  Future<List<dynamic>> fetchNews(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-headlines?category=$category&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      throw Exception('Failed to fetch news');
    }
  }

  // Search news by query
  Future<List<dynamic>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'] ?? [];
    } else {
      throw Exception('Failed to search news');
    }
  }
}
