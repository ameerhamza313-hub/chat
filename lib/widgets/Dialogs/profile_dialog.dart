import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_ship/models/ChatUser.dart';
import 'package:friend_ship/screens/view_Profile_screen%20.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width:  mq.width *.6 ,
        height:  mq.height *.35,
        child: Stack(children: [
            // user profile picture
            Positioned(
              top: mq.height *.075,
              left: mq.width *.15,
              child: ClipRRect(
              
                      borderRadius: BorderRadius.circular(mq.height *.25),
                      child: CachedNetworkImage(
                        height: mq.width *.5,
                        width: mq.width * .5,
                        fit: BoxFit.cover,
                              imageUrl:  user.image,
                              // placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => 
                              CircleAvatar(child: Icon(CupertinoIcons.person)
                              //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                              ),
                           ),
                    ),
            ),

            // user name
          Positioned(
            left: mq.height *.04,
            top:  mq.width *.03,
            width: mq.width *.55,
            child: Text(
              user.name,
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          ),

      
      // info button     
            Positioned(
              
              right: 8,
              top: 6,
              child:MaterialButton(onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: user)));
              },
              minWidth: 0,
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              child:  Icon(Icons.info_outline, color: Colors.blue,size: 30,),))

        ],),
      ),
    );
  }
}