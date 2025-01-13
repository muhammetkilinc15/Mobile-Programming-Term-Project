import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class PopularUserCard extends StatelessWidget {
  const PopularUserCard({
    super.key,
    required this.image,
    required this.press,
    required this.fullName,
  });

  final String image;
  final GestureTapCallback press;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenHeight(15)),
      child: GestureDetector(
        onTap: press,
        child: Column(
          children: [
            // CircleAvatar with border and shadow
            Container(
              height: getProportionateScreenWidth(70),
              width: getProportionateScreenWidth(70),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      const Color.fromARGB(255, 244, 176, 74), // border color
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(image),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            // Full name with styled text
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
