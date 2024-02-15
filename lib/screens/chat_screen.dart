import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_ship/helper/my_date_util.dart';
import 'package:friend_ship/models/ChatUser.dart';
import 'package:friend_ship/models/message.dart';
import 'package:friend_ship/screens/view_Profile_screen%20.dart';
import 'package:friend_ship/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

import '../Apis/apis.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all message
  List<Message> _list = [];

  // for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing  or hide emoji
  // isUploading -- for checking if image is uploading or not ?
  bool _showEmoji = false, _isUploading  = false;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ( ) => FocusScope.of(context).unfocus(),
      child: SafeArea(
      // status bar color
        child: AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlue,
        // statusBarIconBrightness: Brightness.dark,
      ),
      
      
      
      
        child: PopScope(
          canPop: true,
           onPopInvoked: (( didPop) {
          if(_showEmoji){
            setState(() {
              _showEmoji = !_showEmoji;
            });
          //  return Future.value(); 
          
          }
          // else{
          //   return Future.value(true);
          // }
        }),


          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: Color.fromARGB(255, 234, 248, 255),
  //body
                body: Column(children: [
          
            Expanded(
              child: StreamBuilder(
                 stream: Api.getAllMessages(widget.user),
               builder : (context, snapshot){
              
                // data loading
              
                switch(snapshot.connectionState){
                  // if data in loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  return SizedBox();
                  // if all data is loaded then show
                  case ConnectionState.active:
                  case ConnectionState.done:
              
                  final data = snapshot.data?.docs;
                  // log('Data: ${jsonEncode (data![0].data())}');
                   _list = data?.map((e) => Message.fromJson(e.data())).toList() ??[];
              
                  // final _list = ['hii', 'hi'];
                  // _list.clear();
                  // _list.add(Message(toId: 'xyz', msg: 'hii', read: '', type: Type.text, fromId: Api.user.uid, sent: '12:00'));
                  // _list.add((Message(toId: Api.user.uid, msg: 'Hlo', read: '', type: Type.text, fromId: 'xyz', sent: '12:00')));
              
              if (_list.isNotEmpty){
                // user design list cart
                return  ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(top: mq.height *.02),
                   itemCount:  _list.length,
                   physics: BouncingScrollPhysics(),
                   itemBuilder: (context, index){
                  return  MessageCard(message:  _list[index],);
                   }
                
                );     
              } else{
                return Center(child: Text ('Say Hii! 👋', style: TextStyle(fontSize: 20),));
              }
                }
               }, 
               
              ),
            ),
            
        //progress indicator for showing uploading images
            if(_isUploading)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: CircularProgressIndicator(strokeWidth: 2,))),
                
        //chat input filed 
          _ChatInput(),
          
                //show emoji on keyboard  button click and voice versa
                if (_showEmoji)
                SizedBox(
          height:  mq.height *.35,
          child: EmojiPicker(
          textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
          config: Config(
            bgColor: Color.fromARGB(255, 234, 248, 255),
              columns: 8,
              // initCategory:  Category.FLAGS,
              emojiSizeMax: 32 *
              (Platform.isIOS
                  ?  1.20
                  :  1.0),
              
              
          ),
          ),
                )
                
          ],),
          ),
        ),
        ),
      ),
    );

  }
// app bar
  Widget _appBar(){
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user,)));
      },
      child: StreamBuilder(stream:Api.getUserInfo(widget.user) , builder: (context, snapshot){

        final data = snapshot.data?.docs;
             final  list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
              
               
        return Row(
        children: [
 // back button
          IconButton(onPressed: () => Navigator.pop(context),
           icon: Icon(Icons.arrow_back, color: Colors.black54,)),
// user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height *.3),
              child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                      imageUrl:  list.isNotEmpty? list[0].image : widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => 
                      CircleAvatar(child: Icon(CupertinoIcons.person)
                      //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                      ),
                   ),
            ),
      
 // for adding some spaces
            SizedBox(width: 10,),
          // user name and last seen time
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//  user name
              Text (list.isNotEmpty? list[0].name :
               widget.user.name, style: TextStyle
              (fontSize: 16, color: Colors.black87, 
              fontWeight: FontWeight.w400),),
      
// for adding some spaces
            SizedBox(height: 1,),
 // last seen time of  user
              Text(list.isNotEmpty?
              list[0].isOnline ? 'Online' :
               MyDateUtil.getLastActiveTime(context: context, lastActive: list[0].lastActive)
                :  MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive),
                style: TextStyle
              (fontSize: 13, color: Colors.black87, 
              ),)
            ],)
        ],
      );
 
      }),   );
  }


  // bottom chat input field
  Widget _ChatInput(){
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: mq.height *.01, horizontal: mq.height *.015),
      child: Row(
        children: [
          Expanded(
            child: Card(
            
              // input field and button
            
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                // emoji button
                 IconButton(onPressed: (){
                  FocusScope.of(context).unfocus();
                  setState(()  =>  _showEmoji = !_showEmoji
                  );
                 },
                     icon: Icon(Icons.emoji_emotions, color: Colors.blueAccent,size: 25,)),
              // Text field   
                     Expanded(child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: (){
                        if(_showEmoji)
                          setState(()  =>  _showEmoji = !_showEmoji
                  );
                      },
                      decoration: InputDecoration(hintText: 'type something',
                      hintStyle: TextStyle(color: Colors.blue,),
                      border: InputBorder.none),
                     )),
              // pick image from galary
                     IconButton(onPressed: () async {

                       final ImagePicker picker = ImagePicker();
              // Picking multiple images.
              final List<XFile>? images = 
              await picker.pickMultiImage( imageQuality: 70);
      // uploading and sending images one by one
                for (var i in images!) {
                 
                log('Image Path: ${i.path} ');
                setState(() => _isUploading = true);
          await Api.sendChatImage(widget.user,File(i.path));
          setState(() => _isUploading = false);
              }  
                  
                

              

                     },
                     icon: Icon(Icons.image, color: Colors.blueAccent,size: 26,)),
              // take image from camera button
                      IconButton(onPressed: () async {
                        final ImagePicker picker = ImagePicker();
              // Pick an image.
              final XFile? image = 
              await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
              if(image != null){
                log('Image Path: ${image.path} ');
                setState(() => _isUploading = true);
          await Api.sendChatImage(widget.user,File(image.path));
          setState(() => _isUploading = false);
              }
                      },
                     icon: Icon(Icons.camera_alt_rounded, color: Colors.blueAccent, size: 26,)),
              // add some spaces
              SizedBox(width: mq.width *.02,)
              ],),
            ),
          ),
        // send message button
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              if(_list.isEmpty){
                // only first message (add user to my_users collection of chat user)
                Api.sendFirstMessage(widget.user, _textController.text, Type.text);
              }else {
                //simply send message
                Api.sendMessage(widget.user, _textController.text, Type.text);
              }
              _textController.text= '';
            }
          }, 
          minWidth: 0,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
          shape: CircleBorder(),
          color: Colors.green,
          child: Icon(Icons.send, color: Colors.white, size: 28,),)
        ],
      ),
    );
  }
}
