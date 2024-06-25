import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/brand_profile_pages/screens/brandMain.dart';
import 'package:start_project/grad/sign_in.dart';

import '../brand_profile_pages/screens/main_screen_brand_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _splashScreen createState() => _splashScreen();
}

class _splashScreen extends State<SplashScreen> {
  @override
  void initState() {
    Future(
      () => Timer(
        const Duration(seconds: 1),
        () {
          if (FirebaseAuth.instance.currentUser != null) {
            FirebaseDatabase.instance
                .ref("users")
                .child(FirebaseAuth.instance.currentUser!.uid.toString())
                .once()
                .then(
              (value) {
                if (value.snapshot.exists) {
                  Map o = value.snapshot.value as Map;
                  var type = o.containsKey("type") ? o["type"] : "";
                  if (type == "user") {
                    Route route = MaterialPageRoute(
                      builder: (context) => MainScreenBrandProfile(),
                    );
                    Navigator.pushReplacement(context, route);
                  } else if (type == "brand") {
                    Route route = MaterialPageRoute(
                      builder: (context) => BrandMain(),
                    );
                    Navigator.pushReplacement(context, route);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("ERROR OCCURRED"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("ERROR OCCURRED"),
                    ),
                  );
                }
              },
            );
          } else {
            Route route = MaterialPageRoute(
              builder: (context) => SignInScreen(),
            );
            Navigator.pushReplacement(context, route);
          }
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72.0),
            child: Image.asset(
              "images/shopy-logo.png",
              height: 340,
            ),
          ),
        ),
      ),
    );
  }
}
