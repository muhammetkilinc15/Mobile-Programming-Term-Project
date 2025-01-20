import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';
import 'package:miloo_mobile/screens/home/components/section_tile.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getPopularProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTile(
            title: 'Popular Products',
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StoreScreen(
                  initialCategoryId: -1,
                ),
              ));
            }),
        SizedBox(height: getProportionateScreenHeight(20)),
        Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }

            if (provider.popularProducts.isEmpty) {
              return const Text('No popular products found');
            }

            if (provider.error.isNotEmpty) {
              return Text('Error: ${provider.error}');
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    provider.popularProducts.length,
                    (index) {
                      final product = provider.popularProducts[index];
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
                        onFavorite: () async {
                          await provider.makeFavorite(product.id);
                        },
                      );
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
