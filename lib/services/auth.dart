import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizbuilder/models/user.dart';

class AuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _userFromFirebaseUser(User user){
    if(user!=null){
      String userid=user.uid;
      return UserModel(userid);
    }
    else {
      return null ;
    }
  }


  Future signInEmailAndPass(String email,String password) async{
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
       print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser!);

    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}