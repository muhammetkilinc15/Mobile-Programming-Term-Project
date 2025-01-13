import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miloo_mobile/size_config.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    super.key,
    required this.text,
    required this.press,
  });
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(10),
        ),
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        height: getProportionateScreenHeight(47),
        width: getProportionateScreenWidth(47),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(text),
      ),
    );
  }
}
