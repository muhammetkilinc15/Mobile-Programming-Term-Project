import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/user_with_product_detail.dart';
import 'package:miloo_mobile/size_config.dart';

class UserCard extends StatelessWidget {
  final UserWithProductDetail user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(100),
            height: getProportionateScreenHeight(100),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profilPhoto),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Tooltip(
                  message: user.universty,
                  child: Text(
                    user.universty,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Posts: ${user.posts}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Sold: ${user.soldProduct}',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
