import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_ship/Apis/apis.dart';
import 'package:friend_ship/models/ChatUser.dart';
import 'package:friend_ship/models/message.dart';
import 'package:friend_ship/widgets/Dialogs/profile_dialog.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final  ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {

  Message? _message;
  @override
  Widget build(BuildContext context) {

    return  Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width *.04, vertical: mq.width *.01),
      elevation: 0.5,
      // color: Colors.lightBlue,

      child: InkWell(
        onTap: (){
  // for navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(user: widget.user,)));

        },
        child: StreamBuilder(
          stream: Api.getLastMessage(widget.user)
          ,builder:( context, snapshot){

              final data = snapshot.data?.docs;
              
              // log('Data: ${jsonEncode (data![0].data())}');
             final  list = data?.map((e) => Message.fromJson(e.data())).toList() ??[];
              if(list.isNotEmpty)
                _message =  list[0];
              
      



          return ListTile(
          // user profile picture
  // leading:  CircleAvatar(child: Icon(CupertinoIcons.person), backgroundColor: Color.fromARGB(255, 211, 220, 224),),
          leading:  InkWell(
            onTap: (){
              showDialog(context: context, builder: (_) => ProfileDialog(user: widget.user));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height *.3),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                      imageUrl:  widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => 
                      CircleAvatar(child: Icon(CupertinoIcons.person)
                      //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                      ),
                   ),
            ),
          ),
          // user name
          title: Text(widget.user.name),
          //last  message
          subtitle: Text(
            _message != null ? 
            // show image
            _message!.type == Type.image ?
            'image' :
            _message!.msg :
            
            
            widget.user.about, maxLines: 1,),
          // last  message time
          trailing:  _message == null ? null // show nothing when no message is sent
         : _message!.read.isEmpty && _message!.fromId != Api.user.uid ?
         // show for unread message
           Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(color:  Colors.greenAccent.shade400, borderRadius: BorderRadius.circular(10)),
          ): 
          // send message time
          Text( MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),
           style: TextStyle(color: Colors.black45),),

          // trailing: Text("12:00 PM", style: TextStyle(color: Colors.black45),),
        );

        }, 
      ),
    ),
    );
  }
}