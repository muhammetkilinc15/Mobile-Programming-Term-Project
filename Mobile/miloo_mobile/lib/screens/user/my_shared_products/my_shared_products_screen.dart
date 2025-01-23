import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/user/my_shared_products/components/body.dart';

class MySharedProductsScreen extends StatelessWidget {
  const MySharedProductsScreen({super.key});
  static String routeName = "/my_shared_products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Shared Products"),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Body());
  }
}
