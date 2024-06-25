import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:start_project/brand_profile_pages/screens/messages_screen.dart';
import 'package:start_project/chat_screens/chatt.dart';
import 'package:start_project/theme/theme.dart';
import 'body.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _chatsScreen();
  // const ChatsScreen({Key? key}) : super(key: key);
}
  class _chatsScreen extends State<ChatsScreen> {

  List messagers = [];
  // Map products = {};
  Map usersValue = {};
  Map messagesValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("users")
    // .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            usersValue = o;
          });
        }
      }else{
        if(mounted){
          setState(() {
            usersValue.clear();
          });
        }
      }
    });


    FirebaseDatabase.instance.ref("messages")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            messagesValue = o;
          });
        }
        messagers.clear();
        o.forEach((key, value) {
          if(mounted){
            setState(() {
              messagers.add(key);
            });
          }
        });
      }else{
        if(mounted){
          setState(() {
            messagers.clear();
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
        // shadowColor: Colors.white,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title:  Text(
          "My Chats",
          style: TextStyle(
            fontSize: 22,
            color: lightColorScheme.primary,
          ),
        ),
      ),
      body: messagers.isEmpty?Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text("You have no messages yet",style: TextStyle(
              fontSize: 20,color: Colors.black54
          ),),
        ),
      ):ListView.builder(
        itemCount: messagers.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map o = messagesValue.containsKey(messagers.elementAt(index))?
              messagesValue[messagers.elementAt(index)]:{};
          Map user = usersValue.containsKey(messagers.elementAt(index))?
              usersValue[messagers.elementAt(index)]:{};

        var userImage = user.containsKey("image")?user["image"]:"";
        var userName = user.containsKey("name")?user["name"]:"";

        return InkWell(
          onTap:(){
           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userName:userName,
               userId:messagers.elementAt(index)),));
          },
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20 * 0.75),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:getImage(userImage),
                    ),
                    // if (chat.isActive)
                    //   Positioned(
                    //     right: 0,
                    //     bottom: 0,
                    //     child: Container(
                    //       height: 16,
                    //       width: 16,
                    //       decoration: BoxDecoration(
                    //         color: Colors.green[500],
                    //         shape: BoxShape.circle,
                    //         border: Border.all(
                    //             color: Theme.of(context).scaffoldBackgroundColor,
                    //             width: 3),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        // Opacity(
                        //   opacity: 0.64,
                        //   child: Text(
                        //    " chat.lastMessage",
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Opacity(
                //   opacity: 0.64,
                //   child: Text(chat.time),
                // ),
              ],
            ),
          ),
        );
      },),
    );
  }

  getImage(String userImage) {
    return  userImage.isNotEmpty?NetworkImage(userImage):AssetImage("images/image-not-found.jpg");
  }
}
