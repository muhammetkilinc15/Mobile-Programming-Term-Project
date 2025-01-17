import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/auth/sign_in/components/body.dart';
import 'package:miloo_mobile/size_config.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static String routerName = '/sign_in';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: headingStyle,
        ),
      ),
      body: const Body(),
    );
  }
}
