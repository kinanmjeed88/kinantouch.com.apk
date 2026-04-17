import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/post.dart';
import '../models/category.dart';
import '../models/about.dart';
import '../services/api_service.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Post> _allPosts = [];
  List<Post> _filteredPosts = [];
  List<Category> _categories = [];
  About? _about;
  String _selectedCategory = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final cats = await _apiService.fetchCategories();
      final posts = await _apiService.fetchAllPosts();
      final about = await _apiService.fetchAbout();
      setState(() {
        _categories = cats;
        _allPosts = posts;
        _about = about;
        _filterPosts(_selectedCategory);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterPosts(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      if (categoryId == 'all') {
        _filteredPosts = _allPosts;
      } else {
        _filteredPosts = _allPosts.where((p) => p.category == categoryId).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(_about?.siteName ?? 'TechTouch'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: _filteredPosts.isEmpty 
                      ? const Center(child: Text('لا توجد مقالات في هذا القسم'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) => _buildPostCard(_filteredPosts[index]),
                        ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2563EB)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Color(0xFF2563EB)),
                ),
                const SizedBox(height: 10),
                Text(
                  _about?.profileName ?? 'TechTouch',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _about?.siteName ?? 'kinantouch.com',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_about != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_about!.bio, style: const TextStyle(fontSize: 14)),
            ),
          const Divider(),
          const ListTile(title: Text('الأقسام', style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('الكل'),
            selected: _selectedCategory == 'all',
            onTap: () {
              _filterPosts('all');
              Navigator.pop(context);
            },
          ),
          ..._categories.map((cat) => ListTile(
            title: Text(cat.name),
            selected: _selectedCategory == cat.id,
            onTap: () {
              _filterPosts(cat.id);
              Navigator.pop(context);
            },
          )),
          const Divider(),
          const ListTile(title: Text('تواصل معنا', style: TextStyle(fontWeight: FontWeight.bold))),
          if (_about != null)
            ..._about!.social.entries.map((e) => ListTile(
              leading: const Icon(Icons.link),
              title: Text(e.key.toUpperCase()),
              onTap: () => launchUrl(Uri.parse(e.value)),
            )),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          final id = index == 0 ? 'all' : _categories[index - 1].id;
          final name = index == 0 ? 'الكل' : _categories[index - 1].name;
          final isSelected = _selectedCategory == id;
          
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ActionChip(
              label: Text(name),
              onPressed: () => _filterPosts(id),
              backgroundColor: isSelected ? const Color(0xFF2563EB) : Colors.white,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    String imageUrl = post.image;
    if (!imageUrl.startsWith('http')) {
      imageUrl = 'https://kinantouch.com/$imageUrl';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleDetailScreen(post: post)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getCategoryName(post.category),
                        style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(post.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id).name;
    } catch (e) {
      return id;
    }
  }
}
