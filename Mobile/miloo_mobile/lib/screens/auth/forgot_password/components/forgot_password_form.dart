import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_surfix_icon.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/providers/auth_provider.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildInputField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.mail_outline_outlined,
            validator: emailValidator,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
              text: 'Continue',
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  setState(() {
                    isLoading = true;
                  });

                  await context
                      .read<AuthProvider>()
                      .forgotPassword(_emailController.text);
                  final error =
                      context.read<AuthProvider>().forgotPasswordError;

                  if (error != null && error.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset email sent'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInScreen.routerName,
                      (route) => false,
                    );
                  }
                }
              },
              isLoading: isLoading),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter your $label',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(
          icon: icon,
        ),
      ),
    );
  }
}
