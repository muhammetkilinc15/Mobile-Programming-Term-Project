import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/models/product_detail_model.dart';
import 'package:miloo_mobile/models/user_products_model.dart';
import 'package:miloo_mobile/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  bool isDetailLoading = false;
  String detailError = '';
  String sortBy = 'popular';
  List<UserProductsModel> userProducts = [];
  List<PopularProductModel> popularProducts = [];
  List<PopularProductModel> favoriteProducts = [];
  List<PopularProductModel> filteredProducts = [];
  ProductDetailModel? productDetail;

  bool isLoading = false;
  String error = '';
  String userProductsError = '';

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    userProducts.clear();
    popularProducts.clear();
    favoriteProducts.clear();
    productDetail = null;
    error = '';
    userProductsError = '';
    notifyListeners();
  }

  Future<void> getUserProducts({
    int pageNumber = 1,
    int pageSize = 10,
    String? search,
  }) async {
    try {
      isLoading = true;
      userProductsError = '';
      notifyListeners();
      userProducts = await _productService.getUserProducts(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );
    } catch (e) {
      userProductsError = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPopularProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      popularProducts = await _productService.getPopularProducts();
      error = '';
    } catch (e) {
      error = e.toString();
      popularProducts = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductDetail(int productId) async {
    try {
      isDetailLoading = true;
      notifyListeners();
      productDetail = await _productService.getProductDetail(productId);
      await _productService.increaseView(productId);
    } catch (e) {
      detailError = e.toString();
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProducts({
    int universityId = -1,
    int categoryId = -1,
    int subcategoryId = -1,
    String? orderBy,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      if (orderBy != null) {
        sortBy = orderBy;
      }
      final newProducts = await _productService.getProducts(
        universityId: -1,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        orderBy: sortBy,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (pageNumber == 1) {
        filteredProducts = newProducts;
      } else {
        filteredProducts.addAll(newProducts);
      }
    } catch (e) {
      error = e.toString();
      print('Error loading products: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<PopularProductModel>> searchProducts(String query) async {
    try {
      isLoading = true;
      notifyListeners();

      final searchResults = await _productService.getProducts(
        universityId: -1,
        pageNumber: 1,
        pageSize: 10,
        search: query,
        orderBy: 'title',
      );

      return searchResults;
    } catch (e) {
      error = e.toString();
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeFavorite(int productId) async {
    try {
      await _productService.makeFavorite(productId);

      // Update favorite status in popular products
      for (var product in popularProducts) {
        if (product.id == productId) {
          product.isFavorite = !product.isFavorite;
        }
      }

      // Update favorite list
      if (favoriteProducts.any((p) => p.id == productId)) {
        favoriteProducts.removeWhere((p) => p.id == productId);
      }

      // Update other product lists
      // _updateProductInLists(productId);

      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getFavoriteProducts() async {
    try {
      isLoading = true;
      notifyListeners();
      favoriteProducts = await _productService.getFavoriteProducts();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    required int subcategoryId,
    required List<String> images,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _productService.addProduct(
        title: title,
        description: description,
        price: price,
        subcategoryId: subcategoryId,
        images: images,
      );
      await getUserProducts(); // Refresh user products
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      userProducts.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> markAsSold(int id) async {
    try {
      await _productService.markAsSold(id);
      final index = userProducts.indexWhere((product) => product.id == id);
      if (index != -1) {
        userProducts[index] = UserProductsModel(
          id: userProducts[index].id,
          title: userProducts[index].title,
          price: userProducts[index].price,
          image: userProducts[index].image,
          isSold: true,
        );
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProduct({
    required int id,
    required String title,
    required double price,
  }) async {
    try {
      await _productService.updateProduct(
        id: id,
        title: title,
        price: price,
      );
      final index = userProducts.indexWhere((product) => product.id == id);
      if (index != -1) {
        userProducts[index] = UserProductsModel(
          id: userProducts[index].id,
          title: title,
          price: price,
          image: userProducts[index].image,
          isSold: userProducts[index].isSold,
        );
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
