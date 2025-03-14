import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.product,
    required this.press,
    this.onFavorite,
    this.isStore = false,
  });

  final double width, aspectRatio;
  final GestureTapCallback press;
  final Function()? onFavorite;
  final ProductModel product;
  final bool isStore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(width),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(product.image),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.price} \$',
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  if (!isStore && onFavorite != null) // Only show if not store
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: onFavorite ??
                          () {
                            ProductService productService = ProductService();
                            productService.makeFavorite(product.id);
                          },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(5),
                            vertical: getProportionateScreenHeight(5)),
                        height: getProportionateScreenHeight(28),
                        width: getProportionateScreenWidth(28),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavourite
                              ? Colors.red
                              : kSecondaryColor,
                          size: getProportionateScreenWidth(16),
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
