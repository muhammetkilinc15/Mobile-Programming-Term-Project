import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_surfix_icon.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/components/form_error.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:miloo_mobile/screens/base/base_screen.dart';
import 'package:miloo_mobile/services/auth_service.dart';
import 'package:miloo_mobile/size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String email = '210129049@ogr.atu.edu.tr';
  String password = '12345678';
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
          FormError(errors: errors),
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
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: 'Continue',
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() => load = true);

                AuthService authService = AuthService();
                bool result =
                    await authService.login(email: email, password: password);

                setState(() => load = false);

                if (result) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    BaseScreen.routeName,
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid email or password!'),
                      backgroundColor: Colors.red,
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
      keyboardType: TextInputType.emailAddress,
      initialValue: email,
      onSaved: (newValue) => email = newValue!,
      validator: emailValidator,
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
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
      obscureText: true,
      initialValue: password,
      onSaved: (newValue) => password = newValue!,
      validator: passwordValidator,
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
}
