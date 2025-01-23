import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/auth/complete_profile/components/body.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  static String routerName = '/complete_profile';

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final CompleteProfileArguments args =
        ModalRoute.of(context)!.settings.arguments as CompleteProfileArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: Body(
        email: args.email, // Pass email
        username: args.username, // Pass username
        password: args.password, // Pass password
      ),
    );
  }
}

class CompleteProfileArguments {
  final String username;
  final String email;
  final String password;
  CompleteProfileArguments({
    required this.username,
    required this.email,
    required this.password,
  });
}
