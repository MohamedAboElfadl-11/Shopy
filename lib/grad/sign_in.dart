import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../brand_profile_pages/screens/brandMain.dart';
import '../brand_profile_pages/screens/main_screen_brand_profile.dart';
import '../theme/theme.dart';
import 'chooseAccount.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Form(
            key: _formSignInKey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                // get started text
                Image.asset(
                  "images/shopy-logo.png",
                  height: 340,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.shadow,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                  controller: emailCon,
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
                  controller: passwordCon,
                  decoration: InputDecoration(
                    label: const Text('Password'),
                    hintText: 'Enter Password',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () async {
                      if (_formSignInKey.currentState!.validate() &&
                          rememberPassword) {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        showLoaderDialog(context);
                        var email = emailCon.text.trim().toString();
                        var password = passwordCon.text.trim().toString();
                        if (email.isNotEmpty && password.isNotEmpty) {
                          try {
                            await auth
                                .signInWithEmailAndPassword(
                                    email: email, password: password)
                                .then((value) {
                              FirebaseDatabase.instance
                                  .ref("users")
                                  .child(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  .once()
                                  .then((value) {
                                if (value.snapshot.exists) {
                                  Map o = value.snapshot.value as Map;
                                  var type =
                                      o.containsKey("type") ? o["type"] : "";
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Signed in"),
                                  ));
                                  if (type == "user") {
                                    Route route = MaterialPageRoute(
                                        builder: (context) =>
                                            MainScreenBrandProfile());
                                    Navigator.pushReplacement(context, route);
                                  } else if (type == "brand") {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => BrandMain());
                                    Navigator.pushReplacement(context, route);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("ERROR OCCURRED"),
                                    ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("ERROR OCCURRED"),
                                  ));
                                }
                              });
                            });
                          } on FirebaseException catch (e) {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error ${e.message}"),
                            ));
                          }
                        }
                      } else if (!rememberPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please agree to the processing of personal data'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: lightColorScheme.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: const Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),

                // don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => ChooseAccount(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.all(12),
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                child: Column(
                  children: [
                    // SizedBox(width: 24,),
                    Spacer(),
                    Text(
                      "Signing In...",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: 140,
                      height: 4,
                      child: LinearProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
