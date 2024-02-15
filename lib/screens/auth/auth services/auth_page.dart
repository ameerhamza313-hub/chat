import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friend_ship/screens/auth/login_screen.dart';
import 'package:friend_ship/screens/home_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot){
          if (snapshot.connectionState== ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        if (snapshot.hasData){
          return const HomeScreen();
        }else{
          return Login_Screen();
        }

        },
      ),);
  }
}