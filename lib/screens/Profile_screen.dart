
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_ship/Apis/apis.dart';
import 'package:friend_ship/models/ChatUser.dart';
import 'package:friend_ship/screens/auth/auth%20services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';


// profile screen --- show signIn information
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  // global object for store image
  String? _image;
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
   AuthService authService = AuthService();
     
    return  GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          
          title: Text("Profile Screen"),
          // actions:  [ IconButton(onPressed: authService.handleSignOut, 
          //  icon: const Icon(Icons.logout)),
          //  ],
         
        ),
      
        //logout button
      
      floatingActionButton: Padding(
          
          padding:  EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended
          (onPressed: authService.handleSignOut, 
          icon: Icon(Icons.logout),backgroundColor: Colors.red.shade200,
           label: Text("Logout"),),
        ),
      
      
        
      body:  Form(
        key: _formkey,


        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: mq.width *.04),
          child: SingleChildScrollView(
            child: Column(children: [
            
              // for adding more spaces
              SizedBox(width: mq.width, height: mq.height *.03,),
              Stack(
                children: [

                  _image != null ?
                   ClipRRect(
                  //local image
                    // user profile picture
                          borderRadius: BorderRadius.circular(mq.height *.1),
                          child: Image.file(
                            File(_image! ),
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                               ),
                        ):
                  
                  ClipRRect(
                  // image from server
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
                // Edit profile images 
        
                  Positioned(
                    bottom: 0,
                     right: 0,
                    child: MaterialButton(
                      elevation: 1,
                      color: Colors.white,
                      shape: CircleBorder(),
                      onPressed: (){
                        _showBottomSheet();
                      }, child: Icon(Icons.edit),),
                  )
                ],
              ),
            
            
                    // for adding more spaces
              SizedBox(height: mq.height *.05,),
              // email field
                Text(widget.user.email, style: TextStyle(color: Colors.black54,fontSize: 16),),
            
            
               // for adding more spaces
              SizedBox(height: mq.height *.05,),
            
              //name Input Field
              TextFormField(
                initialValue: widget.user.name,
                // name validation
                onSaved: (val) => Api.me.name = val ??'',
                validator: (val) => val != null && val.isNotEmpty? null: 'Required Field',


                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.blue,),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), ),
                  hintText: "eg. Developer",
                  label: Text("Name")
                ),
              ),
            
            
            
              // for about
               // for adding more spaces
              SizedBox(height: mq.height *.02),
                // about input field
              TextFormField(
                // name validation
                onSaved: (val) => Api.me.about = val ??'',
                validator: (val) => val != null && val.isNotEmpty? null: 'Required Field',
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.info_outline, color: Colors.blue,),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), ),
                  hintText: "eg. Feeling good",
                  label: Text("About")
                ),
              ),
            
            
            //update button
            
            // for adding more spaces
              SizedBox(height: mq.height *.02),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(shape: StadiumBorder(),minimumSize: Size(mq.width * .4, mq.height *.06),
               backgroundColor: Color.fromARGB(255, 150, 188, 234)),
              onPressed: (){
                  if(_formkey.currentState!.validate()){
                    _formkey.currentState!.save();
                    Api.updateUserInfo().then((value){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profile  Update Successfully")));
                    });
                  }

              },
              icon: Icon(Icons.edit, size: 30, color: Colors.black, ),
               label: Text("Update", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),))
            
            ],),
          ),
        ),
      )
      ),
    );
    
  }



  //bottom sheet for picking a profile for user
  void _showBottomSheet(){
    showModalBottomSheet(context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (_){
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height *.03, bottom: mq.height *.04),
        children: [Text("Pick Profile picture", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        
        
   // for adding some spaces
          SizedBox(height: mq.height *.02,)     ,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
  //button
          ElevatedButton(
  // pick button for galary
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, 
            fixedSize: Size(mq.width *.3, mq.height *.15),
            shape: CircleBorder(),
          ),
            onPressed: ()  async {
              final ImagePicker picker = ImagePicker();
              // Pick an image.
              final XFile? image = 
              await picker.pickImage(source: ImageSource.gallery);
              if(image != null){
                log('Image Path: ${image.path} --MimeType: ${image.mimeType}');
                setState(() {
                  _image = image.path;
                });

                Api.updateProfilePicture(File(_image!));
    // for hiding bottom sheet
              Navigator.pop(context);
              }


            }, child: Image.asset('images/galary.png')),
  // pick button for camera
            ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, 
            fixedSize: Size(mq.width *.3, mq.height *.15),
            shape: CircleBorder(),
          ),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              // Pick an image.
              final XFile? image = 
              await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
              if(image != null){
                log('Image Path: ${image.path} ');
                setState(() {
                  _image = image.path;
                });
           Api.updateProfilePicture(File(_image!));
    // for hiding bottom sheet
              Navigator.pop(context);
              }

            }, child: Image.asset('images/camera.png'))

            ],)
        
        ],
      );
    });
   
  }


}
