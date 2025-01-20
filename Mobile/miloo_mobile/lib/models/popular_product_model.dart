class PopularProductModel {
  final int id;
  final String title;
  final double price;
  final String? image;
  bool isFavorite;

  PopularProductModel({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    this.isFavorite = false,
  });

  factory PopularProductModel.fromJson(Map<String, dynamic> json) {
    return PopularProductModel(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      price: double.parse(json['price'].toString()),
      image: json['image'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'price': price.toString(),
      'image': image,
      'isFavorite': isFavorite,
    };
  }
}
