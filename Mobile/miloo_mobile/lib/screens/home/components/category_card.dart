import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: getProportionateScreenWidth(50),
            height: getProportionateScreenWidth(50),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE0B2),
              shape: BoxShape.rectangle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF6E40),
              size: 30,
            ),
          ),
          const SizedBox(height: 5),
          Text(text),
        ],
      ),
    );
  }
}
