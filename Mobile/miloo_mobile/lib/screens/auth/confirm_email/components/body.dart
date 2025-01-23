import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/services/auth_service.dart';
import 'package:pinput/pinput.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  String _confirmationCode = '';
  bool isLoading = false;

  void _validateCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      AuthService service = AuthService();
      bool result = await service.verifyEmail(
        email: widget.email,
        code: _confirmationCode,
      );
      setState(() {
        isLoading = false;
      });

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email confirmed successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(
            context, SignInScreen.routerName, (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid confirmation code!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "Confirm Your Email",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                const Text(
                  "We sent your code to email address",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildTimer(),
                SizedBox(height: getProportionateScreenHeight(20)),
                Form(
                  key: _formKey,
                  child: Pinput(
                    length: 6,
                    keyboardType: TextInputType.number,
                    onCompleted: (value) => _confirmationCode = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the code";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Continue",
                  press: _validateCode,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expire in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 900.0, end: 0.0), // 15 minutes = 900 seconds
          duration: const Duration(seconds: 900),
          builder: (_, dynamic value, child) {
            int minutes = (value / 60).floor();
            int seconds = (value % 60).toInt();
            return Text(
              "$minutes:${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(color: kPrimaryColor),
            );
          },
        ),
      ],
    );
  }
}
