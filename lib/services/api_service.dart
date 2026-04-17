import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/category.dart';
import '../models/about.dart';

class ApiService {
  // IMPORTANT: Replace this with your actual GitHub Personal Access Token
  // to access private repository content.
  static const String token = 'YOUR_GITHUB_TOKEN';
  
  static const String owner = 'kinanmjeed88';
  static const String repo = 'kinantouch.com';
  static const String baseUrl = 'https://api.github.com/repos/$owner/$repo/contents';

  Map<String, String> get _headers => {
    'Authorization': 'token $token',
    'Accept': 'application/vnd.github.v3+json',
  };

  Future<dynamic> _fetchFileContent(String path) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$path'), headers: _headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('content')) {
          String encoded = data['content'].toString().replaceAll('\n', '').replaceAll(' ', '');
          return json.decode(utf8.decode(base64.decode(encoded)));
        }
      }
    } catch (e) {
      print('Error fetching file $path: $e');
    }
    return null;
  }

  Future<About?> fetchAbout() async {
    final data = await _fetchFileContent('content/data/about.json');
    if (data != null) return About.fromJson(data);
    return null;
  }

  Future<List<Category>> fetchCategories() async {
    final data = await _fetchFileContent('content/data/categories.json');
    if (data != null && data is List) {
      return data.map((d) => Category.fromJson(d)).toList();
    }
    return [];
  }

  Future<List<Post>> fetchAllPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/posts'), headers: _headers);
      if (response.statusCode == 200) {
        List files = json.decode(response.body);
        List<Post> posts = [];
        for (var file in files) {
          if (file['name'].toString().endsWith('.json')) {
            final content = await _fetchFileContent('content/posts/${file['name']}');
            if (content != null) {
              posts.add(Post.fromJson(content));
            }
          }
        }
        posts.sort((a, b) => b.date.compareTo(a.date));
        return posts;
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return [];
  }
}
