import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/models/product_detail_model.dart';
import 'package:miloo_mobile/models/user_products_model.dart';
import 'package:miloo_mobile/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  bool isDetailLoading = false;
  String detailError = '';
  List<UserProductsModel> userProducts = [];
  List<PopularProductModel> popularProducts = [];
  List<PopularProductModel> favoriteProducts = [];
  List<PopularProductModel> filteredProducts = [];
  ProductDetailModel? productDetail;

  bool isLoading = false;
  String error = '';

  Future<void> getUserProducts(
      {int pageNumber = 1, int pageSize = 10, String? search}) async {
    try {
      isLoading = true;
      notifyListeners();
      userProducts = await _productService.getUserProducts(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
      );
    } catch (e) {
      error = e.toString();
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
    } catch (e) {
      error = e.toString();
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
    String orderBy = "popular",
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      filteredProducts = await _productService.getProducts(
        universityId: universityId,
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        orderBy: orderBy,
      );
    } catch (e) {
      error = e.toString();
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
      await getUserProducts(); // Refresh user products
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsSold(int id) async {
    try {
      await _productService.markAsSold(id);
      await getUserProducts(); // Refresh user products
    } catch (e) {
      error = e.toString();
      notifyListeners();
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
      await getUserProducts(); // Refresh user products
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
