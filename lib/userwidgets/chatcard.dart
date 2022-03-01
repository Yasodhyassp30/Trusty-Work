import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sem/userwidgets/chatbox.dart';
import 'package:intl/intl.dart';

class chatcard extends StatefulWidget {
  final List ? s1;
  final Map ? lastmessage;
  const chatcard({Key? key,this.s1,this.lastmessage}) : super(key: key);

  @override
  _chatcardState createState() => _chatcardState();
}


class _chatcardState extends State<chatcard> {
  String searchkey="";
  @override
  Widget getTextWidgets(item)
  {

    if(item!=null){
      return GestureDetector(

        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => messenger(reciver: item,)),
          );
        },
         child: Card(

              child:Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Row(

                    children: [
                      SizedBox(width: 10.0,),
                      Expanded(
                          flex: 3,
                          child:CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage('assets/avatar.png'),
                            foregroundImage: NetworkImage(
                                item['photoURL']
                            ),
                          )
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                          flex: 7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['Username'],style: TextStyle(fontSize: 20.0,color: Colors.green),),
                              Text(widget.lastmessage![item['uid']]['msg']),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text('${DateFormat('yy-MM-dd  ').add_jm().format(widget.lastmessage![item['uid']]['time'].toDate())}',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              )

                            ],
                          ))

                    ],)
              )
          )
      ) ;

    }else{
      return new Container();
    }



  }
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(future:FirebaseFirestore.instance.collection('userdata').where('uid',whereIn: widget.s1).get() ,
    builder: (context,snapshot){
      if(snapshot.hasData){
        final  docs =snapshot.data!.docs.reversed.toList();
        List result=[];

        if(searchkey!=""){
          docs.forEach((element) {
            if(element.get('Username').toLowerCase().contains(searchkey.toLowerCase())){
              result.add(element);
            }
          });
        }else{
          result= docs;
        }
        result=result.reversed.toList();
        return Container(
          child: Column(
           children: [
             TextField(
               decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(30.0),
                   borderSide: BorderSide(color: Colors.green)
                 ),
                 enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30.0),
                     borderSide: BorderSide(color: Colors.green)
                 ),
                 hintText: 'Search by Name',
                 hintStyle:TextStyle(color: Colors.brown),
                 prefixIcon: Icon(Icons.search_rounded,color: Colors.brown,),


               ),

               onChanged: (val){
                 setState(() {
                   searchkey=val;
                 });
               },
             ),
             SizedBox(height: 20.0,),

             Container(
               padding: EdgeInsets.all(10.0),

               decoration: BoxDecoration(
                   color: Colors.grey[200],
                 borderRadius: BorderRadius.circular(15.0)
               ),
               child:Column(
                 children:
                 result.map((e) => getTextWidgets(e.data())).toList(),

               ) ,
             )

           ],

          ),
        );
      }else{
        return Container(

          );
      }


    }
    );
  }
}
