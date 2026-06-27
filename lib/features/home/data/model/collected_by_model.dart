class CollectedByModel {
  final int id;
  final String name;

  CollectedByModel({
    required this.id,
    required this.name,
  });

  factory CollectedByModel.fromJson(Map<String, dynamic> json) {
    return CollectedByModel(
      id: json["id"],
      name: json["name"],
    );
  }
}