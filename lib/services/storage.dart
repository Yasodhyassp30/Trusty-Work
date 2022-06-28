import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:sem/services/database.dart';
import 'package:sem/workingwidgets/gallery_request.dart';

class datastore {
  FirebaseStorage? store = FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future? UploadProfileImage(File Imagefile) async {
    User? id = await _auth.currentUser;
    DatabaseService? d1 = DatabaseService(uid: id?.uid);
    var stroeref = store?.ref().child("image/${id?.uid}");
    var upload = await stroeref?.putFile(Imagefile);
    String? completed = await upload?.ref.getDownloadURL();
    await id?.updatePhotoURL(completed);
    await d1.setURL(completed!);
    await id?.reload();
    return completed;
  }

  Future? galleryrequeststore(List<File> images, DocumentSnapshot id) async {
    List fileurls = [];
    for (int i = 0; i < images.length; i++) {
      var stroeref = store?.ref().child("requests/${id.id}/${DateTime.now()}");
      var upload = await stroeref?.putFile(images[i]);
      String? completed = await upload?.ref.getDownloadURL();

      fileurls.add(completed);
    }

    FirebaseFirestore.instance.collection('gallery').doc(id.id).set({
      'URL': fileurls,
      'accepted': false,
      'date': DateTime.now(),
      'Reciever': id.get('Contractor'),
      'sender': id.get('Reciever'),
      'title': id.get('title')
    });
    FirebaseFirestore.instance
        .collection('requests')
        .doc(id.id)
        .update({'galleryrequest': true});
    return 'done';
  }

  Future? msgimage(File images, String Rid, String cid) async {
    String fileurls = " ";

    var stroeref = store?.ref().child("requests/${cid}/${DateTime.now()}");
    var upload = await stroeref?.putFile(images);
    String? completed = await upload?.ref.getDownloadURL();

    fileurls = completed!;
    DocumentSnapshot s1 =
        await FirebaseFirestore.instance.collection('messages').doc(cid).get();
    if (s1.exists) {
      await FirebaseFirestore.instance.collection('messages').doc(cid).update({
        'messages': FieldValue.arrayUnion([
          {
            'URL': fileurls,
            'with': Rid,
            'sender': cid,
            'reciever': Rid,
            'time': DateTime.now()
          }
        ])
      });
    } else {
      await FirebaseFirestore.instance.collection('messages').doc(cid).set({
        'messages': [
          {
            'URL': fileurls,
            'with': Rid,
            'sender': cid,
            'reciever': Rid,
            'time': DateTime.now()
          }
        ]
      });
    }
    DocumentSnapshot s2 =
        await FirebaseFirestore.instance.collection('messages').doc(Rid).get();
    if (s2.exists) {
      await FirebaseFirestore.instance.collection('messages').doc(Rid).update({
        'messages': FieldValue.arrayUnion([
          {
            'URL': fileurls,
            'with': cid,
            'sender': cid,
            'reciever': Rid,
            'time': DateTime.now()
          }
        ])
      });
    } else {
      await FirebaseFirestore.instance.collection('messages').doc(Rid).set({
        'messages': [
          {
            'URL': fileurls,
            'with': cid,
            'sender': cid,
            'reciever': Rid,
            'time': DateTime.now()
          }
        ]
      });
    }
  }
}
