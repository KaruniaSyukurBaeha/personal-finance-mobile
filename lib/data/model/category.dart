class Category {
  final int id;
  final String name;
  final String? type;
  final String? description;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      description: json["description"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}