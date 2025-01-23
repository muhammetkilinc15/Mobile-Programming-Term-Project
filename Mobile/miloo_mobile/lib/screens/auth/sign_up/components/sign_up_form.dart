import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_surfix_icon.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:miloo_mobile/size_config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: "mami07");
  final TextEditingController _emailController =
      TextEditingController(text: "210129049@ogr.atu.edu.tr");
  final TextEditingController _passwordController =
      TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildUsernameField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildEmailField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: 'Continue',
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pushNamed(
                  context,
                  CompleteProfileScreen.routerName,
                  arguments: CompleteProfileArguments(
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildUsernameField() {
    return TextFormField(
      initialValue: _usernameController.text,
      onSaved: (newValue) => _usernameController.text = newValue!,
      validator: usernameValidator.call,
      decoration: const InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(icon: Icons.person_outline),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      initialValue: _emailController.text,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => _emailController.text = newValue!,
      validator: emailValidator.call,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(
          icon: Icons.mail_outline_outlined,
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      initialValue: _passwordController.text,
      obscureText: true,
      onSaved: (newValue) => _passwordController.text = newValue!,
      validator: passwordValidator.call,
      maxLength: 20,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(
          icon: Icons.lock_outline,
        ),
      ),
    );
  }
}
