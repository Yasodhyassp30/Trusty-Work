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

          return Scaffold(
            body: SafeArea(
             child: Container(

               child: SingleChildScrollView(
                   child:Column(
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
                             Icon(Icons.message,color: Colors.white,size: 30,),
                             SizedBox(width: 10.0,),
                             Text("Messages ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                             Expanded(child:SizedBox()),


                           ],
                         ),
                       ),
                       SizedBox(height: 20.0,),
                       Container(
                         padding: EdgeInsets.all(10),
                         child:  chatcard(s1: ids,lastmessage: msgs,),
                       )


                     ],
                   )


               ),
             ),
            )
          );

        }else{
          return Scaffold(
              body:SafeArea(
                child:Column(
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
                          Icon(Icons.message,color: Colors.white,size: 30,),
                          SizedBox(width: 10.0,),
                          Text("Messages ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                          Expanded(child:SizedBox()),


                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('No Conversations Found',style: TextStyle(color: Colors.brown,fontSize: 25.0,),),
                      ),
                    )
                  ],
                )
              )
          );
      }

      }


    });
  }
}
