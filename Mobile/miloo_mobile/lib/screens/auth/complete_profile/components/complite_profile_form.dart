import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_surfix_icon.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/models/user_register_model.dart';
import 'package:miloo_mobile/screens/auth/confirm_email/confirm_email_screen.dart';
import 'package:miloo_mobile/services/auth_service.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:miloo_mobile/components/custom_universities.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  final String email;
  final String username;
  final String password;

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String firstName = 'Muhammet';
  String lastName = 'Kılınç';
  String _selectedUniversity = 'Adana Alparslan Türkeş University';
  int _selectedUniversityId = -1; // Default university id

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(30)),
            buildFirstNameFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildLastNameFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            _buildUniversityDropdown(),
            SizedBox(height: getProportionateScreenHeight(30)),
            DefaultButton(
              text: 'Continue',
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Form değerlerini günceller
                  setState(() => _isLoading = true);

                  try {
                    AuthService authService = AuthService();
                    bool result = await authService.register(
                      registerModel: UserRegisterModel(
                        userName: widget.username,
                        email: widget.email,
                        password: widget.password,
                        firstName: firstName,
                        lastName: lastName,
                        universityId: _selectedUniversityId,
                      ),
                    );

                    if (result) {
                      Navigator.pushNamed(
                        context,
                        ConfirmEmailScreen.routerName,
                        arguments: ConfirmEmailArguments(email: widget.email),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("An error occurred while registering!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint("Error: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("An error occurred while registering: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() => _isLoading = false);
                  }
                } else {
                  setState(() => _isLoading = false); // Doğrulama başarısızsa
                }
              },
              isLoading: _isLoading,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUniversityDropdown() {
    return CustomUniversities(
      selectedUniversity: _selectedUniversity,
      onSelected: (selectedUniversity) {
        setState(() {
          _selectedUniversity = selectedUniversity;
          _selectedUniversityId = _selectedUniversityId;
        });
      },
      selectedUniversityId: 1,
    );
  }

  Widget buildLastNameFormField() {
    return TextFormField(
      initialValue: lastName,
      onChanged: (value) {
        setState(() {
          lastName = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Last Name',
        hintText: 'Enter your last name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(icon: Icons.person),
      ),
    );
  }

  Widget buildFirstNameFormField() {
    return TextFormField(
      initialValue: firstName,
      onChanged: (value) {
        setState(() {
          firstName = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'First Name',
        hintText: 'Enter your first name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(icon: Icons.person),
      ),
    );
  }
}
