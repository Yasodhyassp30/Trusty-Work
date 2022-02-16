import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/services/workrequests.dart';

class requestforindividual extends StatefulWidget {
  final uid;
  const requestforindividual({Key? key,this.uid}) : super(key: key);

  @override
  _requestforindividualState createState() => _requestforindividualState();
}

class _requestforindividualState extends State<requestforindividual> {
  @override
  final _auth=FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').doc(_auth.currentUser!.uid).collection(widget.uid).snapshots(),
        builder: (context,snapshot){
          List objects=[];
          if(snapshot.data!.docs.isNotEmpty){


            return Container(
                padding: EdgeInsets.only(top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children:snapshot.data!.docs.map((e) =>Card(
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(

                            children: [
                              Expanded(child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e['title']),
                                  Text(e['address']),
                                  Text('${e['payment']}'),
                                ],
                              ),),
                              (!e['completed']?  Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(onPressed: ()async{

                                  final d1 =WorkRequests(Reciever: e['Reciever'],Contractor: e['Contractor']);
                                  await d1.deleterecord(e.id,e);
                                }, icon: Icon(Icons.cancel,size: 30.0,color: Colors.red,),label: Text(""), ),
                              ):
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(onPressed: ()async{

                                }, icon: Icon(Icons.assignment_turned_in,size: 30.0,color: Colors.green,),label: Text(""), ),
                              )
                              ),


                            ],
                          ),
                        )

                    )).toList(),
                  ),
                )

            );
          }else{
            return Container(

            );
          }


        });

  }
}
