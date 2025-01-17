import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<PopularProductModel>> favoriteProducts;
  ProductService _productService = ProductService();
  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
  }

  /// API'den favori ürünleri yükler.
  void _loadFavoriteProducts() {
    setState(() {
      favoriteProducts = _productService.getFavoriteProducts();
    });
  }

  /// Ekrana her dönüldüğünde API çağrısını tekrar yapar.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Your Favorite Products',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Expanded(
              child: FutureBuilder<List<PopularProductModel>>(
                future: favoriteProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerEffect(); // Shimmer efekti göster
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No favorite products found.'));
                  } else {
                    // Sadece favori ürünleri filtreleme
                    var favoriteOnly = snapshot.data!
                        .where((product) => product.isFavorite)
                        .toList();

                    return GridView.builder(
                      itemCount: favoriteOnly.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = favoriteOnly[index];
                        return ProductCard(
                          product: ProductModel(
                            id: product.id,
                            title: product.title,
                            description: '',
                            price: product.price,
                            isFavourite: product.isFavorite,
                            image: product.image!,
                          ),
                          press: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: ProductDetailsArgument(
                                productId: product.id,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Favori ürünler yüklenirken shimmer efekti gösterir.
  Widget _buildShimmerEffect() {
    return GridView.builder(
      itemCount: 6, // Örnek olarak 6 adet shimmer öğesi
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
