import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/user_with_product_detail.dart';
import 'package:miloo_mobile/screens/chat/message_screen.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/size_config.dart';

class UserProducts extends StatelessWidget {
  final UserWithProductDetail user;

  const UserProducts({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Text(
                'Products',
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: user.products.length,
              itemBuilder: (context, index) {
                final product = user.products[index];
                return Stack(
                  children: [
                    Card(
                      color: const Color.fromARGB(255, 234, 233, 233),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments:
                                ProductDetailsArgument(productId: product.id),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: product.images.isNotEmpty
                                  ? Image.network(
                                      product.images[0],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      child: const Icon(Icons.image,
                                          color: Colors.white),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: TextStyle(
                                      fontSize:
                                          getProportionateScreenHeight(12),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '\$${product.price}',
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(12),
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (product.isSold)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(8),
                            vertical: getProportionateScreenHeight(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Satıldı',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(12),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: DefaultButton(
                text: "${user.fullName} contact",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MessageScreen(
                          toUserId: user.id,
                          fullName: user.fullName,
                          toUserImage: user.profilPhoto,
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
}
