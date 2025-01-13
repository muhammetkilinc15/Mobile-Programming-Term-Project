class ProductDetailModel {
  ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.price,
    required this.createrFullName,
    required this.createdBy,
    required this.views,
    required this.images,
  });

  int id;
  String title;
  String description;
  bool isFavorite;
  double price;
  String createrFullName;
  String createdBy;
  int views;
  List<String> images;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isFavorite: json["isFavorite"],
        price: json["price"].toDouble(),
        createrFullName: json["createrFullName"],
        createdBy: json["createdBy"],
        views: json["views"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "isFavorite": isFavorite,
        "price": price,
        "createrFullName": createrFullName,
        "createdBy": createdBy,
        "views": views,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
