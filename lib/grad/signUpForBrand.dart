import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:start_project/brand_profile_pages/jsonAnnotion/uploadUser.dart';
import 'package:start_project/brand_profile_pages/screens/brandMain.dart';
import 'package:start_project/grad/sign_in.dart';

import '../theme/theme.dart';

class SignUpForBrand extends StatefulWidget {
  const SignUpForBrand({super.key});

  @override
  State<SignUpForBrand> createState() => _signUpForBrand();
}

class _signUpForBrand extends State<SignUpForBrand> {
  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;

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
            key: _formSignupKey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "images/shopy-logo.png",
                  height: 340,
                ),
                Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.shadow,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // full name
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Brand Name';
                    }
                    return null;
                  },
                  controller: nameCon,
                  decoration: InputDecoration(
                    label: const Text('Brand Name'),
                    hintText: 'Enter Brand Name',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                  controller: addressCon,
                  decoration: InputDecoration(
                    label: const Text('Address'),
                    hintText: 'Enter Address',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Phone Number';
                    }
                    return null;
                  },
                  controller: phoneCon,
                  decoration: InputDecoration(
                    label: const Text('Phone Number'),
                    hintText: 'Enter Phone Number',
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
                // email
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
                // password
                TextFormField(
                  obscureText: true,
                  controller: passwordCon,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    }
                    return null;
                  },
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
                  height: 44.0,
                ),
                // i agree to the processing
                // Row(
                //   children: [
                //     Checkbox(
                //       value: agreePersonalData,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           agreePersonalData = value!;
                //         });
                //       },
                //       activeColor: lightColorScheme.primary,
                //     ),
                //     const Text(
                //       'I agree to the processing of ',
                //       style: TextStyle(
                //         color: Colors.black45,
                //       ),
                //     ),
                //     Text(
                //       'Personal data',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: lightColorScheme.primary,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 25.0,
                // ),
                // signup button
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () async {
                      if (_formSignupKey.currentState!.validate() &&
                          agreePersonalData) {
                        showLoaderDialog(context);
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        var name = nameCon.text.trim().toString();
                        var address = addressCon.text.trim().toString();
                        var email = emailCon.text.trim().toString();
                        var phone = phoneCon.text.trim().toString();
                        var password = passwordCon.text.trim().toString();
                        if (name.isNotEmpty &&
                            address.isNotEmpty &&
                            email.isNotEmpty &&
                            phone.isNotEmpty &&
                            password.length >= 6) {
                          try {
                            await auth
                                .createUserWithEmailAndPassword(
                                    email: email, password: password)
                                .then((result) {
                              var upload =
                                  UploadUser(name, "", phone, address, "brand");
                              FirebaseDatabase.instance
                                  .ref("users")
                                  .child(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  .set(upload.toJson())
                                  .then((value) {
                                Navigator.pop(context);
                                Route route = MaterialPageRoute(
                                    builder: (context) => BrandMain());
                                Navigator.pushReplacement(context, route);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.indigo,
                                  content: Text(
                                    "A new Account created for $email",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ));
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Error ${e.message}"),
                            ));
                          }
                        }
                      } else if (!agreePersonalData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please agree to the processing of personal data',
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightColorScheme.primary),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: const Text(
                          'Sign up',
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
                // already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
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
                            builder: (e) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
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
                      "Creating New Account",
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
