
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_ship/main.dart';
import 'package:friend_ship/screens/auth/auth%20services/auth_page.dart';
// import 'package:friend_ship/screens/auth/login_screen.dart';



class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});


  @override
  State<Splash_Screen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Splash_Screen> {
  
  @override
  void initState() {
    super.initState();
    // hold screen
    Future.delayed(Duration(seconds: 2),(){
      // full screen mode  and status bar or exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white));

      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
    });
  }
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  Scaffold(
  


     body: Stack(children: [
      Positioned
      (
        top: mq.height *.15,
        left: mq.width *.25,
        width: mq.width *.5,
        child: Image.asset('images/icon.png')),
         Positioned
      (
        bottom: mq.height *.40,
        left: mq.width *.14,
        width: mq.width *.8,
        child: Text('FriendShip: Where Hearts Connected 👫', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),))
        
     ],),
      );
   
  }
}
