import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Apis/apis.dart';

class AuthService{
  final FirebaseAuth  _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

 

  // google sign in auth

  Future<void>handleSignIn() async{
    try {
     
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser!= null){
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential =  GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    }catch(e){
    
      print("Error signing in with Google $e");
    }

    
  }
  // google sign out function
    
    Future<void> handleSignOut() async {
      try{
        await _googleSignIn.signOut();
        await Api.updateActiveStatus(false);
        await _auth.signOut();
        
        
   
      }
      
      catch(e){
        print("error signing out: $e");
      }
      
      // Api.auth = FirebaseAuth.instance;
      // Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context) => AuthPage()));

    }
}


