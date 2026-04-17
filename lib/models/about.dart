class About {
  final String profileName;
  final String bio;
  final String siteName;
  final Map<String, String> social;

  About({required this.profileName, required this.bio, required this.siteName, required this.social});

  factory About.fromJson(Map<String, dynamic> json) {
    Map<String, String> soc = {};
    if (json['social'] != null) {
      (json['social'] as Map).forEach((k, v) => soc[k.toString()] = v.toString());
    }
    return About(
      profileName: json['profileName']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      siteName: json['siteName']?.toString() ?? 'TechTouch',
      social: soc,
    );
  }
}
