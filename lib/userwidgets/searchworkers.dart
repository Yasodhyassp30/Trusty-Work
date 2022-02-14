import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/userwidgets/viewworker.dart';


class searchworkers extends StatefulWidget {
  const searchworkers({Key? key}) : super(key: key);

  @override
  _searchworkersState createState() => _searchworkersState();
}

class _searchworkersState extends State<searchworkers> {
  @override
  String Keyword="";
  List<DocumentSnapshot?>workers=[];
  Widget build(BuildContext context) {

    final currentuser =Provider.of<myUser?>(context);
    final DatabaseService d1=DatabaseService();
    Widget foundworkers(doc){
      return Card(

        margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
        child: GestureDetector(
          onTap: (){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => viewworker(workerdata:doc)),
            );
          },
          child:Column(
          children:[
          Column(children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Text(doc['Username'],style: TextStyle(fontSize: 15.0),),
                    Text("Contact No :${doc['Contact_No']}",style: TextStyle(fontSize: 15.0),),
                    SizedBox(height: 20.0,)

                  ],
                ), ),
              Expanded(
                  flex: 3,
                  child: Column(

                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green[500],
                        radius: 40.0,
                        foregroundImage: NetworkImage(doc['photoURL']),

                          )
                        ],
                      ))
                ],
              ),
              ],) ,
            ]
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10.0),
      child:SingleChildScrollView(
      child:Column(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Column(
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
                      hintText: 'Search',
                      hintStyle:TextStyle(color: Colors.brown),
                      suffixIcon: IconButton(
                        icon:Icon(Icons.search_rounded,color: Colors.brown),
                      onPressed: ()
                      async {
                        var dataworkers = await d1.FindWorkers(Keyword);
                        setState(() {
                          workers = dataworkers;
                        });
                      }
                      ),
                    ),

                    onChanged: (val){
                      setState(() {
                        Keyword=val.toLowerCase();
                      });
                    },
                  ),
                ],
              )),

            ],
          ),
          Column(
            children: workers.map((e) => foundworkers(e?.data())).toList(),
          )
        ],
      ),
    ),
    );
  }
}
