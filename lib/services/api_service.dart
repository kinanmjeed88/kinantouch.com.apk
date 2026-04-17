import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/category.dart';
import '../models/about.dart';

class ApiService {
  static const String baseUrl = 'https://raw.githubusercontent.com/kinanmjeed88/kinantouch.com/main';
  static const String githubApiUrl = 'https://api.github.com/repos/kinanmjeed88/kinantouch.com/contents';

  Future<About?> fetchAbout() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/data/about.json'));
      if (response.statusCode == 200) {
        return About.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      print('Error fetching about: $e');
    }
    return null;
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/data/categories.json'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((data) => Category.fromJson(data)).toList();
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return [];
  }

  Future<List<Post>> fetchAllPosts() async {
    try {
      final response = await http.get(Uri.parse('$githubApiUrl/content/posts'));
      if (response.statusCode == 200) {
        List files = json.decode(response.body);
        List<Post> posts = [];
        for (var file in files) {
          if (file['name'].endsWith('.json')) {
            final postResp = await http.get(Uri.parse('$baseUrl/content/posts/${file['name']}'));
            if (postResp.statusCode == 200) {
              try {
                posts.add(Post.fromJson(json.decode(utf8.decode(postResp.bodyBytes))));
              } catch (e) {
                print('Error parsing post ${file['name']}: $e');
              }
            }
          }
        }
        // Sort by date descending
        posts.sort((a, b) => b.date.compareTo(a.date));
        return posts;
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return [];
  }
}
