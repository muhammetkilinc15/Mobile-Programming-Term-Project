import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';
import 'package:miloo_mobile/screens/home/components/section_tile.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/size_config.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<List<PopularProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts(); // Ekran her göründüğünde veriyi yenile
  }

  void _fetchProducts() {
    setState(() {
      futureProducts = ProductService.getPopularProducts();
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
                builder: (context) => StoreScreen(),
              ));
            }),
        SizedBox(height: getProportionateScreenHeight(20)),
        FutureBuilder<List<PopularProductModel>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No popular products found');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      snapshot.data!.length,
                      (index) => ProductCard(
                        product: ProductModel(
                          id: snapshot.data![index].id,
                          title: snapshot.data![index].title,
                          description: '',
                          isFavourite: snapshot.data![index].isFavorite,
                          price: snapshot.data![index].price,
                          image: snapshot.data![index].image!,
                        ),
                        press: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: ProductDetailsArgument(
                              productId: snapshot.data![index].id,
                            ),
                          ).then((_) {
                            // Navigator.pop sonrası verileri yenile
                            _fetchProducts();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(20)),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
