import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/auth/sign_in/components/social_card.dart';
import 'package:miloo_mobile/screens/auth/sign_up/components/sign_up_form.dart';
import 'package:miloo_mobile/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              const Text(
                "Register Account",
                style: headingStyle,
              ),
              const Text(
                "Complete your details or continue \nwith social media",
                textAlign: TextAlign.center,
              ),
              const SignUpForm(),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialCard(text: "assets/icons/google.svg", press: () {}),
                  SocialCard(text: "assets/icons/facebook.svg", press: () {}),
                  SocialCard(text: "assets/icons/github.svg", press: () {}),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              const TermsAndConditionsScreen()
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero, // Tam ekran için boşlukları kaldır
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Terms and Conditions",
                    style: TextStyle(color: Colors.white),
                  ),
                  automaticallyImplyLeading: false, // Geri butonunu gizle
                  backgroundColor: Colors.red,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'By using this application, you agree to the following terms and conditions:\n',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '1. Purpose and Scope\n',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '   • Purpose: This application aims to create a platform for university students to easily share, sell, or exchange unused second-hand items with fellow students at their own university. Users can create listings, add images, and provide descriptions of their items. Other users can access these listings and communicate directly through in-app messaging to discuss details. This platform helps students meet their needs cost-effectively while contributing to a sustainable lifestyle.\n\n'
                                '   • Scope: This application is exclusively designed for university students and includes the following features:\n'
                                '     - Item listing creation with images and detailed descriptions.\n'
                                '     - In-app messaging system for direct communication.\n'
                                '     - User authentication to ensure student-only access.\n'
                                '     - Search and filter options to easily browse items.\n',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '2. General Terms\n',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '   1. The platform acts only as an intermediary to connect buyers and sellers within the university.\n'
                                '   2. Users are responsible for the legality, authenticity, and quality of items listed or purchased.\n'
                                '   3. The application does not take responsibility for any disputes or issues arising during transactions.\n'
                                '   4. Fraud, illegal activity, or harm caused during transactions is the sole responsibility of the involved parties.\n\n',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '3. Privacy and Security\n',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '   1. User data will be securely stored and handled in compliance with our privacy policy.\n'
                                '   2. Personal information will not be shared with third parties without consent, except as required by law.\n'
                                '   3. Users are advised to keep their login credentials confidential and report any suspicious activity immediately.\n\n',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '4. Updates to Terms\n',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '   1. We reserve the right to update these terms at any time without prior notice.\n'
                                '   2. Continued use of the application implies acceptance of any changes to these terms.\n\n',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '5. Limitation of Liability\n',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '   1. The application is not liable for any direct or indirect damages resulting from the use of the platform.\n'
                                '   2. Users are solely responsible for their actions on the platform and any agreements made with other users.\n\n',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'For any questions or concerns, please contact support.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      DefaultButton(
                          text: "Confirm", press: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: const [
            TextSpan(
              text: 'By continuing you confirm that you agree \nwith our ',
            ),
            TextSpan(
              text: 'Terms',
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Conditions',
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
