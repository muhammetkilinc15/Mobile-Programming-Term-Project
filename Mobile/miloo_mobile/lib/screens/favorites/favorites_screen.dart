import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getFavoriteProducts();
    });
  }

  Future<void> _refreshProducts() async {
    await Future.delayed(const Duration(seconds: 3));
    await context.read<ProductProvider>().getFavoriteProducts();
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
            SizedBox(height: getProportionateScreenHeight(20)),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return _buildShimmerEffect();
                  }

                  if (provider.error.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${provider.error}'),
                          ElevatedButton(
                            onPressed: _refreshProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.favoriteProducts.isEmpty) {
                    return const Center(
                      child: Text('No favorite products found.'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshProducts,
                    child: GridView.builder(
                      itemCount: provider.favoriteProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final product = provider.favoriteProducts[index];
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
                            ).then((_) => _refreshProducts());
                          },
                          onFavorite: () async {
                            await context
                                .read<ProductProvider>()
                                .makeFavorite(product.id);
                          },
                        );
                      },
                    ),
                  );
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
