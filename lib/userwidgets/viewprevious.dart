import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
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
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').doc(_auth.currentUser!.uid).snapshots(),
        builder: (context,snapshot){
          List objects=[];
          if(snapshot.connectionState==ConnectionState.waiting){
            return loadfadingcube();
          }else{
            if(snapshot.data?.data()!=null){
              for(var i in snapshot.data?.get('requests')){
                if(i['Reciever']==widget.uid){
                  objects.add(i);
                }
              }

              if(objects.length>0) {
                return Container(

                    padding: EdgeInsets.only(top: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: objects.map((e) =>
                            Card(

                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(

                                    children: [
                                      Expanded(child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(e['title'], style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.green[500]),),
                                          (e['completed']) ?
                                          Text('Status : Completed',
                                            style: TextStyle(
                                                color: Colors.green),) :
                                          (e['accepted']) ?
                                          Text('Status : Ongoing',
                                              style: TextStyle(
                                                  color: Colors.yellow)) :
                                          Text('Status : Not Accepted yet',
                                              style: TextStyle(
                                                  color: Colors.red)),
                                          Text(e['address']),
                                          Text('${e['payment']}'),
                                        ],
                                      ),),
                                      (!e['completed'] && !e['accepted']
                                          ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: () async {
                                            final d1 = WorkRequests(
                                                Reciever: e['Reciever'],
                                                Contractor: e['Contractor']);
                                            await d1.deleterecord(e);
                                          },
                                          icon: Icon(Icons.cancel, size: 30.0,
                                            color: Colors.red,),
                                          label: Text(""),),
                                      )
                                          :
                                      (e['completed']) ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: () async {

                                          },
                                          icon: Icon(Icons.assignment_turned_in,
                                            size: 30.0, color: Colors.green,),
                                          label: Text(""),),
                                      ) :
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: () async {

                                          },
                                          icon: Icon(
                                            Icons.airport_shuttle, size: 30.0,
                                            color: Colors.yellow,),
                                          label: Text(""),),
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
                  height: 300.0,
                    child: Align(
                      child:Text('No Previous Requests',style: TextStyle(fontSize: 25.0,color: Colors.brown),),
                      alignment: Alignment.center,
                    )
                );
              }
            }else{
              return Container(

              );
            }
          }



        });

  }
}
