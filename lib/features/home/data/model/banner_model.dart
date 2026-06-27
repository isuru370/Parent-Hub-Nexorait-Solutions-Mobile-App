class BannerModel {
  final String title;
  final String subtitle;
  final String description;

  BannerModel({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json["title"],
      subtitle: json["subtitle"],
      description: json["description"],
    );
  }
}