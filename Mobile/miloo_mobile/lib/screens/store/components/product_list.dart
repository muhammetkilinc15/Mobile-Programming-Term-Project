import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<PopularProductModel> products;
  final Function(int) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return ProductCard(
          product: ProductModel(
            id: product.id,
            title: product.title,
            description: '',
            price: product.price,
            image: product.image!,
            isFavourite: false,
          ),
          press: () => onProductTap(product.id),
        );
      },
    );
  }
}
