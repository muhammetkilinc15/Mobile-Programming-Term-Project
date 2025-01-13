import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final VoidCallback press;

  const SectionTile({
    super.key,
    required this.title,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: const Text('See More'),
          ),
        ],
      ),
    );
  }
}
