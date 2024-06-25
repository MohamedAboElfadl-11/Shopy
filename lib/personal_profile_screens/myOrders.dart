import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../theme/theme.dart';
import 'detailedOrder.dart'; // Ensure to import the detailed order screen

class MyOrdersPage extends StatefulWidget {
  @override
  State<MyOrdersPage> createState() => _myOrdersPage();

  // @override
  // Widget build(BuildContext context) =>_myOrdersPage();
}

class _myOrdersPage extends State<MyOrdersPage> {
  List orders = [];
  // List ord = [];
  Map products = {};
  Map ordersValue = {};
  @override
  void initState() {
    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            products = o;
          });
        }
      }
    });
    FirebaseDatabase.instance.ref("orders").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            ordersValue = o;
          });
        }
        orders.clear();
        o.forEach((key, value) {
          var from = value["from"];
          if (from.toString() ==
              FirebaseAuth.instance.currentUser!.uid.toString()) {
            if (mounted) {
              setState(() {
                orders.add(value);
              });
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            orders.clear();
          });
        }
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
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Row(
          children: [
            Text(
              'My Orders',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: lightColorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        // shrinkWrap: true,
        itemBuilder: (context, index) {
          Map order = orders.elementAt(index) as Map;
          List orderProducts = order["products"];
          String state = order.containsKey("state") ? order["state"] : "";
          String total = order.containsKey("total") ? order["total"] : "";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   orderNumber,
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16.0,
                  //   ),
                  // ),
                  const SizedBox(height: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Items',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orderProducts.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        itemBuilder: (context, index) {
                          var amount = orderProducts.elementAt(index)["amount"];
                          Map product = products.containsKey(
                                  orderProducts.elementAt(index)["id"])
                              ? products[orderProducts.elementAt(index)["id"]]
                              : {};
                          // print("QQQQQQQQQQQQQQQQQQQ ${orderProducts}");

                          var image = product["image"];
                          var name = product["name"];
                          // var price = product["price"];
                          // var desc = product["desc"];
                          // var id = product["id"];
                          // var stock = product["stock"];
                          // int amount = int.parse(o["amount"]);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductScreen(product: product),
                                //   ),
                                // );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.withAlpha(30)),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    image.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              image,
                                            ),
                                            radius: 36,
                                          )
                                        : Container(
                                            width: 140,
                                            height: 120,
                                            color: Colors.red,
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
                                            name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "amount: $amount",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Order Status:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Spacer(),
                      Text(
                        state,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: lightColorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Price:',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Text(
                        total + " EGP",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: lightColorScheme.primary),
                      ),
                    ],
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

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String orderStatus;
  final String items;
  final String price;

  const OrderCard({
    Key? key,
    required this.orderNumber,
    required this.orderStatus,
    required this.items,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderNumber,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Items:',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Text(
                  items,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Order Status:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Spacer(),
                Text(
                  orderStatus,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Price:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
