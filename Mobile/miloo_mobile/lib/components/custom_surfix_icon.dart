import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class CustomSurfixIcon extends StatelessWidget {
  const CustomSurfixIcon({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          getProportionateScreenHeight(20),
          getProportionateScreenWidth(20),
          getProportionateScreenWidth(20),
        ),
        child: Icon(icon));
  }
}
