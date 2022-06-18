import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class massege{
  String ? reciever , sender;
  massege({this.reciever,this.sender});

  final CollectionReference messagestore = FirebaseFirestore.instance.collection('messages');

  Future ? Recieverupdate(String message)async{

        DocumentSnapshot s1=await messagestore.doc(reciever).get();

    if(s1.exists){


      await messagestore.doc(reciever).update({'messages':FieldValue.arrayUnion([
        {
          'with':sender,
          'sender':sender,
          'reciever':reciever,
          'message':message,
          'time':DateTime.now()
        }
      ])});


    }else{
      return await messagestore.doc(reciever).set(
          {
            'messages':[
              {
                'with':sender,
                'sender':sender,
                'reciever':reciever,
                'message':message,
                'time':DateTime.now()
              }
            ],

          }
      );
    }


  }

  Future ? senderupdate(String message)async{
    DocumentSnapshot s1=await messagestore.doc(sender).get();
    if(s1.exists){
      await messagestore.doc(sender).update({'messages':FieldValue.arrayUnion([
        {
          'with':reciever,
          'sender':sender,
          'reciever':reciever,
          'message':message,
          'time':DateTime.now()
        }
      ])});

    }else{
      return await messagestore.doc(sender).set(
          {
            'messages':[
              {
                'with':reciever,
                'sender':sender,
                'reciever':reciever,
                'message':message,
                'time':DateTime.now()
              }
            ],

          }
      );
    }


  }
}