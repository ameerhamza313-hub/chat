import 'package:flutter/material.dart';
import 'package:friend_ship/main.dart';
import 'package:friend_ship/screens/auth/auth%20services/auth_service.dart';


class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Login_Screen> {


  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
    AuthService authService = AuthService();
    return  Scaffold(
      appBar: AppBar(
       
        title: Text("Welcome to Friend Ship Chat"),
       
      ),


     body: Stack(children: [
      Positioned
      (
        top: mq.height *.15,
        left: mq.width *.25,
        width: mq.width *.5,
        child: Image.asset('images/icon.png')),
         Positioned
      (
        bottom: mq.height *.15,
        left: mq.width *.1,
        width: mq.width *.8,
        height: mq.height *.07,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 172, 244, 138)
          ),
           onPressed: authService.handleSignIn,
          
          //google icon
           icon: Image.asset('images/google.png',height: mq.height *.04,),
           //login
         label: Text("Log In with Google", style: TextStyle(fontWeight: FontWeight.bold, color: Colors. black),)))
        
     ],),
      );
   
  }
}
