class MarkedByModel {
  final int id;
  final String name;

  MarkedByModel({required this.id, required this.name});

  factory MarkedByModel.fromJson(Map<String, dynamic> json) {
    return MarkedByModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
