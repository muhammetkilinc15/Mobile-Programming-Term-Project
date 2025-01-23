import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/user/other_populer_users/components/body.dart';

class OtherPopulerScreen extends StatelessWidget {
  const OtherPopulerScreen({super.key});
  static String routerName = '/other_populer_users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Populer Users'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Body(),
    );
  }
}
