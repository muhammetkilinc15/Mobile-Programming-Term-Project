import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/favorites/favorites_screen.dart';
import 'package:miloo_mobile/screens/home/home_screen.dart';
import 'package:miloo_mobile/screens/profile/profile_screen.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';
import 'package:miloo_mobile/size_config.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
  static String routeName = '/base';

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  // Alt sayfaların listesini oluşturun
  final List<Widget> _screens = [
    const HomeScreen(), // Ana sayfa
    const StoreScreen(),
    const FavoritesScreen(),
    const ProfileScreen(), // Profil sayfası
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Cihaz boyutlarını başlat
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, // Hangi ekranın gösterileceğini belirler
        children: _screens.map((screen) {
          // Her ekranda güncelleme tetiklemek için bir `Key` ekliyoruz.
          return _currentIndex == _screens.indexOf(screen)
              ? KeyedSubtree(
                  key: ValueKey<int>(
                      _currentIndex), // Her ekran için benzersiz bir key
                  child: screen,
                )
              : screen;
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Seçili olan menü
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Seçim değiştikçe güncellenir
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: const Color(0xFFB6B6B6),
      ),
    );
  }
}
