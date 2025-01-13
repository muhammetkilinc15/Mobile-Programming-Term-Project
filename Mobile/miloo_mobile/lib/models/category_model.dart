class CategoryModel {
  final String name;
  final int id;

  CategoryModel({required this.name, required this.id});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? 'Unknown', // Eğer 'name' null ise 'Unknown' kullan
      id: json['id'] ?? 0, // Eğer 'id' null ise 0 kullan
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
