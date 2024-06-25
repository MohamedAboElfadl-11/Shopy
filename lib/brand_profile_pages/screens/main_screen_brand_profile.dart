import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../brand_profiles_structure/brand_profiles.dart';
import '../../personal_profile_screens/profile.dart';
import '../screens/cart_screen.dart';
import 'favorite_screen.dart';

class MainScreenBrandProfile extends StatefulWidget {
  const MainScreenBrandProfile({super.key});

  @override
  State<MainScreenBrandProfile> createState() => _MainScreenBrandProfileState();
}

class _MainScreenBrandProfileState extends State<MainScreenBrandProfile> {
  int currentTab = 0;
  List<Widget> screens = [
    HomePage(),
    FavoritePage(),
    CartScreen(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 75,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              index: 0,
              icon: Ionicons.home,
              label: 'Home',
            ),
            _buildTabItem(
              index: 1,
              icon: Ionicons.heart_sharp,
              label: 'Favorites',
            ),
            _buildTabItem(
              index: 2,
              icon: Ionicons.cart_outline,
              label: 'Cart',
            ),
            _buildTabItem(
              index: 3,
              icon: Ionicons.person_outline,
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: screens[currentTab],
    );
  }

  Widget _buildTabItem(
      {required int index, required IconData icon, required String label}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                currentTab == index ? Colors.deepPurple : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: currentTab == index
                  ? Colors.deepPurple
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
