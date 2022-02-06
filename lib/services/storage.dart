
import 'package:path/path.dart'as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:sem/services/Authenticate.dart';

class datastore{
  FirebaseStorage ? store=FirebaseStorage.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;


  Future ? UploadProfileImage(File Imagefile)async{
    User? id =await _auth.currentUser;
    var stroeref=store?.ref().child("image/${id?.uid}");
    var upload= await stroeref?.putFile(Imagefile);
    String ? completed= await upload?.ref.getDownloadURL();
    await id?.updatePhotoURL(completed);
    await id?.reload();
    return completed;



  }
}