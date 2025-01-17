import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/user_detail/components/body.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});
  static String routeName = '/user_detail';

  @override
  Widget build(BuildContext context) {
    final UserDetailScreenArguments args =
        ModalRoute.of(context)!.settings.arguments as UserDetailScreenArguments;
    return Body(username: args.username);
  }
}

class UserDetailScreenArguments {
  final String username;
  UserDetailScreenArguments({required this.username});
}
