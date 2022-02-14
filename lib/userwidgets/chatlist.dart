import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/database.dart';
import 'package:sem/userwidgets/chatcard.dart';

class chatlist extends StatefulWidget {
  const chatlist({Key? key}) : super(key: key);

  @override
  _chatlistState createState() => _chatlistState();
}

class _chatlistState extends State<chatlist> {
  @override

  Widget build(BuildContext context) {
    FirebaseAuth _auth=FirebaseAuth.instance;
    List <String> ids=[];
    Map<dynamic ,dynamic> msgs={};
    return  StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').doc(_auth.currentUser?.uid).snapshots(),
    builder: (context,snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loadfadingcube();
      }else{
        msgs={};
        ids=[];
        Map<dynamic,dynamic> detailsmsg={};
        if(snapshot.data?.data()!=null){
          for(var  i in snapshot.data!['messages']){
            detailsmsg={};
            detailsmsg['msg']=i['message'];
            detailsmsg['time']=i['time'];
            if(ids.contains(i['with'])){

              msgs[i['with']]=detailsmsg;
            }else{
              ids.add(i['with']);
              msgs[i['with']]=detailsmsg;
            }

          }

          return Container(
            child: SingleChildScrollView(
              child: chatcard(s1: ids,lastmessage: msgs,),

            ),
          );

        }else{
          return Container(
              child: Align(
                alignment: Alignment.center,
                child: Text('No Conversations Found',style: TextStyle(color: Colors.brown,fontSize: 25.0,),),
              )
          );
      }

      }


    });
  }
}
