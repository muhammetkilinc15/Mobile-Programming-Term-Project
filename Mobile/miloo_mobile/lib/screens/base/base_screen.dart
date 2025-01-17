import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/custom_navigation_bar.dart';
import 'package:miloo_mobile/screens/favorites/favorites_screen.dart';
import 'package:miloo_mobile/screens/home/home_screen.dart';
import 'package:miloo_mobile/screens/profile/profile_screen.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
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
