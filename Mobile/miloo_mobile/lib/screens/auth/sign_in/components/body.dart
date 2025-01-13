import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/auth/sign_in/components/no_account_text.dart';
import 'package:miloo_mobile/screens/auth/sign_in/components/sign_form.dart';
import 'package:miloo_mobile/screens/auth/sign_in/components/social_card.dart';
import 'package:miloo_mobile/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Sign in with your email and password  \nor continue with social media',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                const SignForm(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(text: "assets/icons/google.svg", press: () {}),
                    SocialCard(text: "assets/icons/facebook.svg", press: () {}),
                    SocialCard(text: "assets/icons/github.svg", press: () {}),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                const NoAccountText()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
