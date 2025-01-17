import 'package:flutter/material.dart';
import 'package:miloo_mobile/providers/auth_provider.dart';
import 'package:miloo_mobile/routes/routes.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/screens/onboarding/splash_screen.dart';
import 'package:miloo_mobile/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  prefs.setBool('isFirstTime', false);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: MyApp(
      isFirstTime: isFirstTime,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});
  final bool isFirstTime;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miloo App',
      theme: theme(),
      initialRoute:
          isFirstTime ? OnboardingScreen.routerName : SignInScreen.routerName,
      routes: routes,
    );
  }
}

// smooth_page_indicator ==> . . . için
