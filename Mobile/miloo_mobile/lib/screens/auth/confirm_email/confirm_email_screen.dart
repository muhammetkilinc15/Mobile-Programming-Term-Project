import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/auth/confirm_email/components/body.dart';
import 'package:miloo_mobile/size_config.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});
  static String routerName = '/confirm_email';
  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmailScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final ConfirmEmailArguments args =
        ModalRoute.of(context)!.settings.arguments as ConfirmEmailArguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
        ),
        body: Body(email: args.email));
  }
}

class ConfirmEmailArguments {
  final String email;
  ConfirmEmailArguments({
    required this.email,
  });
}
