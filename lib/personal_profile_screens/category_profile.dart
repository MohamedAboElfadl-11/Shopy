import 'package:flutter/material.dart';

import '../setting_screen/screens/settings_screen.dart';

class category extends StatelessWidget {
  final String? text;
  final String? text1;

  category({this.text, this.text1});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () {
            // Navigate to corresponding page
            if (text == 'Followed Brands') {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => FollowedBrandsPage()),);
            } else if (text == 'Setting') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            }
            // Add more conditions for other categories if needed
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$text',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '$text1',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to corresponding page
                    if (text == 'Followed Brands') {
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => FollowedBrandsPage()),);
                    } else if (text == 'Setting') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    }
                    // Add more conditions for other categories if needed
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_sharp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
