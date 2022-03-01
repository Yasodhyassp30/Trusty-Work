import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/database.dart';
import 'package:sem/userwidgets/viewrequests.dart';
import '../services/workrequests.dart';

class allrequests extends StatefulWidget {
  const allrequests({Key? key}) : super(key: key);

  @override
  _allrequestsState createState() => _allrequestsState();
}

class _allrequestsState extends State<allrequests> {
  @override
  final _auth=FirebaseAuth.instance;
  bool all=true;
  bool onging=false;
  bool completed=false;
  bool not =false;

  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('requests').doc(_auth.currentUser!.uid).snapshots(),
        builder:(context,snapshot){

         if(snapshot.connectionState==ConnectionState.waiting){

           return loadfadingcube();

         }else{
           List objects=[];
           if(snapshot.data?.data()!=null){
             if(all){
               objects=snapshot.data!.get('requests');
             }else if(onging){
               for(var i in snapshot.data?.get('requests')){
                 if(i['accepted']&&!i['completed']){
                   objects.add(i);
                 }
               }
             }else if(completed){
               for(var i in snapshot.data?.get('requests')){
                 if(i['completed']){
                   objects.add(i);
                 }
               }
             }else if(not){
               for(var i in snapshot.data?.get('requests')){
                 if(!i['accepted']&&!i['completed']){
                   objects.add(i);
                 }
               }
             }

             return Container(
              child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [

                            SizedBox(height: 5.0,),
                            Text("Orders ",style: TextStyle(fontSize: 25.0,color: Colors.green[900]),),
                            Expanded(child:SizedBox()),
                            IconButton(
                              icon: Icon(Icons.exit_to_app_outlined,size: 30,color: Colors.brown,),
                              onPressed:()async{
                                await _auth.signOut();
                              },)

                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(onPressed: (){
                                      setState(() {
                                        all=true;
                                        completed=false;
                                        onging=false;
                                        not=false;
                                      });

                                    },
                                      child: Text('All',style: TextStyle(color:all ? Colors.green[900]:Colors.grey ),),),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        all=false;
                                        completed=true;
                                        onging=false;
                                        not=false;
                                      });

                                    },
                                      child: Text('Completed',style: TextStyle(color:completed ? Colors.green[900]:Colors.grey ),),),

                                    TextButton(onPressed: (){
                                      setState(() {
                                        all=false;
                                        completed=false;
                                        onging=true;
                                        not=false;
                                      });

                                    },
                                      child: Text('Ongoing',style: TextStyle(color:onging ? Colors.green[900]:Colors.grey ),),),
                                    TextButton(onPressed: (){
                                      setState(() {
                                        all=false;
                                        completed=false;
                                        onging=false;
                                        not=true;
                                      });

                                    },
                                      child: Text('Not Accepted',style: TextStyle(color:not ? Colors.green[900]:Colors.grey ),),)
                                  ],
                                ),
                              ),
                              Column(
                                children:objects.map((e) =>  Card(
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
                                                fontSize: 25.0,
                                                color: Colors.green[500]),),
                                            (e['completed']) ?
                                            Text('Status : Completed',
                                              style: TextStyle(
                                                  color: Colors.green),) :
                                            (e['accepted']) ?
                                            Text('Status : Ongoing',
                                                style: TextStyle(
                                                    color: Colors.orange)) :
                                            Text('Status : Not Accepted yet',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            SizedBox(height: 20.0,),
                                            Text('Address : ${e['address']}',style: TextStyle(fontSize: 18.0),),
                                            Text('Agreed Payment : \$ ${e['payment']}',style: TextStyle(fontSize: 18.0,color: Colors.brown),),

                                            ElevatedButton(onPressed:()async{
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>viewrequest(requestdetails: e,)),
                                              );
                                            }, child:Text("View Details"),
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.lightGreen[500])
                                                )
                                            ),
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
                                          child:Icon(Icons.assignment_turned_in,
                                            size: 30.0, color: Colors.green,),

                                        ) :
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child:  Icon(
                                            Icons.airport_shuttle, size: 30.0,
                                            color: Colors.orange,),

                                        )
                                        ),


                                      ],
                                    ),
                                  ),


                                )).toList(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ),
               );
           }else{
             return Container();

           }

         }
        });

  }
}
