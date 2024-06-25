import 'package:flutter/material.dart';
import 'package:start_project/setting_screen/screens/settings_screen.dart';

import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/theme.dart';

class EditProfilePage extends StatefulWidget {

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // bool showPassword = false;
  //
  // // Define variables to hold brand profile data
  // String fullName = "Brand Name";
  // String email = "brand@example.com";
  // String phoneNumber = "";
  // String address = "";
  // String bio = "";
  // String brandCategory = "";
  // String coverImageUrl = "";
  String profileImageUrl = "";
  File? newImage;

  //
  // // Mock values for brand categories
  // List<String> brandCategories = [
  //   "Fashion",
  //   "Electronics",
  //   "Beauty",
  //   "Home & Garden",
  //   "Sports",
  // ];

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to handle image upload
  Future<void> _uploadImage(bool isCoverImage) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (isCoverImage) {
          // coverImageUrl = pickedImage.path;
        } else {
          newImage = File(pickedImage.path);
        }
      });
    }
  }

  TextEditingController nameCon = TextEditingController();

  // TextEditingController passwordCon = TextEditingController();
  // TextEditingController emailCon = TextEditingController();
  TextEditingController addressCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

  @override
  void initState() {

    FirebaseDatabase.instance
        .ref("users") .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map o = event.snapshot.value as Map;
        if (mounted) {
          setState(() {
            profileImageUrl = o.containsKey("image")?o["image"].toString():"";
            nameCon.text = o.containsKey("name")?o["name"].toString():"";
            addressCon.text = o.containsKey("address")?o["address"].toString():"";
            phoneCon.text = o.containsKey("number")?o["number"].toString():"";
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 26,
                    color: Colors.black,
                  )),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Edit Profile',
              style: TextStyle(
                  color: lightColorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      _uploadImage(false);
                    },
                    child: CircleAvatar(
                      backgroundImage: getImage(),
                      backgroundColor: Colors.grey.shade300,
                      radius: 64,
                    ),
                  ),
                  // Container(
                  //   width: 130,
                  //   height: 130,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       width: 4,
                  //       color: lightColorScheme.primary.withAlpha(40),
                  //     ),
                  //     // boxShadow: [
                  //     //   BoxShadow(
                  //     //     spreadRadius: 2,
                  //     //     blurRadius: 10,
                  //     //     color: Colors.black.withOpacity(0.1),
                  //     //     offset: const Offset(0, 10),
                  //     //   )
                  //     // ],
                  //     shape: BoxShape.circle,
                  //     image: newImage!=null
                  //         ? DecorationImage(
                  //             fit: BoxFit.cover,
                  //             image: FileImage(newImage!),
                  //           )
                  //         : null,
                  //   ),
                  //   child: profileImageUrl.isEmpty
                  //       ? IconButton(
                  //           icon: Icon(Icons.photo_camera,color: lightColorScheme.primary,size: 38,),
                  //           onPressed: () {
                  //             _uploadImage(true);
                  //           },
                  //         )
                  //       : Container(
                  //     child: Image.network(profileImageUrl,),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        color: Colors.deepPurple,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Full name';
                }
                return null;
              },
              controller: nameCon,
              decoration: InputDecoration(
                label: const Text('Full Name'),
                hintText: 'Enter Full Name',
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveData();
                // Save profile data
                // You can add your logic here to save the profile data to a database or elsewhere
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2.2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // GestureDetector(
            //   onTap: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: const Text("Confirm Delete"),
            //           content: const Text(
            //               "Are you sure you want to delete your account?"),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop(); // Close the dialog
            //               },
            //               child: const Text("Cancel"),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 // Add your logic to delete the account
            //                 Navigator.of(context).pop(); // Close the dialog
            //               },
            //               child: const Text("Delete"),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   child: const Text(
            //     "Delete Account",
            //     style: TextStyle(
            //       color: Colors.red,
            //       decoration: TextDecoration.underline,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //     border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
      //   ),
      //   child: SalomonBottomBar(
      //     currentIndex: 3, // Set the correct index for the current page
      //     backgroundColor: Colors.white,
      //     onTap: (index) {
      //       switch (index) {
      //         case 0:
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => DashboardScreen()),
      //           );
      //           break;
      //         case 1:
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => OrdersPage()),
      //           );
      //           break;
      //         case 2:
      //           // Add navigation logic for Messages page if you have one
      //           break;
      //         case 3:
      //           // Already on the Products page, no action needed
      //           break;
      //         case 4:
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => ProfilePage()),
      //           );
      //       }
      //     },
      //     items: [
      //       SalomonBottomBarItem(
      //         icon: const Icon(Icons.dashboard),
      //         title: const Text("Dashboard"),
      //       ),
      //       SalomonBottomBarItem(
      //         icon: const Icon(Icons.receipt_long),
      //         title: const Text("Orders"),
      //       ),
      //       SalomonBottomBarItem(
      //         icon: const Icon(Icons.message),
      //         title: const Text("Message"),
      //       ),
      //       SalomonBottomBarItem(
      //         icon: const Icon(
      //           Icons.inventory_2,
      //         ),
      //         title: const Text("Products",
      //             style: TextStyle(color: Color(0xFF684399))),
      //       ),
      //       SalomonBottomBarItem(
      //         icon: const Icon(Icons.account_circle, color: Color(0xFF684399)),
      //         title: const Text(
      //           "Account",
      //           style: TextStyle(color: Color(0xFF684399)),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> saveData() async {
    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();
    if (newImage != null) {
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(currentUid)
          .child("profileImage");
      var uploadTask = firebaseStorageRef.putFile(newImage!);
      var taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then((imageUrl) async {
        FirebaseDatabase.instance.ref("users").child(currentUid).update({
          "name": nameCon.text.trim().toString(),
          "address": addressCon.text.trim().toString(),
          "image": imageUrl,
          "number": phoneCon.text.trim().toString(),
        }).then((value) {
          Navigator.pop(context);
        });
      });
    } else {
      FirebaseDatabase.instance.ref("users").child(currentUid).update({
        "name": nameCon.text.trim().toString(),
        "address": addressCon.text.trim().toString(),
        "number": phoneCon.text.trim().toString(),
      }).then((value) {
        Navigator.pop(context);
      });
    }
  }

  getImage() {
    return newImage != null
        ? FileImage(newImage!)
        : profileImageUrl.isNotEmpty
            ? NetworkImage(profileImageUrl)
            : null;
  }

// Widget buildTextField(String labelText, String value,
//     bool isPasswordTextField, void Function(String?)? onChanged) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 20),
//     child: TextField(
//       obscureText: isPasswordTextField ? showPassword : false,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.only(bottom: 5),
//         labelText: labelText,
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         hintText: value,
//         hintStyle: const TextStyle(
//           fontSize: 16,
//           color: Colors.black,
//         ),
//         border: const OutlineInputBorder(),
//       ),
//     ),
//   );
// }
//
// Widget buildDropdown(String labelText, String value, List<String> items,
//     void Function(String?)? onChanged) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 20),
//     child: DropdownButtonFormField<String>(
//       value: value.isEmpty ? null : value,
//       onChanged: onChanged,
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.only(bottom: 5),
//         labelText: labelText,
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         border: const OutlineInputBorder(),
//       ),
//     ),
//   );
// }
}
