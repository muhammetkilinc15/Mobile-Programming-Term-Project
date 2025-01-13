import 'package:http/http.dart' as http;
import 'package:miloo_mobile/constraits/constrait.dart';
import 'dart:convert';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/models/sub_category_model.dart';

class CategoryService {
  static String url = "${baseUrl}Category/";

  static Future<List<CategoryModel>> getCategories(
      {int pageNumber = 1, int pageSize = 10}) async {
    final response = await http.get(
        Uri.parse('${url}getall?PageNumber=$pageNumber&PageSize=$pageSize'));

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

  static Future<List<SubCategoryModel>> getSubCategories(
      {int categoryId = -1}) async {
    final response = await http
        .get(Uri.parse('${url}getallwithsubcategory?CategoryId=$categoryId'));

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

  static Future<List<CategoryModel>> searchCategories(String keyword) async {
    final response = await http.get(Uri.parse('${url}getall?Search=$keyword'));

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
