class PopularProductModel {
  late int id;
  late String title;
  late bool isFavorite;
  late double price;
  late String? image;

  PopularProductModel({
    required this.id,
    required this.title,
    required this.isFavorite,
    required this.price,
    this.image,
  });

  factory PopularProductModel.fromJson(Map<String, dynamic> json) {
    return PopularProductModel(
      id: json['id'],
      title: json['title'],
      isFavorite: json['isFavorite'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isFavorite': isFavorite,
      'price': price,
      'image': image,
    };
  }
}
