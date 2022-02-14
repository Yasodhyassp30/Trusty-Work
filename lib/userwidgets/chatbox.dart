import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sem/services/messaging.dart';


class messenger extends StatefulWidget {
  final Map<String,dynamic>? reciver;
  const messenger({Key? key,this.reciver}) : super(key: key);


  @override
  _messengerState createState() => _messengerState();
}

class _messengerState extends State<messenger> {
  @override
  String single="";
  List messageslist=[];
  final _boxcontroller=TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String ? uid ='';
  var con = ScrollController();




  Widget build(BuildContext context) {
    uid =_auth.currentUser?.uid;

    return  StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').doc(uid).snapshots(),
      builder: (context,snapshot){
      if(snapshot.data?.data()!=null){
        messageslist=[];
       for( var i in snapshot.data!['messages']){
         if(i['reciever']==widget.reciver!['uid']||i['sender']==widget.reciver!['uid']){
           messageslist.add(i);
         }
       }

        return Scaffold(

            appBar: AppBar(
              title: Text(widget.reciver!['Username']),
              backgroundColor: Colors.green[500],

            ),
            body:

            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child:  ListView.builder(
                      controller: con,


                      itemCount: messageslist.length,
                      itemBuilder: (context,index){
                        return SingleChildScrollView(

                            padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 5.0),
                            child:Align(

                                alignment:(messageslist[index]['sender']==uid ? Alignment.topRight : Alignment.topLeft),
                                child:Container(
                                  child: Text(messageslist[index]['message'],style: TextStyle(fontSize: 15.0),),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (messageslist[index]['sender']==uid ? Colors.green[300]:Colors.lightGreenAccent ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                )

                            )

                        );


                      }),

                ),



                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(

                    color: Colors.white,
                    padding: EdgeInsets.only(left:25.0,right: 10.0,bottom: 10.0,top: 2.0),
                    child: Row(
                      children: [
                        Expanded(child:
                        TextField(

                          controller: _boxcontroller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            hintText: 'Message',
                            focusedBorder:OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(30.0),
                            ),

                            hintStyle: TextStyle(color: Colors.green[500]),


                          ),
                          onChanged: (val){
                            single=val;
                            con.jumpTo(con.position.maxScrollExtent);
                          },
                          onTap: (){

                          },
                        ),
                        ),
                        TextButton.icon(onPressed: ()async{
                          if(single.length>0) {
                            massege sender = massege(reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,);
                            massege reciver = massege(reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,);
                            await sender.senderupdate(single);
                            await reciver.Recieverupdate(single);
                            setState(() {
                              single='';
                            });
                            _boxcontroller.clear();
                            con.jumpTo(con.position.maxScrollExtent);
                          }
                        }, icon: Icon(Icons.send,size: 40.0,color: Colors.green[500],),label:Text(''),),
                      ],
                    ),

                  ),
                )
              ],
            )

        );
      }else{

        return Scaffold(

            appBar: AppBar(
              title: Text(widget.reciver!['Username']),
              backgroundColor: Colors.green[500],

            ),
            body:

            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child:  ListView.builder(
                      controller: con,


                      itemCount: messageslist.length,
                      itemBuilder: (context,index){
                        return SingleChildScrollView(

                            padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 5.0),
                            child:Align(

                            )

                        );


                      }),

                ),



                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(

                    color: Colors.white,
                    padding: EdgeInsets.only(left:10.0,right: 10.0,bottom: 2.0,top: 2.0),
                    child: Row(
                      children: [
                        Expanded(child:
                        TextField(

                          controller: _boxcontroller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            hintText: 'Message',
                            focusedBorder:OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(30.0),
                            ),

                            hintStyle: TextStyle(color: Colors.green[500]),


                          ),
                          onChanged: (val){
                            single=val;
                            con.jumpTo(con.position.maxScrollExtent);
                          },
                          onTap: (){

                          },
                        ),
                        ),
                        TextButton.icon(onPressed: ()async{
                          if(single.length>0) {
                            massege sender = massege(reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,);
                            massege reciver = massege(reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,);
                            await sender.senderupdate(single);
                            await reciver.Recieverupdate(single);
                            setState(() {
                              single='';
                            });
                            _boxcontroller.clear();
                            con.jumpTo(con.position.maxScrollExtent);
                          }
                        }, icon: Icon(Icons.send,size: 40.0,color: Colors.green[500],),label:Text(''),),
                      ],
                    ),

                  ),
                )
              ],
            )

        );
      }


      }

    );

  }
}
