class Post {
  final String id;
  final String title;
  final String content;
  final String date;
  final String image;
  final String category;
  final String summary;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.category,
    required this.summary,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      summary: json['summary']?.toString() ?? json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'image': image,
      'category': category,
      'summary': summary,
    };
  }
}
