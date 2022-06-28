import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sem/models/user.dart';
import 'package:sem/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  myUser? _userFromfirebase(User? user){
    return user != null ? myUser(uid: user.uid,username:user.displayName,Email: user.email,PicUrl: user.photoURL,emailverified: user.emailVerified) : null;
  }

  Stream<myUser?> get user {
    return _auth.userChanges().map((User? user) =>
        _userFromfirebase(user!));
    //or can just use .map(_userfromfirebase)
  }


  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  Future registerwithEmail(String Email, String Password,String Username,String Phoneno) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
      User? user = result.user;

      await user!.updateDisplayName(Username);
      FirebaseStorage ? Store =FirebaseStorage.instance;

      String url=await Store.ref().child("image/avatar.png").getDownloadURL();
      final DatabaseService d1=DatabaseService(uid: user.uid);
      await d1.updateuserdata(Username, Phoneno, Email,url);
      await user.updatePhotoURL(url);
      return _userFromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future registerwithEmailworker(String Email, String Password,String Username,List<String>workarea,String Phoneno) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
      User? user = result.user;

      await user!.updateDisplayName(Username);
      final DatabaseService d1=DatabaseService(uid: user.uid);

      FirebaseStorage ? Store =FirebaseStorage.instance;

      String url=await Store.ref().child("image/avatar.png").getDownloadURL();
      var data=await d1.updateworkerdata(Username, Phoneno, Email, workarea,url);
      await user.updatePhotoURL(url);
      return _userFromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future Signin_with_email(String Email, String Password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: Email, password: Password);
      User? user = result.user;
      return _userFromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}