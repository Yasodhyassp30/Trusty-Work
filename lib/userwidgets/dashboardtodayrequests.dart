import 'package:flutter/material.dart';
import 'package:sem/userwidgets/viewrequests.dart';

import '../services/workrequests.dart';

class expandedtodayrequests extends StatefulWidget {
  final List ? requests;
  const expandedtodayrequests({Key? key,this.requests}) : super(key: key);

  @override
  _expandedtodayrequestsState createState() => _expandedtodayrequestsState();
}

class _expandedtodayrequestsState extends State<expandedtodayrequests> {
  Widget getrequests(e){
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


    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),),
                    SizedBox(width: 10.0,),
                    Text("Back ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                    Expanded(child:SizedBox()),


                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              (widget.requests!.length>0)? Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: widget.requests!.map((e) => getrequests(e)).toList(),
                ),
              ):Container(
                height: MediaQuery.of(context).size.height*0.8,
                width:MediaQuery.of(context).size.width*0.9 ,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15.0)
                ),
                padding: EdgeInsets.only(top: 30.0),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Items to Display",style: TextStyle(color: Colors.brown,fontSize: 20.0),),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
