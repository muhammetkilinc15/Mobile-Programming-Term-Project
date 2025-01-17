class UserWithProductDetail {
  final int id;
  final String profilPhoto;
  final String fullName;
  final String universty;
  final int soldProduct;
  final int posts;
  final List<PopularUserProducts> products;

  UserWithProductDetail({
    required this.id,
    required this.profilPhoto,
    required this.fullName,
    required this.universty,
    required this.soldProduct,
    required this.posts,
    required this.products,
  });

  factory UserWithProductDetail.fromJson(Map<String, dynamic> json) {
    return UserWithProductDetail(
      id: json['id'],
      profilPhoto: json['profilPhoto'],
      fullName: json['fullName'],
      universty: json['universty'],
      soldProduct: json['soldProduct'] as int,
      posts: json['posts'] as int,
      // Burada gelen JSON listesini doğru şekilde map'liyoruz
      products: (json['products'] as List)
          .map((product) =>
              PopularUserProducts.fromJson(product as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PopularUserProducts {
  final int id;
  final String title;
  final double price;
  final bool isSold;
  final List<String> images;

  PopularUserProducts({
    required this.id,
    required this.title,
    required this.price,
    required this.isSold,
    required this.images,
  });

  factory PopularUserProducts.fromJson(Map<String, dynamic> json) {
    return PopularUserProducts(
      id: json['id'],
      title: json['title'],
      // Burada price'ı int olabileceği gibi double da olabilir, kontrol edelim:
      price: json['price'] is int
          ? (json['price'] as int).toDouble() // int -> double dönüşümü
          : json['price'] as double, // Direkt double ise olduğu gibi al
      isSold: json['isSold'],
      images:
          (json['images'] as List).map((image) => image.toString()).toList(),
    );
  }
}
