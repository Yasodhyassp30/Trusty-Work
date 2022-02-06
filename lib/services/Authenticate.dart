import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sem/models/user.dart';
import 'package:sem/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  myUser? _userFromfirebase(User? user){
    return user != null ? myUser(uid: user.uid,username:user.displayName,Email: user.email,PicUrl: user.photoURL) : null;
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

  Future registerwithEmail(String Email, String Password,String Username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
      User? user = result.user;

      await user!.updateDisplayName(Username);
      FirebaseStorage ? Store =FirebaseStorage.instance;

      String url=await Store.ref().child("image/avatar.png").getDownloadURL();
      await user.updatePhotoURL(url);
      await _auth.signOut();
      result =await _auth.signInWithEmailAndPassword(email:Email, password: Password);
      user=result.user;


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
      return (_userFromfirebase(user));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}