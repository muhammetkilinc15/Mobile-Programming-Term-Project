import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/add_product/add_product_screen.dart';
import 'package:miloo_mobile/screens/my_shared_products/my_shared_products_screen.dart';
import 'package:miloo_mobile/screens/auth/complete_profile/complete_profile_screen.dart';
import 'package:miloo_mobile/screens/auth/confirm_email/confirm_email_screen.dart';
import 'package:miloo_mobile/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/screens/auth/sign_up/sign_up_screen.dart';
import 'package:miloo_mobile/screens/base/base_screen.dart';
import 'package:miloo_mobile/screens/chat/chat_screen.dart';
import 'package:miloo_mobile/screens/other_populer_users/other_populer_screen.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/my_account/my_account_screen.dart';
import 'package:miloo_mobile/screens/onboarding/splash_screen.dart';
import 'package:miloo_mobile/screens/profile/profile_screen.dart';
import 'package:miloo_mobile/screens/user_detail/user_detail_screen.dart';

// We use name route for easy navigation
final Map<String, WidgetBuilder> routes = {
  OnboardingScreen.routerName: (context) => const OnboardingScreen(),
  SignInScreen.routerName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routerName: (context) => const CompleteProfileScreen(),
  ConfirmEmailScreen.routerName: (context) => const ConfirmEmailScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
  ChatScreen.routeName: (context) => const ChatScreen(),
  UserDetailScreen.routeName: (context) => const UserDetailScreen(),
  MyAccountScreen.routeName: (context) => const MyAccountScreen(),
  MySharedProductsScreen.routeName: (context) => const MySharedProductsScreen(),
  AddProductScreen.routeName: (context) => const AddProductScreen(),
  OtherPopulerScreen.routerName: (context) => const OtherPopulerScreen(),
};
