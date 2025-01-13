import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/auth/complete_profile/components/complite_profile_form.dart';

class Body extends StatefulWidget {
  const Body({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  final String email;
  final String username;
  final String password;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Complete Profile',
              style: headingStyle,
            ),
            const Text("Complete your details or continue \nwith social media",
                textAlign: TextAlign.center),
            CompleteProfileForm(
              email: widget.email,
              password: widget.password,
              username: widget.username,
            ),
          ],
        ),
      ),
    );
  }
}
