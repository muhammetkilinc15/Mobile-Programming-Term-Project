import 'package:http/http.dart' as http;
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/helper/token_manager.dart';
import 'dart:convert';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/models/sub_category_model.dart';

class CategoryService {
  String url = "${baseUrl}Category/";
  final TokenManager _tokenManager = TokenManager();

  Future<List<CategoryModel>> getCategories(
      {int pageNumber = 1, int pageSize = 10}) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse('${url}getall?PageNumber=$pageNumber&PageSize=$pageSize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      List<CategoryModel> categories =
          data.map((category) => CategoryModel.fromJson(category)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<SubCategoryModel>> getSubCategories({int categoryId = -1}) async {
    final token = await _tokenManager.getAccessToken();
    final response = await http.get(
      Uri.parse('${url}getallwithsubcategory?CategoryId=$categoryId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      List<SubCategoryModel> subcategories = data
          .map((subcategory) => SubCategoryModel.fromJson(subcategory))
          .toList();
      return subcategories;
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  Future<List<CategoryModel>> searchCategories(String keyword) async {
    final token = await _tokenManager.getAccessToken();

    final response = await http.get(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      Uri.parse('${url}getall?Search=$keyword'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      List<CategoryModel> categories =
          data.map((category) => CategoryModel.fromJson(category)).toList();
      return categories;
    } else {
      throw Exception('Failed to search categories');
    }
  }
}
