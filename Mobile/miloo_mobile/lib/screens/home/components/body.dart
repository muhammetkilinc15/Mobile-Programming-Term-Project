import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/home/components/categories.dart';
import 'package:miloo_mobile/screens/home/components/discount_banner.dart';
import 'package:miloo_mobile/screens/home/components/popular_products.dart';
import 'package:miloo_mobile/screens/home/components/section_tile.dart';
import 'package:miloo_mobile/size_config.dart';
import 'popular_users.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DiscountBanner(),
            const Categories(),
            SizedBox(height: getProportionateScreenHeight(20)),
            SectionTile(
              title: 'Popular Users',
              press: () {},
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            const PopularUsers(),
            SizedBox(height: getProportionateScreenHeight(20)),
            const PopularProducts(),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
