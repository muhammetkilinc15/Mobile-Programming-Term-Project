import 'package:flutter/material.dart';
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
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  load = true;
                });

                // AuthProvider'ı kullanarak login işlemini gerçekleştirdim
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final success = await authProvider.login(email, password);

                setState(() {
                  load = false;
                });

                if (success) {
                  Navigator.pushNamed(context, MainScreen.routeName);
                } else {
                  // Hata mesajı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
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
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
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
          icon: Icons.mail_outline,
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
