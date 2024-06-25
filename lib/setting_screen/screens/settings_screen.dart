import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_project/theme/theme.dart';
import '../../personal_profile_screens/profile.dart';
import '../models/setting.dart';
import '../widgets/avatar_card.dart';
import '../widgets/setting_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        title: Text(
          "Settings",
          style: TextStyle(color: lightColorScheme.primary,fontSize: 22),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const AvatarCard(),
              // const SizedBox(height: 20),
              // const Divider(),
              // const SizedBox(height: 10),
              Column(
                children: List.generate(
                  settings.length,
                  (index) => SettingTile(setting: settings[index]),
                ),
              ),
              const SizedBox(height: 10),
              // const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
