import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:miloo_mobile/components/custom_surfix_icon.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/screens/base/base_screen.dart';
import 'package:miloo_mobile/providers/auth_provider.dart';
import 'package:miloo_mobile/size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController =
      TextEditingController(text: "210129049@ogr.atu.edu.tr");
  TextEditingController passwordController =
      TextEditingController(text: "141021Bemu*");
  bool remember = false;
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildPasswordField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    remember = !remember;
                  });
                },
                child: const Text('Remember me'),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          DefaultButton(
            text: "Sign In",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  load = true;
                });
                // AuthProvider'ı kullanarak login işlemini gerçekleştirdim
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider.login(
                    usernameController.text, passwordController.text, remember);

                setState(() {
                  load = false;
                });

                if (success) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.routeName, (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password or username is incorrect'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              }
            },
            isLoading: load,
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: usernameController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => usernameController.text = newValue!,
      validator: emailValidator.call,
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(
          icon: Icons.mail_outline,
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      onSaved: (newValue) => passwordController.text = newValue!,
      validator: passwordValidator.call,
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
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

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}
