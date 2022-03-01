import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String ? Keyword;
  List worktypes =[
    ['Mechanic','Plumber'],['Gardener','Electrician'],['Cleaner','Search']
  ];
  List<DocumentSnapshot?>workers=[];
  bool searched =false;
  Widget rowbuttons(e){
   return Column(
     children: [
       Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
        Expanded(child:  ElevatedButton(onPressed: (){

        },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.green[400]),
          ),

          child:Column(
            children: [
              SizedBox(height: 10,),
              Image.asset('assets/${e[0]}.png',height: MediaQuery.of(context).size.height*0.10,width: MediaQuery.of(context).size.width*0.30,),
              SizedBox(height: 10,),
              Text("${e[0]}",style: TextStyle(fontSize: 25.0),),
              SizedBox(height: 10.0)
            ],
          ) ,
        ),),
        SizedBox(width: 10.0,),
      Expanded(child:  ElevatedButton(onPressed: (){

      },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.brown[400])
        ),
        child:Column(
          children: [
            SizedBox(height: 10,),
            Image.asset('assets/${e[1]}.png',height: MediaQuery.of(context).size.height*0.10,width: MediaQuery.of(context).size.width*0.30),
            SizedBox(height: 10,),
            Text("${e[1]}",style: TextStyle(fontSize: 25.0),),
            SizedBox(height: 10.0)
          ],
        ) ,
      ))
     ],
   ),
    SizedBox(height: 10.0,)
     ],
   );
  }
  Widget build(BuildContext context) {

    final currentuser =Provider.of<myUser?>(context);
    final DatabaseService d1=DatabaseService();
    String ? pic=currentuser?.PicUrl;
    String ? username =currentuser?.username;
    FirebaseAuth _auth=FirebaseAuth.instance;

    TextEditingController key= TextEditingController();
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
                        backgroundImage: AssetImage('assets/avatar.png'),
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
    return Scaffold(
      body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 5.0),
        child:SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          image:DecorationImage( image: NetworkImage(pic!),fit: BoxFit.fill)

                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome !",style: TextStyle(fontSize: 25.0,color: Colors.green[900]),),
                        Text(username!,style: TextStyle(fontSize: 18.0,color: Colors.brown))
                      ],
                    ),
                    Expanded(child:SizedBox()),
                    IconButton(
                      icon: Icon(Icons.exit_to_app_outlined,size: 30,color: Colors.brown,),
                      onPressed:()async{
                        await _auth.signOut();
                      },)

                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Column(
                      children: [
                        TextField(
                          controller: key,
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
                                  var dataworkers = await d1.FindWorkers(key.text.toLowerCase());
                                  setState(() {
                                    searched=true;
                                    Keyword =key.text;
                                    workers = dataworkers;

                                  });
                                }
                            ),
                          ),


                        ),
                      ],
                    )),

                  ],
                ),
                SizedBox(height: 10.0,),

                (searched)? Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.0,),
                    Row(
                      children: [
                        Container(
                          child: Text(" Search results",style: TextStyle(fontSize: 20.0),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),

                        Expanded(child: SizedBox()),
                        IconButton(onPressed: (){
                          setState(() {
                            searched=false;
                          });
                        }, icon: Icon(Icons.cancel)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    (workers.length>0) ? Column(
                      children: workers.map((e) => foundworkers(e?.data())).toList(),
                    ): Align(child: Text("No workers found",style: TextStyle(fontSize: 30.0,color: Colors.green[300]),),
                      alignment: Alignment.center,)
                  ],
                ):

                Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0)

                  ),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Column(
                          children: worktypes.map((e) =>rowbuttons(e) ).toList(),
                        )

                      ]
                  ),
                )


              ],
            ),

        ),
      )),
    );
  }
}
