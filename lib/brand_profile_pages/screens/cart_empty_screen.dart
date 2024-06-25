import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../brand_profiles_structure/brand_profiles.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'messages_screen.dart';

class EmptyShopping extends StatefulWidget {
  const EmptyShopping({Key? key}) : super(key: key);

  @override
  _EmptyShoppingState createState() => _EmptyShoppingState();
}

class _EmptyShoppingState extends State<EmptyShopping> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/image-not-found.jpg',
              height: 200,
              color: Color(0xFF684399),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'No items in your cart',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF684399),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('BROWSE ITEMS'),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            switch (index) {
              case 0:
                Navigator.of(context).popUntil((route) => route.isFirst);
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoritePage()));
                break;
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
                break;
              case 3:
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Messages()));
                break;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.heart_sharp),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.cart_outline),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
