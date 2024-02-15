import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:friend_ship/screens/splash_Screeb.dart';
import 'package:friend_ship/firebase_options.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

// global object for accessing screen size
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Enter full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  .then((value) => {
     runApp(const MyApp()),
  _initializeFirebase(),
  });

 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friend Ship',
      theme: ThemeData(
      appBarTheme: AppBarTheme(
        

        backgroundColor: Color.fromARGB(255, 98, 179, 245),
        centerTitle: true,
        elevation: 0,
        titleTextStyle:  TextStyle(fontSize: 19, fontWeight: FontWeight.bold,color: Colors.black),),




      ),
        
      home: Splash_Screen(),
    );
  }
}
_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats');
    log('\nnotification channel Result: $result');
   

print(result);
}

