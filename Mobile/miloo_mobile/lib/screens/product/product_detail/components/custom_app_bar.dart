import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int views;

  const CustomAppbar({super.key, required this.views});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(12),
                vertical: getProportionateScreenHeight(6)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye_sharp,
                    color: Colors.black, size: 18),
                const SizedBox(width: 5),
                Text(
                  '$views',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
