import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/helper/token_manager.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:miloo_mobile/models/product_detail_model.dart';
import 'package:miloo_mobile/models/user_products_model.dart';

class ProductService {
  String url = "${baseUrl}Product";
  final TokenManager _tokenManager = TokenManager();

  Future<List<UserProductsModel>> getUserProducts({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {
    final token = await _tokenManager.getAccessToken();
    final userId = JwtDecoder.decode(token)['userId'];
    final response = await http.get(
      Uri.parse(
          "$url/user-products?UserId=$userId&Search=${search ??= ""}&PageNumber=$pageNumber&PageSize=$pageSize"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data
          .map((product) => UserProductsModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load user products');
    }
  }

  Future<List<PopularProductModel>> getPopularProducts() async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse(
        "$url/popular-products?top=5",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data
          .map((product) => PopularProductModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load popular products');
    }
  }

  Future<ProductDetailModel> getProductDetail(int id) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.get(headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    }, Uri.parse("$url/$id"));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return ProductDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load product detail');
    }
  }

  Future<List<PopularProductModel>> getProducts({
    int universityId = -1,
    int categoryId = -1,
    int subcategoryId = -1,
    String orderBy = "popular",
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {
    final token = await _tokenManager.getAccessToken();
    if (universityId == -1) {
      universityId = int.parse(JwtDecoder.decode(token)['universityId']);
    }
    final response = await http.get(
      Uri.parse(
        "$url/getall?UniversityId=$universityId&CategoryId=$categoryId&SubCategoryId=$subcategoryId&OrderBy=$orderBy&PageNumber=$pageNumber&PageSize=$pageSize&Search=${search ?? ""}",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      final List<dynamic> data = decodedResponse["data"];

      return data.map((product) {
        return PopularProductModel(
          id: int.parse(product['id'].toString()),
          title: product['title'],
          price: double.parse(product['price'].toString()),
          image: product['image'],
          isFavorite: product['isFavorite'] ?? false,
        );
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> makeFavorite(int productId) async {
    final token = await _tokenManager.getAccessToken();
    int userId = int.parse(JwtDecoder.decode(token)['userId'].toString());
    final response = await http.post(Uri.parse("$url/make-favorite"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({"productId": productId, "userId": userId}));

    if (response.statusCode != 200) {
      throw Exception("Failed to make favorite");
    }
  }

  Future<void> increaseView(int productId) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.post(
      Uri.parse("$url/increase-view"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode(
        {
          "productId": productId,
        },
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to increase view");
    }
  }

//favorite-products?UserId=6&PageSize=5&PageNumber=1
  Future<List<PopularProductModel>> getFavoriteProducts() async {
    final token = await _tokenManager.getAccessToken();
    final userId = JwtDecoder.decode(token)['userId'];
    final response = await http.get(
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      Uri.parse(
          "$url/favorite-products?UserId=$userId&PageSize=5&PageNumber=1"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data
          .map((product) => PopularProductModel.fromJson(product))
          .toList();
    } else {
      throw Exception('Failed to load favorite products');
    }
  }

  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    required int subcategoryId,
    required List<String> images,
  }) async {
    final token = await _tokenManager.getAccessToken();
    int publisherId = int.parse(JwtDecoder.decode(token)['userId'].toString());

    var request = http.MultipartRequest('POST', Uri.parse("$url/create"));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['Title'] = title;
    request.fields['Description'] = description;
    request.fields['Price'] = price.toString();
    request.fields['SubCategoryId'] = subcategoryId.toString();
    request.fields['PublisherId'] = publisherId.toString();

    for (String imagePath in images) {
      request.files.add(await http.MultipartFile.fromPath('Images', imagePath));
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      print('Error adding product: ${response.statusCode}');
      print('Response: ${await response.stream.bytesToString()}');
      throw Exception("Failed to add product");
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.delete(
      Uri.parse("$url/delete/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }

  Future<void> markAsSold(int id) async {
    const store = FlutterSecureStorage();
    final token = await store.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    final response = await http.put(
      Uri.parse("$url/mark-sold/$id "),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to mark product as sold");
    } else {
      print("markAsSold response: ${response.body}");
    }
  }

  Future<void> updateProduct({
    required int id,
    required String title,
    required double price,
  }) async {
    const store = FlutterSecureStorage();
    final token = await store.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    final response = await http.put(Uri.parse("$url/update"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "id": id,
          "Title": title,
          "Price": price,
        }));
    if (response.statusCode != 200) {
      throw Exception("Failed to update product");
    }
  }
}
