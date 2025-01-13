class UserProductsModel {
  final int id;
  final String title;
  final bool isSold;
  final double price;
  final String image;

  UserProductsModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.isSold = false,
  });

  factory UserProductsModel.fromJson(Map<String, dynamic> json) {
    return UserProductsModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      isSold: json['isSold'],
    );
  }
}
