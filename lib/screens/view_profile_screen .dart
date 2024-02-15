
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_ship/models/ChatUser.dart';
import '../helper/my_date_util.dart';
import '../main.dart';


// view profile screen --- to view profile of user
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
 
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
     
    return  GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          
          title: Text(widget.user.name),
          // actions:  [ IconButton(onPressed: authService.handleSignOut, 
          //  icon: const Icon(Icons.logout)),
          //  ],
         
        ),
      

      floatingActionButton:  // user an
       Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Joined On :  ', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),),
                  Text(
                    MyDateUtil.getJoindYear(
                      context: context, time: widget.user.createdAt, showYear: true) ,
                     style: TextStyle(color: Colors.black54,fontSize: 16),),
                ],
              ),

      
// body        
      body:  Padding(
        padding:  EdgeInsets.symmetric(horizontal: mq.width *.04),
        child: SingleChildScrollView(
          child: Column(children: [
          
            // for adding more spaces
            SizedBox(width: mq.width, height: mq.height *.03,),
            //user profile picture
            ClipRRect(
              // user profile picture
                    borderRadius: BorderRadius.circular(mq.height *.1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                            imageUrl:  widget.user.image,
                            // placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => 
                            CircleAvatar(child: Icon(CupertinoIcons.person)
                            //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                            ),
                         ),
                  ),
          
          
                  // for adding more spaces
            SizedBox(height: mq.height *.05,),
            // email field
              Text(widget.user.email, style: TextStyle(color: Colors.black87,fontSize: 16),),

              // for adding more spaces
            SizedBox(height: mq.height *.02,),
            // user about
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('About:  ', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),),
                  Text(widget.user.about, style: TextStyle(color: Colors.black54,fontSize: 16),),
                ],
              ),
          
          
             // for adding more spaces
            SizedBox(height: mq.height *.05,),
          
         
          
          
          
           
          
          

          
          ],),
        ),
      )
      ),
    );
    
  }



 }
