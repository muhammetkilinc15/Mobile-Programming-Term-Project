import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/onboarding/components/body.dart';
import 'package:miloo_mobile/size_config.dart';

class OnboardingScreen extends StatelessWidget {
  static String routerName = '/spllash';

  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return const Scaffold(
      body: Body(),
    );
  }
}
