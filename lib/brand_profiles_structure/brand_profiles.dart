import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/theme/theme.dart';

import '../brand_profile_pages/screens/Notifications.dart';
import '../brand_profile_pages/screens/personal_brand_profile.dart';
import '../brand_profile_pages/screens/product_screen.dart';
import 'brand_profile_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  late List<BrandProfile> _searchResults;
  List<Map> products = [];
  List<Map> searchList = [];
  Map brandsValue = {};
  List favorites = [];
  List brands = [];
  Map searchVV = {};
  Map productsValue = {};
  Map myFollowed = {};

  TextEditingController searchCon = TextEditingController();

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

    FirebaseDatabase.instance
        .ref("users")
        // .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            brandsValue = o;
          });
        }
        brands.clear();
        o.forEach((key, value) {
          var type = value["type"];
          var name = value["name"];
          if (type == "brand") {
            if (mounted) {
              setState(() {
                searchVV[key] = {
                  "name": name,
                  "type": "brand",
                  "id": key.toString()
                };
                brands.add(key);
              });
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            brands.clear();
          });
        }
      }
    });

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            productsValue = o;
          });
        }
        o.forEach((key, value) {
          var name = value["name"];
          if (mounted) {
            setState(() {
              searchVV[key] = {
                "name": name,
                "type": "product",
                "id": key.toString()
              };
              products.add(value);
            });
          }
        });
      }
    });
  }

  void _search(String v) {
    //print("WWWWWWWWWWWWWWWWw $searchVV");
    setState(() {
      searchList.clear();
    });
    searchVV.forEach((key, value) {
      var name = value["name"];
      // print("DSAAAAAAAAAAAAA $name");
      if (name.toString().toLowerCase().contains(v)) {
        setState(() {
          searchList.add(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 64,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            'Shopy',
            style: TextStyle(
              fontSize: 26.0,
              color: lightColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyNotificationScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications,
                color: lightColorScheme.primary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: lightColorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  cursorHeight: 20,
                  controller: searchCon,
                  autofocus: false,
                  onChanged: (v) {
                    _search(v);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            //const SizedBox(height: 15),
            Expanded(
              child: searchCon.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchList.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      itemBuilder: (context, index) {
                        var type = searchList.elementAt(index)["type"];
                        var id = searchList.elementAt(index)["id"];
                        Map product = productsValue.containsKey(id)
                            ? productsValue[id]
                            : {};
                        var imageP = product["image"];
                        var nameP = product["name"];
                        var price = product["price"];
                        var desc = product["desc"];

                        Map brandValue =
                            brandsValue.containsKey(id) ? brandsValue[id] : {};
                        var image = brandValue.containsKey("image")
                            ? brandValue["image"]
                            : "";
                        var name = brandValue.containsKey("name")
                            ? brandValue["name"]
                            : "";
                        var address = brandValue.containsKey("address")
                            ? brandValue["address"]
                            : "";
                        var phone = brandValue.containsKey("number")
                            ? brandValue["number"]
                            : "";

                        return type == "product"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          imageP,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nameP,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              price + " EGP",
                                              style: TextStyle(
                                                  color:
                                                      lightColorScheme.primary,
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
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (favorites.contains(id)) {
                                            FirebaseDatabase.instance
                                                .ref("favorites")
                                                .child(FirebaseAuth
                                                    .instance.currentUser!.uid
                                                    .toString())
                                                .child(id)
                                                .remove();
                                          } else {
                                            FirebaseDatabase.instance
                                                .ref("favorites")
                                                .child(FirebaseAuth
                                                    .instance.currentUser!.uid
                                                    .toString())
                                                .child(id)
                                                .set(id);
                                          }
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
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          brand: brandValue,
                                          brandId: brands.elementAt(index),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      image.toString().isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.network(
                                                image,
                                                width: double.infinity,
                                                height: 180,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 180,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (myFollowed
                                                          .containsKey(id)) {
                                                        FirebaseDatabase
                                                            .instance
                                                            .ref("followed")
                                                            .child(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                                .toString())
                                                            .child(id)
                                                            .remove()
                                                            .then((value) {
                                                          FirebaseDatabase
                                                              .instance
                                                              .ref("users")
                                                              .child(id)
                                                              .child(
                                                                  "followers")
                                                              .child(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString())
                                                              .remove();
                                                        });
                                                      } else {
                                                        FirebaseDatabase
                                                            .instance
                                                            .ref("followed")
                                                            .child(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                                .toString())
                                                            .child(id)
                                                            .set(id)
                                                            .then((value) {
                                                          FirebaseDatabase
                                                              .instance
                                                              .ref("users")
                                                              .child(id)
                                                              .child(
                                                                  "followers")
                                                              .child(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
                                                                  .toString())
                                                              .set(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: myFollowed
                                                                .containsKey(id)
                                                            ? lightColorScheme
                                                                .primary
                                                                .withAlpha(80)
                                                            : lightColorScheme
                                                                .primary,
                                                        // color: cart.contains(widget.product["id"])?
                                                        // lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Text(
                                                          myFollowed
                                                                  .containsKey(
                                                                      id)
                                                              ? "Unfollow"
                                                              : "Follow"
                                                          // cart.contains(widget.product["id"])?"Added to Cart":"Add to cart"
                                                          ,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: myFollowed
                                                                      .containsKey(
                                                                          id)
                                                                  ? lightColorScheme
                                                                      .primary
                                                                  : Colors
                                                                      .white,
                                                              // color: cart.contains(widget.product["id"])?
                                                              // lightColorScheme.primary:Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              phone,
                                              style: TextStyle(
                                                  color:
                                                      lightColorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              address,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    )
                  : ListView.builder(
                      itemCount: brands.length,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        Map brandValue =
                            brandsValue.containsKey(brands.elementAt(index))
                                ? brandsValue[brands.elementAt(index)]
                                : {};
                        print("DDDDDDDDDDDDDDD $brandsValue");
                        var image = brandValue.containsKey("image")
                            ? brandValue["image"]
                            : "";
                        var name = brandValue.containsKey("name")
                            ? brandValue["name"]
                            : "";
                        var address = brandValue.containsKey("address")
                            ? brandValue["address"]
                            : "";
                        var phone = brandValue.containsKey("number")
                            ? brandValue["number"]
                            : "";
                        // var name = product["name"];
                        // var price = product["price"];
                        // var desc = product["desc"];
                        var id = brands.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    brand: brandValue,
                                    brandId: brands.elementAt(index),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                image.toString().isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          image,
                                          width: double.infinity,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 180,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade200),
                                      ),
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                if (myFollowed
                                                    .containsKey(id)) {
                                                  FirebaseDatabase.instance
                                                      .ref("followed")
                                                      .child(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid
                                                          .toString())
                                                      .child(id)
                                                      .remove()
                                                      .then((value) {
                                                    FirebaseDatabase.instance
                                                        .ref("users")
                                                        .child(id)
                                                        .child("followers")
                                                        .child(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid
                                                            .toString())
                                                        .remove();
                                                  });
                                                } else {
                                                  FirebaseDatabase.instance
                                                      .ref("followed")
                                                      .child(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid
                                                          .toString())
                                                      .child(id)
                                                      .set(id)
                                                      .then((value) {
                                                    FirebaseDatabase.instance
                                                        .ref("users")
                                                        .child(id)
                                                        .child("followers")
                                                        .child(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid
                                                            .toString())
                                                        .set(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: myFollowed
                                                          .containsKey(id)
                                                      ? lightColorScheme.primary
                                                          .withAlpha(80)
                                                      : lightColorScheme
                                                          .primary,
                                                  // color: cart.contains(widget.product["id"])?
                                                  // lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Text(
                                                    myFollowed.containsKey(id)
                                                        ? "Unfollow"
                                                        : "Follow"
                                                    // cart.contains(widget.product["id"])?"Added to Cart":"Add to cart"
                                                    ,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: myFollowed
                                                                .containsKey(id)
                                                            ? lightColorScheme
                                                                .primary
                                                            : Colors.white,
                                                        // color: cart.contains(widget.product["id"])?
                                                        // lightColorScheme.primary:Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        phone,
                                        style: TextStyle(
                                            color: lightColorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        address,
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ));
  }
}
