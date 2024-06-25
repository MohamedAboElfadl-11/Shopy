import 'package:flutter/material.dart';
import '../constants.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("images/avatar.png"),
            radius: 40,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: const Text(
                  "User name",
                  style: TextStyle(
                    fontSize: kbigFontSize,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "username@gmail.com",
                  style: TextStyle(
                    fontSize: ksmallFontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}