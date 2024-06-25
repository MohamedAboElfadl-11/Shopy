import 'package:flutter/material.dart';
import '../brand_profile_pages/screens/messages_screen.dart';
import 'chat_card.dart';
import 'chatt.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String searchQuery = '';

  void openChatScreen() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ChatPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = chatsData.where((chat) {
      return chat.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        if (filteredChats.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Not Found', style: TextStyle(color: Colors.red)),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredChats.length,
            itemBuilder: (context, index) => ChatCard(
              chat: filteredChats[index],
              onPressed: openChatScreen,
            ),
          ),
        ),
      ],
    );
  }
}
