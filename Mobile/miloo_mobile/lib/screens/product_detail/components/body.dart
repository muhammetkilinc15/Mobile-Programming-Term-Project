import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/product_detail_model.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/screens/chat/message_screen.dart';
import 'package:miloo_mobile/screens/product_detail/components/product_images.dart';
import 'package:miloo_mobile/screens/product_detail/components/top_rounded_container.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
    required this.product,
  });

  final ProductDetailModel product;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final product = provider.productDetail ?? widget.product;

        return SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProductImages(product: product),
                TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(5),
                        ),
                        child: Text(
                          product.title,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Favorite Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => provider.makeFavorite(product.id),
                          child: Container(
                            padding:
                                EdgeInsets.all(getProportionateScreenWidth(15)),
                            width: getProportionateScreenWidth(50),
                            decoration: BoxDecoration(
                              color: product.isFavorite
                                  ? const Color(0xFFFFE6E6)
                                  : const Color(0xFFF5F6F9),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: product.isFavorite
                                  ? const Color(0xFFFF4848)
                                  : const Color(0xFFDBDEE4),
                            ),
                          ),
                        ),
                      ),
                      // Description
                      Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(5),
                          right: getProportionateScreenWidth(64),
                          top: 10,
                        ),
                        child: Text(
                          product.description,
                          maxLines: isExpanded ? null : 3,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(12),
                            color: kTextColor,
                          ),
                        ),
                      ),
                      // Show More/Less Button
                      GestureDetector(
                        onTap: () => setState(() => isExpanded = !isExpanded),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(5),
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                isExpanded ? "Show less" : "Show more",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(12),
                                  color: kPrimaryColor,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: kPrimaryColor,
                                size: getProportionateScreenWidth(12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Price
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                color: kTextColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "\$${product.price}",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      // Chat Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(5),
                        ),
                        child: DefaultButton(
                          text: 'Contact ${widget.product.createrFullName}',
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MessageScreen(
                                toUserId: product.createrId,
                                fullName: product.createrFullName,
                                toUserImage: product.createrImage,
                              ),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
