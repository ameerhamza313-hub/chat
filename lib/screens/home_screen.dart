
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_ship/Apis/apis.dart';
import 'package:friend_ship/main.dart';
import 'package:friend_ship/models/ChatUser.dart';
import 'package:friend_ship/screens/Profile_screen.dart';
import 'package:friend_ship/widgets/chat_user_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for store all users
  List<ChatUser> _list = [];
  //for storing searched items.
  final List<ChatUser> _searchList = [];
  //for storing searching status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    Api.getSelfInfo();

  // for updating user active status according to lifecycle events
  //resume-- active or online
  // pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message){
      log('Message $message');
      if(Api.auth.currentUser != null){
              if(message.toString().contains('resume')){
                 Api.updateActiveStatus(true);
                 }
      if(message.toString().contains('pause')){ 
        Api.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });

    

  }

  @override
  Widget build(BuildContext context) {
   
    // AuthService authService = AuthService();
    return  GestureDetector(
      //for hiding keyboard automatic
      onTap: () => FocusScope.of(context).unfocus(),

      child: PopScope(
        canPop: true,
        
        // onPopInvoked: ((didPop) {
        //   if(_isSearching){
        //     setState(() {
        //       _isSearching = !_isSearching;
        //     });
        //    // return Future.value(); 
          
        //   }
        //   // else{
        //   //   return Future.value(true);
        //   // }
        // }),

     
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title:  _isSearching ? TextField(
              decoration: InputDecoration(border: InputBorder.none, hintText: "Name, Email ...."),
              autofocus: true,
              style: TextStyle(fontSize: 17, letterSpacing: 0.5, ),
              // when search text change update search list
              onChanged: (val){
                _searchList.clear();
                // search logic
                for( var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) ||
                   i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
        
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            )
            :Text("Friend Ship"),
            actions: [ 
            // IconButton(onPressed: authService.handleSignOut, icon: Icon(Icons.logout)),
        
            // user search button
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = ! _isSearching;
                });
        
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid:
               Icons.search) ),
        
              // more feature button
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(user: Api.me)));
            }, icon: Icon(Icons.more_vert))
             
            
            ],
          ),
        
        
          floatingActionButton: Padding(
            
            padding:  EdgeInsets.only(bottom: 15),
            child: FloatingActionButton(onPressed: (){
              _addChatUserDialog();

            },
             child: Icon(Icons.add_comment_rounded),backgroundColor: Color.fromARGB(255, 150, 188, 234),),
          ),
   //body     
          // fetching data from firebase
        body: StreamBuilder(
          stream: Api.getMyIUsersId(), 
          //get id of only known user
          builder: (context, snapshot) {
          
          switch(snapshot.connectionState){
            // if data in loading
            case ConnectionState.waiting:
            case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
            // if all data is loaded then show
            case ConnectionState.active:
            case ConnectionState.done:
         return StreamBuilder(
          stream: Api.getAllUsers(
            snapshot.data?.docs.map((e) => e.id).toList() ??[]),
          // get only those user, who's id are provided
         builder : (context, snapshot){
        
          // data loading
        
          switch(snapshot.connectionState){
            // if data in loading
            case ConnectionState.waiting:
            case ConnectionState.none:
            // return Center(child: CircularProgressIndicator());
            // if all data is loaded then show
            case ConnectionState.active:
            case ConnectionState.done:
        
            final data = snapshot.data?.docs;
             _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
        if (_list.isNotEmpty){
          // user design list cart
          return  ListView.builder(
            padding: EdgeInsets.only(top: mq.height *.02),
             itemCount: _isSearching ? _searchList.length : _list.length,
             physics: BouncingScrollPhysics(),
             itemBuilder: (context, index){
            return ChatUserCard(user:
            _isSearching ? _searchList[index]:
             _list[index]);
            // return Text('Name: ${list[index]}');
             }
          
          );     
        } else{
          return Center(child: Text ('Connection not Found', style: TextStyle(fontSize: 20),));
        }
          }
         },
         
        );
          }
           
          
        }, 
        ),
      )
      )
    );
  }

// for adding new user dialog
  void _addChatUserDialog(){
String email = '';
showDialog(context: context, builder: (_) => AlertDialog(
  contentPadding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  // title
  title: Row(children: [Icon(Icons.person_add, color: Colors.blue, size: 28,),
  Text('  Add User')
  ]),

  //content 
  content: TextFormField(
  maxLines: null,
  onChanged: (value) => email =  value ,
  decoration: InputDecoration(
    hintText: 'Email ...',
    prefixIcon: Icon(Icons.email , color: Colors.blue,),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15))),),

    //action
    actions: [
      //cancel button
      MaterialButton(onPressed: (){
        // hide alert dialog
        Navigator.pop(context);
      } , child: 
      Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16),),),

      //Add button
       MaterialButton(onPressed: () async {
        //hide alert dialog
        Navigator.pop(context);
        if(email.isNotEmpty)
        await 
         Api.addChaUser(email);
       } , child: 
      Text('Add', style: TextStyle(color: Colors.blue, fontSize: 16),),)
    ],
)
);
 
  }
}
