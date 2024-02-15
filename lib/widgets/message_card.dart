
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_ship/Apis/apis.dart';
import 'package:friend_ship/helper/my_date_util.dart';
import 'package:friend_ship/models/message.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../helper/diaglogs.dart';
import '../main.dart';
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
 final Message message;


  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe =  Api.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: (){
          _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage());
   

  
  }

  // sender or another user message
  Widget _blueMessage(){

    // update last read message if sender and receiver are different
      if(widget.message.read.isEmpty){
        Api.updateMessageReadStatus(widget.message);
        // log('message read updated');
      }





    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
  //message contain
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ?mq.width *.02 :mq.width  *.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width *.04, vertical: mq.height *.01),
            decoration: BoxDecoration(color: Color.fromARGB(255, 193, 226, 241), 
            border: Border.all(color: Colors.lightBlue),
            // making border curved
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30 ))),

            
            child:  widget.message.type == Type.text ?
            //show test
             Text(
              widget.message.msg,
             style: TextStyle(fontSize: 15, color: Colors.black87),): 
            // show images
              ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                
                      imageUrl:  widget.message.msg,
                      placeholder: (context, url) => 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2,),
                      ),
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => 
                      Icon( Icons.image, size: 70),
                      //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                      ),
                   ),
            ),
      
          ),
        

  //message time
  Padding(
    padding:  EdgeInsets.only(right: mq.width *.04),
    child: Text(
       MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
    style: TextStyle(fontSize: 13, color: Colors.black54),),
  ),

      ],
    );
  }

  //our or user message
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [


  // message time
  Row(
    children: [
      // for adding some spaces
      SizedBox(width: mq.width *.04,),
      // double tick blue icon for message read
      if(widget.message.read.isNotEmpty)
      Icon(Icons.done_all_rounded, color: Colors.blue,size: 20,),

      //for adding some spaces
      SizedBox(width: 2,),

      // sent time
      Text(
        MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
       style: TextStyle(fontSize: 13, color: Colors.black54),),
    ],
  ),

    //message contain
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width *.02 :mq.width  *.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width *.04, vertical: mq.height *.01),
            decoration: BoxDecoration(color: Color.fromARGB(255, 177, 248, 204), 
            border: Border.all(color: Colors.green),
            // making border curved
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30 ))),

            child:widget.message.type == Type.text ?
            //show test
             Text(
              widget.message.msg,
             style: TextStyle(fontSize: 15, color: Colors.black87),): 
             // show images
              ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                
                      imageUrl:  widget.message.msg,
                      placeholder: (context, url) =>
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: CircularProgressIndicator(strokeWidth: 2,),
                       ),
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => 
                      Icon( Icons.image, size: 70),
                      //  backgroundColor: Color.fromARGB(255, 211, 220, 224),
                      ),
                   ),
          ),
        ),

      ],
    );
  }

  //bottom sheet for modifying message details
  void _showBottomSheet(bool isMe){
    showModalBottomSheet(context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius
    .only(topLeft: Radius.circular(20),
     topRight: Radius.circular(20))),
    builder: (_){
      return ListView(
        shrinkWrap: true,
       
        children: [
          Container(
            height: 04,
            margin: EdgeInsets.symmetric(horizontal: mq.width *.4, vertical: mq.height *.015),
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
          ),

         widget.message.type == Type.text? 
          // copy option
        _OptionItems(
          icon: Icon(Icons.copy_all_rounded, color: Colors.blue, size: 26,), 
          name: 'Copy Text', onTap: () async {
            await  Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value){

              //for hiding bottom sheet
              Navigator.pop(context);
              Dialogs.showSnackbar(context, 'Text Copied!');
            });
            
            
            
          }) : 

          // save option
        _OptionItems(
          icon: Icon(Icons.download_rounded, color: Colors.blue, size: 26,), 
          name: 'Save Image', onTap: () async {
          log('Image Url: ${widget.message.msg}');
          try {
             await  GallerySaver.saveImage(widget.message.msg, albumName: 'FriendShip Chat')
             .then((success) {
              Navigator.pop(context);
              if(success != null && success){
                Dialogs.showSnackbar(context, 'Image Successfully Saved!');
              }

    });
          } catch (e) {
            log('ErrorWhileSavingImg $e');
            
          }
          }),
          
          // separator or divider
          if(isMe)
          Divider(
            color: Colors.black12,
            endIndent: mq.width *.04,
            indent:  mq.width *.04,
          ),

          // Edit Option
          if(widget.message.type == Type.text && isMe)
              _OptionItems(
          icon: Icon(Icons.edit, color: Colors.blue, size: 26,), 
          name: 'Edit Message', onTap: (){
             Navigator.pop(context);
            _showMessageUpdateDialog();
            
           
          }),

          // delete option
          if(isMe)
              _OptionItems(
          icon: Icon(Icons.delete, color: Colors.red, size: 26,), 
          name: 'Delete Message', onTap: () async {
            await  Api.deleteMessage(widget.message).then((value) {
              Navigator.pop(context);
            });
          }),

           // separator or divider
          Divider(
            color: Colors.black12,
            endIndent: mq.width *.04,
            indent:  mq.width *.04,
          ),

          //sent time
              _OptionItems(
          icon: Icon(Icons.remove_red_eye, color: Colors.blue,), 
          name: 'Send At:  ${MyDateUtil.getMessageTime(
            context: context, time: widget.message.sent)}', onTap: (){} ),

          //read time
           _OptionItems(
          icon: Icon(Icons.remove_red_eye, color: Colors.green), 
          name: widget.message.read.isEmpty ? 
          'Read At:  Not seen yet':
          'Read At  ${MyDateUtil.getMessageTime(
            context: context, time: widget.message.read)}', onTap: (){})
  
        
        ],
      );
    }); 
  }
  //dialog for update message content
  void _showMessageUpdateDialog(){
String updateMsg = widget.message.msg;
showDialog(context: context, builder: (_) => AlertDialog(
  contentPadding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  // title
  title: Row(children: [Icon(Icons.message, color: Colors.blue, size: 28,),
  Text(' Update Message')
  ]),

  //content 
  content: TextFormField(initialValue: updateMsg, 
  maxLines: null,
  onChanged: (value) => updateMsg = value,
  decoration: InputDecoration(border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15))),),

    //action
    actions: [
      //cancel button
      MaterialButton(onPressed: (){
        // hide alert dialog
        Navigator.pop(context);
      } , child: 
      Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16),),),

      //update button
       MaterialButton(onPressed: (){
        //hide alert dialog
        Navigator.pop(context);
        Api.updateMessage(widget.message, updateMsg);
       } , child: 
      Text('Update', style: TextStyle(color: Colors.blue, fontSize: 16),),)
    ],
)
);
 
  }
}
class _OptionItems extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItems({required this.icon, required this.name, required this.onTap});
  

  @override
  Widget build(BuildContext context) {
    return  InkWell(onTap: () => onTap, 
    child:    Padding(
      padding:  EdgeInsets.only(
        left: mq.width *.05, 
        top: mq.height *.015, 
        bottom: mq.height *.02),
      child: Row(children: [
        icon, Flexible(child: 
        Text('    $name', 
        style: TextStyle(fontSize: 15, 
        color:  Colors.black54,
        letterSpacing: 0.5),))],),
    ),);
  }
}