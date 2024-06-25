import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/theme/theme.dart';

import 'brand_profile_pages/screens/personal_brand_profile.dart';

class MyFollow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myFollow();
}

class _myFollow extends State<MyFollow> {
  List<Map> products = [];
  List<Map> searchList = [];
  Map brandsValue = {};
  List favorites = [];
  Map searchVV = {};
  Map productsValue = {};
  Map myFollowed = {};
  List myFollowedList = [];

  TextEditingController searchCon = TextEditingController();

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref("followed")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        myFollowedList.clear();
        o.forEach((key, value) {
          if (mounted) {
            setState(() {
              myFollowedList.add(key);
            });
          }
        });
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
        // brands.clear();
        // o.forEach((key, value) {
        //   var type = value["type"];
        //   var name = value["name"];
        //   if(type == "brand"){
        //     if(mounted){
        //       setState(() {
        //         searchVV[key]= {"name":name,
        //           "type":"brand","id":key.toString()};
        //         brands.add(key);
        //       });
        //     }
        //   }
        //
        // });
      } else {
        if (mounted) {
          setState(() {
            brandsValue = {};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        title: Text(
          "Following",
          style: TextStyle(color: lightColorScheme.primary, fontSize: 22),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: lightColorScheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: myFollowedList.length,
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          Map brandValue =
              brandsValue.containsKey(myFollowedList.elementAt(index))
                  ? brandsValue[myFollowedList.elementAt(index)]
                  : {};
          print("DDDDDDDDDDDDDDD $brandsValue");
          var image =
              brandValue.containsKey("image") ? brandValue["image"] : "";
          var name = brandValue.containsKey("name") ? brandValue["name"] : "";
          var address =
              brandValue.containsKey("address") ? brandValue["address"] : "";
          var phone =
              brandValue.containsKey("number") ? brandValue["number"] : "";
          // var name = product["name"];
          // var price = product["price"];
          // var desc = product["desc"];
          var id = myFollowedList.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      brand: brandValue,
                      brandId: myFollowedList.elementAt(index),
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
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200),
                        ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  if (myFollowed.containsKey(id)) {
                                    FirebaseDatabase.instance
                                        .ref("followed")
                                        .child(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .child(id)
                                        .remove()
                                        .then((value) {
                                      FirebaseDatabase.instance
                                          .ref("users")
                                          .child(id)
                                          .child("followers")
                                          .child(FirebaseAuth
                                              .instance.currentUser!.uid
                                              .toString())
                                          .remove();
                                    });
                                  } else {
                                    FirebaseDatabase.instance
                                        .ref("followed")
                                        .child(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .child(id)
                                        .set(id)
                                        .then((value) {
                                      FirebaseDatabase.instance
                                          .ref("users")
                                          .child(id)
                                          .child("followers")
                                          .child(FirebaseAuth
                                              .instance.currentUser!.uid
                                              .toString())
                                          .set(FirebaseAuth
                                              .instance.currentUser!.uid
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
                                    color: myFollowed.containsKey(id)
                                        ? lightColorScheme.primary.withAlpha(80)
                                        : lightColorScheme.primary,
                                    // color: cart.contains(widget.product["id"])?
                                    // lightColorScheme.primary.withAlpha(30):lightColorScheme.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      myFollowed.containsKey(id)
                                          ? "Unfollow"
                                          : "Follow"
                                      // cart.contains(widget.product["id"])?"Added to Cart":"Add to cart"
                                      ,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: myFollowed.containsKey(id)
                                              ? lightColorScheme.primary
                                              : Colors.white,
                                          // color: cart.contains(widget.product["id"])?
                                          // lightColorScheme.primary:Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
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
    );
  }
}
