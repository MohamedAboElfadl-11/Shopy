import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_project/grad/sign_in.dart';
import '../../grad/logo.dart';
import '../screens/edit_page.dart';
import '../screens/help_support_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/settings_screen.dart';

class Setting {
  final String title;
  final String route;
  final IconData icon;

  Setting({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<Setting> settings = [
  Setting(
    title: "Edit Personal Data",
    route: "/edit_page",
    icon: CupertinoIcons.person_fill,
  ),
  Setting(
    title: "Privacy Policy",
    route: "/privacy_screen",
    icon: Icons.security,
  ),

  Setting(
    title: "Help & Support",
    route: "/help_support_screen",
    icon: Icons.help,
  ),
  Setting(
    title: "Logout",
    route: "/logout",
    icon: Icons.logout,
  )
];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SettingsScreen(),
      '/edit_page': (context) => EditProfilePage(),
      '/privacy' : (context) => PrivacyPolicyPage(),
      '/help' : (context) => HelpSupportPage(),
      '/logout' : (context) => SignInScreen(),
    },
  ));
}

