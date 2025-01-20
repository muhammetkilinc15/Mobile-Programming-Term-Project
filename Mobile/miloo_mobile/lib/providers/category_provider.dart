import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/models/sub_category_model.dart';
import 'package:miloo_mobile/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<CategoryModel> homecategories = [];
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subcategories = [];
  bool isLoading = false;
  String error = '';
  int _selectedCategoryId = -1;
  int _selectedSubcategoryId = -1;

  int get selectedCategoryId => _selectedCategoryId;
  int get selectedSubcategoryId => _selectedSubcategoryId;

  Future<void> getCategories() async {
    if (isLoading) return;

    try {
      isLoading = true;
      notifyListeners();
      List<CategoryModel> fetchedCategories =
          await _categoryService.getCategories(pageNumber: 1, pageSize: 5);
      categories = fetchedCategories.map((category) {
        return CategoryModel(
          id: category.id,
          name: category.name,
        );
      }).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHomeCategories() async {
    if (homecategories.isNotEmpty)
      return; // Check if homecategories are already loaded

    try {
      isLoading = true;
      notifyListeners();

      final fetchedCategories =
          await _categoryService.getCategories(pageNumber: 1, pageSize: 5);

      homecategories = fetchedCategories.map((category) {
        return CategoryModel(
          id: category.id,
          name: category.name,
        );
      }).toList();
      error = ''; // Clear any previous errors
    } catch (e) {
      error = e.toString();
      print('Error fetching home categories: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubCategories(int categoryId) async {
    if (isLoading) return;
    try {
      isLoading = true;
      notifyListeners();

      final fetchedSubcategories =
          await _categoryService.getSubCategories(categoryId: categoryId);
      subcategories = fetchedSubcategories.map((subcategory) {
        return SubCategoryModel(
          id: subcategory.id,
          name: subcategory.name,
        );
      }).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    _selectedSubcategoryId = -1;
    notifyListeners();
    getSubCategories(categoryId);
  }

  void setSelectedSubcategory(int subcategoryId) {
    _selectedSubcategoryId = subcategoryId;
    notifyListeners();
  }

  void clearError() {
    error = '';
    notifyListeners();
  }
}
