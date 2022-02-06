import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String ?uid;

  DatabaseService({this.uid});

  final CollectionReference userdetails = FirebaseFirestore.instance.collection(
      'userdata');

  Future ? updateuserdata(String ?Username, String ?Phoneno,
      String ?email) async {
    return await userdetails.doc(uid).set(
        {
          'Username': Username,
          'Contact No': Phoneno,
          'Email': email,
        }
    );
  }

  Future ? Getdata() async {
    DocumentSnapshot snap = await userdetails.doc(uid).get();
    var data = snap.data() as Map;

    return data;
  }
}

