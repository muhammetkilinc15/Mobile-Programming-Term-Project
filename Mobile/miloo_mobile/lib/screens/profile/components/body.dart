import 'package:flutter/material.dart';
import 'package:miloo_mobile/helper/jwt_helper.dart';
import 'package:miloo_mobile/providers/auth_provider.dart';
import 'package:miloo_mobile/providers/navigation_provider.dart';
import 'package:miloo_mobile/screens/add_product/add_product_screen.dart';
import 'package:miloo_mobile/screens/auth/sign_in/sign_in_screen.dart';
import 'package:miloo_mobile/screens/my_shared_products/my_shared_products_screen.dart';
import 'package:miloo_mobile/screens/my_account/my_account_screen.dart';
import 'package:miloo_mobile/screens/profile/components/profile_menu.dart';
import 'package:miloo_mobile/screens/profile/components/profile_picture.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> userRoles = [];
  String profileImage = '';

  Future<void> _handleLogout(BuildContext context) async {
    try {
      context.read<NavigationProvider>().setIndex(0);
      // Logout
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, SignInScreen.routerName, (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserRole().then((roles) {
      setState(() {
        userRoles = roles ?? [];
      });
    });
    getProfileImage();
  }

  Future<void> getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImage = prefs.getString('profileImage') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfilePicture(
              imageUrl: profileImage,
              onImageSelected: (p0) {},
              isEdit: false,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            ProfileMenu(
              text: "My Account",
              icon: Icons.person,
              press: () {
                Navigator.pushNamed(context, MyAccountScreen.routeName);
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: Icons.notifications,
              press: () {},
            ),
            if (userRoles.contains('Seller'))
              ProfileMenu(
                text: "Add Product",
                icon: Icons.add_circle_outline,
                press: () {
                  Navigator.pushNamed(context, AddProductScreen.routeName);
                },
              ),
            if (userRoles.contains('Seller'))
              ProfileMenu(
                text: "Shared Products",
                icon: Icons.production_quantity_limits,
                press: () {
                  Navigator.pushNamed(
                      context, MySharedProductsScreen.routeName);
                },
              ),
            if (userRoles.contains('Admin'))
              ProfileMenu(
                text: "Admin Panel",
                icon: Icons.admin_panel_settings,
                press: () {},
              ),
            ProfileMenu(
              text: "Settings",
              icon: Icons.settings,
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: Icons.help,
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: Icons.logout,
              press: () async {
                _handleLogout(context);

                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignInScreen.routerName, (route) => false);
                }
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            )
          ],
        ),
      ),
    );
  }
}
