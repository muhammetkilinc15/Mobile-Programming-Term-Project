class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavourite;
  final bool isSold;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.isFavourite = false,
    this.isSold = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isFavourite: json['isFavourite'],
      isSold: json['isSold'],
    );
  }
}

// {
//   "data": [
//     {
//       "id": 1,
//       "title": "Iphone 12",
//       "images": [],
//       "price": 75.12
//     },
//     {
//       "id": 2,
//       "title": "Daxi-1500 Bilimsel Hesap Makinesi",
//       "images": [
//         "http://192.168.169.190:5105/images\\1\\products\\5a6ca7d2-bc0f-436b-a0f1-ebe548062f9c.jfif",
//         "http://192.168.169.190:5105/images\\1\\products\\73450e76-e313-4adf-abd3-970f3bc42435.jfif"
//       ],
//       "price": 180.76
//     },
//     {
//       "id": 3,
//       "title": "İphone 15 Pro max Akıllı Telefon",
//       "images": [
//         "http://192.168.169.190:5105/images\\1\\products\\a8524012-c54d-4184-a3bb-4f7bb2f93479.png",
//         "http://192.168.169.190:5105/images\\1\\products\\c510b636-cb7d-4b26-b6d6-4884ae6fe4df.png",
//         "http://192.168.169.190:5105/images\\1\\products\\e483c31b-fc75-4517-82ce-6bd7d042888e.png",
//         "http://192.168.169.190:5105/images\\1\\products\\0b260fa1-70b9-4d2e-9145-69439bfe96a2.png"
//       ],
//       "price": 25000
//     }
//   ],
//   "pageInfo": {
//     "_PageNumber": 1,
//     "_PageSize": 9,
//     "_TotalRowCount": 3,
//     "totalPageCount": 1,
//     "hasNextPage": false,
//     "hasPreviousPage": false
//   }
// }
