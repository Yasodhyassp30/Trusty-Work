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
               height: MediaQuery.of(context).size.height,
              child: SafeArea(
                    child: Column(
                      children: [
                       Container(
                         padding: EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           color: Colors.lightGreen[400],
                           borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),

                         ),
                         child:  Row(
                           children: [

                             SizedBox(width: 5.0,),
                             Icon(Icons.list_alt,color: Colors.white,size: 30,),
                             SizedBox(width: 10.0,),
                             Text("Orders ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                             Expanded(child:SizedBox()),


                           ],
                         ),
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
                              Container(
                                height: MediaQuery.of(context).size.height*0.7,
                                child:  ListView.builder(itemCount: objects.length,itemBuilder: (context,index){
                                  return Card(
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
                                              Text(objects[index]['title'], style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.green[500]),),
                                              (objects[index]['completed']) ?
                                              Text('Status : Completed',
                                                style: TextStyle(
                                                    color: Colors.green),) :
                                              (objects[index]['accepted']) ?
                                              Text('Status : Ongoing',
                                                  style: TextStyle(
                                                      color: Colors.orange)) :
                                              Text('Status : Not Accepted yet',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              SizedBox(height: 20.0,),
                                              Text('Address : ${objects[index]['address']}',style: TextStyle(fontSize: 18.0),),
                                              Text('Agreed Payment : \$ ${objects[index]['payment']}',style: TextStyle(fontSize: 18.0,color: Colors.brown),),

                                              ElevatedButton(onPressed:()async{
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>viewrequest(requestdetails: objects[index],)),
                                                );
                                              }, child:Text("View Details"),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Colors.lightGreen[500])
                                                  )
                                              ),
                                            ],
                                          ),),
                                          (!objects[index]['completed'] && !objects[index]['accepted']
                                              ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                final d1 = WorkRequests(
                                                    Reciever: objects[index]['Reciever'],
                                                    Contractor: objects[index]['Contractor']);
                                                await d1.deleterecord(objects[index]);
                                              },
                                              icon: Icon(Icons.cancel, size: 30.0,
                                                color: Colors.red,),
                                              label: Text(""),),
                                          )
                                              :
                                          (objects[index]['completed']) ? Align(
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


                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
              ),
             );
           }else{
             return Scaffold(
                 body:SafeArea(
                   child: Column(
                     children: [
                       Container(
                         padding: EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           color: Colors.lightGreen[400],
                           borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),

                         ),
                         child:  Row(
                           children: [

                             SizedBox(width: 5.0,),
                             Icon(Icons.list_alt,color: Colors.white,size: 30,),
                             SizedBox(width: 10.0,),
                             Text("Orders ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                             Expanded(child:SizedBox()),


                           ],
                         ),
                       ),
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
                       Container(
                         padding: EdgeInsets.only(top: 50.0),
                         child: Align(
                           alignment: Alignment.center,
                           child: Text('No Requests Found',style: TextStyle(color: Colors.brown,fontSize: 25.0,),),
                         ),
                       )
                     ],
                   ),
                 )
             );

           }

         }
        );

  }
}
