import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ionicons/ionicons.dart';
import 'package:start_project/brand_profile_pages/screens/product_screen.dart';

import '../../theme/theme.dart';
import '../constants.dart';
import '../widgets/categories.dart';
import '../models/products.dart';
import '../widgets/home_slider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'messages_screen.dart';

class HomeScreen extends StatefulWidget {
  Map brand;
  String brandId;
  // final String email;
  HomeScreen({
    required this.brand,
    required this.brandId,
  });
  // required this.phone,
  // required this.email})
  // : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  List<Map> products = [];
  List<Map> searchList = [];
  List favorites = [];
  Map myFollowed = {};
  @override
  void initState() {
    FirebaseDatabase.instance
        .ref("favorites")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        favorites.clear();
        o.forEach((key, value) {
          if (mounted) {
            setState(() {
              favorites.add(key);
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            favorites.clear();
          });
        }
      }
    });

    FirebaseDatabase.instance
        .ref("followed")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            myFollowed = o;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            myFollowed = {};
          });
        }
      }
    });

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        products.clear();
        o.forEach((key, value) {
          var from = value["from"].toString();
          if (from == widget.brandId) if (mounted) {
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
    Map followers =
        widget.brand.containsKey("followers") ? widget.brand["followers"] : {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.brand["name"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: lightColorScheme.primary,
          ),
        ),
        elevation: 0,
        toolbarHeight: 64,
        actionsIconTheme: IconThemeData(
          color: lightColorScheme.primary,
        ),
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(widget.brand["number"]),
                  ),
                ),
                // PopupMenuItem(
                //   child: ListTile(
                //     leading: Icon(Icons.email),
                //     title: Text(widget.email),
                //   ),
                // ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                    onTap: () async {
                      await FlutterShare.share(
                        title: 'Share Brand',
                        text: 'Check out this brand: ${widget.brand["name"]}',
                        linkUrl: 'https://example.com',
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // color: Colors.grey.withAlpha(30)
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.brand["image"].toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget.brand["image"],
                                ),
                                radius: 44,
                              )
                            : CircleAvatar(
                                radius: 44,
                                backgroundColor: Colors.grey.withAlpha(40),
                              ),
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.brand["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${widget.brand["address"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${widget.brand["number"]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${followers.length} followers",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // const Categories(),
                  // const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: const Text(
                          "Brand Products",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return Column(
                      //           crossAxisAlignment: CrossAxisAlignment.stretch,
                      //           children: [
                      //             ListTile(
                      //               title: Text('All Products'),
                      //               trailing: IconButton(
                      //                 icon: Icon(Icons.close),
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //               ),
                      //             ),
                      //             Expanded(
                      //               child: ListView.builder(
                      //                 itemCount: products.length,
                      //                 itemBuilder: (context, index) {
                      //                   return ProductCard(
                      //                       product1: products[index]);
                      //                 },
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: const Text(
                      //     "See all",
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductScreen(product: product),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  image,
                                  width: 140,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      price + " EGP",
                                      style: TextStyle(
                                          color: lightColorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      desc,
                                      maxLines: 2,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseDatabase.instance
                                      .ref("favorites")
                                      .child(FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString())
                                      .child(id)
                                      .set(id);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.favorite,
                                    color: favorites.contains(id)
                                        ? Colors.red
                                        : Colors.black45,
                                    size: 28,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )

                  // GridView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     crossAxisSpacing: 20,
                  //     mainAxisSpacing: 20,
                  //   ),
                  //   itemCount: products.length,
                  //   itemBuilder: (context, index) {
                  //     return ProductCard(product1: products[index]);
                  //   },
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (myFollowed.containsKey(widget.brandId)) {
                          FirebaseDatabase.instance
                              .ref("followed")
                              .child(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .child(widget.brandId)
                              .remove()
                              .then((value) {
                            FirebaseDatabase.instance
                                .ref("users")
                                .child(widget.brandId)
                                .child("followers")
                                .child(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .remove();
                          });
                        } else {
                          FirebaseDatabase.instance
                              .ref("followed")
                              .child(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .child(widget.brandId)
                              .set(widget.brandId)
                              .then((value) {
                            FirebaseDatabase.instance
                                .ref("users")
                                .child(widget.brandId)
                                .child("followers")
                                .child(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .set(FirebaseAuth.instance.currentUser!.uid
                                    .toString());
                          });
                        }
                        // if(!cart.contains(widget.product["id"])){
                        //   FirebaseDatabase.instance.ref("cart")
                        //       .child(FirebaseAuth.instance.currentUser!.uid.toString())
                        //       .child(widget.product["id"]).set({"id":widget.product["id"],
                        //     "amount":"1"});
                        //
                        // }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: myFollowed.containsKey(widget.brandId)
                              ? lightColorScheme.primary.withAlpha(80)
                              : lightColorScheme.primary,
                          // color: cart.contains(widget.product["id"])?
                          // lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            myFollowed.containsKey(widget.brandId)
                                ? "Unfollow"
                                : "Follow"
                            // cart.contains(widget.product["id"])?"Added to Cart":"Add to cart"
                            ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: myFollowed.containsKey(widget.brandId)
                                    ? lightColorScheme.primary
                                    : Colors.white,
                                // color: cart.contains(widget.product["id"])?
                                // lightColorScheme.primary:Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                                userName: widget.brand["name"],
                                userId: widget.brandId),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: lightColorScheme.primary.withAlpha(120),
                        // color: cart.contains(widget.product["id"])?
                        // lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.message,
                            color: lightColorScheme.primary,
                          )),
                    ),
                  ),
                ],
              ),
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
