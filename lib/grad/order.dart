import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:start_project/chat_screens/chats_screen.dart';
import 'package:start_project/grad/product.dart';
import '../brand_profile_pages/jsonAnnotion/uploadNotification.dart';
import '../theme/theme.dart';
import 'brandDetailedOrder.dart';
import 'brandProfile-brandView.dart';
import 'dashboard.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List orders = [];
  // List ord = [];
  Map products = {};
  Map ordersValue = {};
  Map users = {};
  @override
  void initState() {
    FirebaseDatabase.instance.ref("users")
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            users = o;
          });
        }
      }else{
        if(mounted){
          setState(() {
            users = {};
          });
        }
      }
    });

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            products = o;
          });
        }
      }
    });
    FirebaseDatabase.instance.ref("orders")
        .onValue.listen((event) {
      if(event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            ordersValue = o;
          });
        }
        orders.clear();
        o.forEach((key, value) {
          var from = value["to"];
          if (from.toString() ==
              FirebaseAuth.instance.currentUser!.uid.toString()) {
            if (mounted) {
              setState(() {
                orders.add(value);
              });
            }
          }
        });
      }else{
        if(mounted){
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
        title: Text("Orders",style: TextStyle(
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
      body: ListView.builder(
        itemCount: orders.length,
        // shrinkWrap: true,
        itemBuilder: (context, index) {

          Map order = orders.elementAt(index) as Map;
          List orderProducts = order["products"];
          String state = order.containsKey("state")?order["state"]:"";
          String total = order.containsKey("total")?order["total"]:"";
          String from = order.containsKey("from")?order["from"]:"";

          Map user = users.containsKey(from)?users[from]:{};
          var userImage = user.containsKey("image")?user["image"]:"";
          var userName = user.containsKey("name")?user["name"]:"";
          var userNumber = user.containsKey("number")?user["number"]:"";

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => detailedOrder(order: order),
                  //   ),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),
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
                            child: const Text(
                              "From",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: lightColorScheme.primary.withAlpha(30)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: userImage.toString().isNotEmpty?
                                    NetworkImage(userImage):null,
                                    radius: 26,
                                    backgroundColor: Colors.grey.withAlpha(60),
                                  ),
                                  SizedBox(width: 12,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(userName,style: TextStyle(
                                          color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                      ),
                                      SizedBox(height: 8,),
                                      Text(userNumber,style: TextStyle(
                                          color: lightColorScheme.primary,fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Items',
                              style: TextStyle(fontSize: 16.0,color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:orderProducts.length,
                            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                            itemBuilder: (context, index) {
                              var amount = orderProducts.elementAt(index)["amount"];
                              Map product = products.containsKey(orderProducts.elementAt(index)["id"])?
                              products[orderProducts.elementAt(index)["id"]]:{};
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
                                  onTap: (){
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ProductScreen(product: product),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey.withAlpha(30)
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        image.isNotEmpty?CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            image,
                                          ),
                                          radius: 36,
                                        ):Container(
                                          width: 140,height: 120,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 12,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(name,style: TextStyle(
                                                  color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18
                                              ),),
                                              SizedBox(height: 4,),
                                              Text("amount: $amount",style: TextStyle(
                                                  color: Colors.black,fontSize: 18,fontWeight: FontWeight.normal
                                              ),),
                                            ],
                                          ),
                                        ),



                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },)
                        ],
                      ),

                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total Price:',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Text(
                            total +" EGP",
                            style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Order Status:',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: (){
                              if(state.isEmpty){
                                FirebaseDatabase.instance.ref("orders")
                                    .child(orders.elementAt(index)["id"]).child("state")
                                    .set("shipped").then((value){
                                  var upload = UploadNotification(FirebaseAuth.instance.currentUser!.uid.toString()
                                      , "shipped", orders.elementAt(index)["id"],
                                      "no",DateTime.now().microsecondsSinceEpoch);
                                  FirebaseDatabase.instance.ref("notifications")
                                      .child(orders.elementAt(index)["from"]).push()
                                      .set(upload.toJson()).then((value) {});
    });
                              }else if(state=="shipped"){
                                FirebaseDatabase.instance.ref("orders")
                                    .child(orders.elementAt(index)["id"]).child("state")
                                    .set("delivered").then((value){
                                  var upload = UploadNotification(FirebaseAuth.instance.currentUser!.uid.toString()
                                      , "delivered", orders.elementAt(index)["id"],
                                      "no",DateTime.now().microsecondsSinceEpoch);
                                  FirebaseDatabase.instance.ref("notifications")
                                      .child(orders.elementAt(index)["from"]).push()
                                      .set(upload.toJson()).then((value) {});
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: lightColorScheme.primary.withAlpha(30)
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                state.isEmpty?"Mark as shipped":state=="shipped"?
                                "mark as delivered":state == "delivered"?"Delivered":"",
                                style: TextStyle(fontSize: 18.0,color: lightColorScheme.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          );
        },
      ),

    );
  }
}

class Order {
  final String id;
  final String date;
  final int total;
  bool completed;

  Order({
    required this.id,
    required this.date,
    required this.total,
    this.completed = false,
  });
}

class OrderRow extends StatefulWidget {
  final Order order;

  OrderRow({required this.order});

  @override
  _OrderRowState createState() => _OrderRowState();
}

class _OrderRowState extends State<OrderRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandOwnerOrderDetails(
              orderData: {
                'orderNumber': widget.order.id,
                'orderDate': widget.order.date,
                'orderTotal': widget.order.total,
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: Row(
          children: [
            Checkbox(
              value: widget.order.completed,
              onChanged: (bool? value) {
                setState(() {
                  widget.order.completed = value ?? false;
                });
              },
            ),
            Expanded(child: Text(widget.order.id, textAlign: TextAlign.center)),
            Expanded(
                child: Text(widget.order.date, textAlign: TextAlign.center)),
            Expanded(
              child: Text(
                widget.order.total.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
