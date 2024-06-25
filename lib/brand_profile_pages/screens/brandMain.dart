import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:start_project/brand_profile_pages/screens/Notifications.dart';
import 'package:start_project/brand_profile_pages/screens/brandHome.dart';
import 'package:start_project/chat_screens/chats_screen.dart';
import 'package:start_project/grad/brandProfile-brandView.dart';
import 'package:start_project/grad/order.dart';
import '../../brand_profiles_structure/brand_profiles.dart';
import '../../personal_profile_screens/profile.dart';
import '../screens/cart_screen.dart';
import 'favorite_screen.dart';

class BrandMain extends StatefulWidget {
  const BrandMain({super.key});

  @override
  State<BrandMain> createState() => _brandMain();
}

class _brandMain extends State<BrandMain> {
  int currentTab = 0;
  List<Widget> screens = [
    BrandHome(),
    OrdersPage(),
    ChatsScreen(),
    ProfilePage()
    // BrandProfile(name: name, category: category, followers: followers, description: description, coverImage: coverImage, profileImage: profileImage),
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
              icon: Ionicons.reorder_four_sharp,
              label: 'Orders',
            ),
            _buildTabItem(
              index: 2,
              icon: Ionicons.chatbox,
              label: 'Messages',
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
/*
class _MainScreenBrandProfileState extends State<MainScreenBrandProfile> {

  int currentTab = 0;
  List screens =  [
    HomePage(),
    FavoritePage(),
    CartScreen(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Iconsax.home,
          color: Colors.white,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

       */
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(() {
                currentTab = 0;
              }),
              icon: Icon(
                Ionicons.home,
                color: currentTab == 0 ? Colors.deepPurple : Colors.grey.shade400,
              ),

            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 1;
              }),
              icon: Icon(
                Ionicons.heart_outline,
                color: currentTab == 1 ? Colors.deepPurple : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 2;
              }),
              icon: Icon(
                Ionicons.cart_outline,
                color: currentTab == 2 ? Colors.deepPurple : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                currentTab = 3;
              }),
              icon: Icon(
                Ionicons.person_outline,
                color: currentTab == 3 ? Colors.deepPurple : Colors.grey.shade400,
              ),
            ),

          ],
        ),
      ),
      body: screens[currentTab],
    );
  }


}

 */
