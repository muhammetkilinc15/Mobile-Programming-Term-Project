import 'package:flutter/material.dart';
import 'package:miloo_mobile/providers/auth_provider.dart';
import 'package:miloo_mobile/providers/category_provider.dart';
import 'package:miloo_mobile/providers/navigation_provider.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/providers/user_provider.dart';
import 'package:miloo_mobile/routes/routes.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/screens/base/base_screen.dart';
import 'package:miloo_mobile/screens/onboarding/onbarding_screen.dart';
import 'package:miloo_mobile/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  final bool isRemember = prefs.getBool('isRemember') ?? false;

  // İlk kullanım işaretini false olarak ayarla
  prefs.setBool('isFirstTime', false);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: MyApp(
      isFirstTime: isFirstTime,
      isRemember: isRemember,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime, required this.isRemember});
  final bool isFirstTime;
  final bool isRemember;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Miloo App',
      theme: theme(),
      initialRoute: _determineInitialRoute(),
      routes: routes,
    );
  }

  // Başlangıç rotasını belirleme
  String _determineInitialRoute() {
    if (isFirstTime) {
      return OnboardingScreen.routerName;
    } else if (isRemember) {
      return MainScreen.routeName;
    } else {
      return SignInScreen.routerName;
    }
  }
}
