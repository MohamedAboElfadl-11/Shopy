import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_project/grad/sign_in.dart';
import '../constants.dart';
import '../models/setting.dart';
import '../screens/edit_page.dart';
import '../screens/help_support_screen.dart';
import '../screens/privacy_screen.dart';

class SettingTile extends StatelessWidget {
  final Setting setting;

  const SettingTile({
    Key? key,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Edit Profile page when Personal Data button is tapped
        if (setting.route == '/edit_page') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
        }
        else if(setting.route == '/privacy_screen'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
        }
        else if(setting.route == '/help_support_screen'){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportPage()));
        }
        else if(setting.route == '/logout'){
        if(FirebaseAuth.instance.currentUser!=null){
          FirebaseAuth.instance.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
          });
        }
        }
        // Add additional navigation logic for other settings if needed
      },
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: klightContentColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(setting.icon, color: kprimaryColor),
          ),
          const SizedBox(width: 10),
          Text(
            setting.title,
            style: const TextStyle(
              color: kprimaryColor,
              fontSize: ksmallFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

