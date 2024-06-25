import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ionicons/ionicons.dart';
import 'package:start_project/brand_profile_pages/screens/product_screen.dart';
import 'package:start_project/grad/AddProduct.dart';
import 'package:start_project/grad/editProduct.dart';

import '../../theme/theme.dart';
import '../constants.dart';
import '../widgets/categories.dart';
import '../models/products.dart';
import '../widgets/home_slider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'messages_screen.dart';

class BrandHome extends StatefulWidget {
  //  Map brand;
  //  String brandId;
  // // final String email;
  //  HomeScreen({
  //   required this.brand,
  //   required this.brandId,
  // });
      // required this.phone,
      // required this.email})
      // : super(key: key);

  @override
  State<BrandHome> createState() => _brandHome();
}

class _brandHome extends State<BrandHome> {
  int currentTab = 0;
  List<Map> products = [];
  List<Map> searchList = [];

  @override
  void initState() {

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        products.clear();
        o.forEach((key, value) {
          var from = value["from"].toString();
          if(from == FirebaseAuth.instance.currentUser!.uid.toString())
          if(mounted){
            setState(() {
              products.add(value);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("HOME",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: lightColorScheme.primary,
        ),),
        elevation: 0,
        toolbarHeight: 64,
        actionsIconTheme: IconThemeData(
          color: lightColorScheme.primary,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: kscaffoldColor,
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductScreen(),));
      },
        backgroundColor: lightColorScheme.primary,
        child: Icon(Icons.add,color: Colors.white,size: 28,),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("All Products",style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
            ),
            Expanded(
              child: products.isEmpty?Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("There is no Products added yet",style: TextStyle(
                      fontSize: 20,color: Colors.black54
                  ),),
                ),
              ):ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  Map product = products.elementAt(index);
                  var image = product["image"];
                  var name = product["name"];
                  var price = product["price"];
                  var desc = product["desc"];
                  var id = product["id"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withAlpha(20)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius:BorderRadius.circular(15),
                              child: Image.network(
                                image,width: 140,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,style: TextStyle(
                                        color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
                                    ),),
                                    SizedBox(height: 8,),
                                    Text(price+" EGP",style: TextStyle(
                                        color: lightColorScheme.primary,fontWeight: FontWeight.bold,fontSize: 18
                                    ),),
                                    SizedBox(height: 8,),
                                    Text(desc,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                                        color: Colors.black54,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal
                                        ,fontSize: 18
                                    ),),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  );
                },),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed, // Ensure all items are displayed
      //   selectedItemColor: Colors.deepPurple,
      //   unselectedItemColor:
      //       Colors.grey, // Set a different color for unselected items
      //   currentIndex: currentTab,
      //   onTap: (int index) {
      //     setState(() {
      //       currentTab = index;
      //       switch (index) {
      //         case 0:
      //           Navigator.of(context).popUntil((route) => route.isFirst);
      //           break;
      //         case 1:
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => FavoritePage()));
      //           break;
      //         case 2:
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => CartScreen()));
      //           break;
      //         case 3:
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => Messages()));
      //           break;
      //       }
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Ionicons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Ionicons.heart_sharp),
      //       label: 'Favorites',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Ionicons.cart_outline),
      //       label: 'Cart',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat_outlined),
      //       label: 'Messages',
      //     ),
      //   ],
      // ),
    );
  }
}
