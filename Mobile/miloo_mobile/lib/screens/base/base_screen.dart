import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_navigation_bar.dart';
import 'package:miloo_mobile/screens/favorites/favorites_screen.dart';
import 'package:provider/provider.dart';
import 'package:miloo_mobile/providers/navigation_provider.dart';
import 'package:miloo_mobile/screens/home/home_screen.dart';
import 'package:miloo_mobile/screens/profile/profile_screen.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: _buildBody(provider.currentIndex),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: provider.currentIndex,
            onTap: (index) => provider.setIndex(index),
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const StoreScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}
