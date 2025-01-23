import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/user/user_detail/components/user_card.dart';
import 'package:miloo_mobile/screens/user/user_detail/components/user_products.dart';
import 'package:miloo_mobile/services/user_service.dart';
import 'package:miloo_mobile/models/user_with_product_detail.dart';
import 'package:miloo_mobile/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.username});
  final String username;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<UserWithProductDetail> futureUser;
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    futureUser = _userService.getUserWithProductDetail(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'User Information',
        ),
      ),
      body: FutureBuilder<UserWithProductDetail>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          } else {
            final user = snapshot.data!;

            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    UserCard(user: user), // UserCard widget'ini güncelliyoruz
                    SizedBox(height: getProportionateScreenHeight(20)),

                    UserProducts(user: user),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
