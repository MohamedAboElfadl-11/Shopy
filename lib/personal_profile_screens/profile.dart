import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/myFollow.dart';
import 'package:start_project/personal_profile_screens/shippingAddress.dart';
import '../chat_screens/chats_screen.dart';
import '../personal_profile_screens/category_profile.dart';
import '../setting_screen/screens/settings_screen.dart';
import '../theme/theme.dart';
import 'myOrders.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  Map userValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance
        .ref("users") .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            userValue = o;
          });
        }
      }
    });
  }
    @override
  Widget build(BuildContext context) {
    var name = userValue["name"].toString();
    var image = userValue["image"].toString();
    var email = FirebaseAuth.instance.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: lightColorScheme.primary,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF684399),
                  backgroundImage:getImage(image),
                  radius: 50.0,
                ),
                SizedBox(width: 20.0),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        email.toString(),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // تحسين الكود باستخدام InkWell

          SizedBox(height: 24,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFollow(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  lightColorScheme.primary.withAlpha(30)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Followings',textAlign: TextAlign.center,
                  style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatsScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  lightColorScheme.primary.withAlpha(30)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Chats',textAlign: TextAlign.center,
                  style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrdersPage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  lightColorScheme.primary.withAlpha(30)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Orders',textAlign: TextAlign.center,
                  style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShippingAddressPage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  lightColorScheme.primary.withAlpha(30)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Address',textAlign: TextAlign.center,
                  style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:  lightColorScheme.primary.withAlpha(30)
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Settings',textAlign: TextAlign.center,
                  style: TextStyle(color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ChatsScreen()),
          //     );
          //   },
          //   child: Card(
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: category(
          //         text: 'My Chats',
          //         text1: '2 chats',
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 8),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => MyOrdersPage()),
          //     );
          //   },
          //   child: Card(
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: category(
          //         text: 'My orders',
          //         text1: 'Already have 10 orders',
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 8),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ShippingAddressPage()),
          //     );
          //   },
          //   child: Card(
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: category(
          //         text: 'Shipping Addresses',
          //         text1: '03 Addresses',
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 8),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SettingsScreen()),
          //     );
          //   },
          //   child: Card(
          //     margin: EdgeInsets.symmetric(horizontal: 10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(15),
          //       child: category(
          //         text: 'Setting',
          //         text1: 'Notification, Password, FAQ, Contact',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  getImage(String image) {
    return image.isNotEmpty?NetworkImage(image): AssetImage(
      'images/image-not-found.jpg',
    );
  }
}
