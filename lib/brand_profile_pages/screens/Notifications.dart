import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/theme/theme.dart';

import '../models/products.dart';

class MyNotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_myNotificationScreen();

}
class _myNotificationScreen extends State<MyNotificationScreen> {

  List notifications =[];
  Map notificationsValue = {};
  // Map products = {};
  Map usersValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("users")
    // .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            usersValue = o;
          });
        }
      }else{
        if(mounted){
          setState(() {
            usersValue.clear();
          });
        }
      }
    });


    FirebaseDatabase.instance.ref("notifications")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            notificationsValue = o;
          });
        }
        notifications.clear();
        o.forEach((key, value) {
          if(mounted){
            setState(() {
              notifications.add(key);
            });
          }
        });
      }else{
        if(mounted){
          setState(() {
            notifications.clear();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 64,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: lightColorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Notifications',
                style: TextStyle(color: lightColorScheme.primary,fontSize: 22),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {

            Map o = notificationsValue.containsKey(notifications.elementAt(index))?
                notificationsValue[notifications.elementAt(index)]:{};
            var from = o.containsKey("from")?o["from"]:"";
            var type = o.containsKey("type")?o["type"]:"";
            var seen = o.containsKey("seen")?o["seen"]:"";
            // print("SSSSSSSSSSSSSSS $usersValue");
            Map user = usersValue.containsKey(from)?usersValue[from]:{};
            var userName = user.containsKey("name")?user["name"]:"";
            var userImage = user.containsKey("image")?user["image"]:"";

          return InkWell(
            onTap: (){
             if(seen != "seen"){
               FirebaseDatabase.instance.ref("notifications")
                   .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(notifications.elementAt(index))
                   .child("seen").set("seen");
             }
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: seen=="seen"?Colors.transparent:
                lightColorScheme.primary.withAlpha(40)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 70.0,
                    height: 70.0,
                    child: CircleAvatar(
                      backgroundImage:  NetworkImage(userImage),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            userName+"${type == "shipped"?" Shipped Your Order"
                            :type == "delivered"?" has been delivered your order":""}",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Text(
                        //   snapshot.data![index].description,
                        //   style: TextStyle(fontSize: 16.0),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },)
      ),
    );
  }
}

class ApplicationScreen extends StatefulWidget {
  @override
  _ApplicationScreenState createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late Future<List<NotificationItem>> futureNotifications;

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationItem>>(
      future: futureNotifications,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(snapshot.data![index].product.image), // استخدام صور المنتجات من كلاس Product
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data![index].status,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                snapshot.data![index].description,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 16.0,
                    thickness: 1.0,
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }
        // By default, show a loading spinner
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<NotificationItem>> fetchNotifications() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    final List<NotificationItem> notifications = [];

    for (int i = 0; i < 10; i++) {
      notifications.add(
        NotificationItem(
          product: products[Random().nextInt(products.length)], // استخدام منتج عشوائي من كلاس Product
          status: _randomStatus(),
          description: _randomDescription(),
        ),
      );
    }

    return notifications;
  }

  String _randomStatus() {
    List<String> statuses = ['Confirmed', 'Shipped', 'Cancelled'];
    return statuses[Random().nextInt(statuses.length)];
  }

  String _randomDescription() {
    List<String> descriptions = [
      'Your order has been confirmed.',
      'Your order has been shipped.',
      'Your order has been cancelled.'
    ];
    return descriptions[Random().nextInt(descriptions.length)];
  }
}

class NotificationItem {
  final Product product;
  final String status;
  final String description;

  NotificationItem({
    required this.product,
    required this.status,
    required this.description,
  });
}