class Post {
  final String title;
  final String slug;
  final String description;
  final String category;
  final String image;
  final String date;
  final String time;
  final String content;

  Post({
    required this.title,
    required this.slug,
    required this.description,
    required this.category,
    required this.image,
    required this.date,
    required this.time,
    required this.content,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}
