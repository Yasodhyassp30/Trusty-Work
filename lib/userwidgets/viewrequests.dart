import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/workrequests.dart';
import 'package:sem/userwidgets/viewworker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class viewrequest extends StatefulWidget {
  final requestdetails;
  const viewrequest({Key? key,this.requestdetails}) : super(key: key);

  @override
  _viewrequestState createState() => _viewrequestState();
}

class _viewrequestState extends State<viewrequest> {

  @override
  Set<Marker>marks={};
  double rating=0.0;
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('userdata').doc(widget.requestdetails['Reciever']).get(),
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return loadfadingcube();
        }else{
          marks.add(
              Marker(markerId: MarkerId("Work Location"),
                  position:LatLng(widget.requestdetails['lat'],widget.requestdetails['long']),
                  icon: BitmapDescriptor.defaultMarker)
          );


          return Scaffold(
              body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50))
                          ),
                          child: Row(
                            children: [

                              SizedBox(height: 5.0,),
                              IconButton(
                                icon: Icon(Icons.arrow_back ,size: 30,color: Colors.white,),
                                onPressed:(){
                                  Navigator.pop(context);
                                },),
                              SizedBox(width: 10.0,),
                              Text("Back ",style: TextStyle(fontSize: 25.0,color: Colors.white),),
                              Expanded(child:SizedBox()),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Expanded(child: Container(
                          padding: EdgeInsets.all(16),
                          child:ListView(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15.0)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Request Details",style: TextStyle(color: Colors.brown,fontSize: 25.0),),
                                      SizedBox(height: 10.0,),
                                      Text(widget.requestdetails['title'],style: TextStyle(fontSize: 20.0),),
                                      SizedBox(height: 10.0,),
                                      (!widget.requestdetails['accepted'])? Text("Status : Not Accepted",style: (TextStyle(color: Colors.red)),):
                                      (widget.requestdetails['completed'])? Text("Status : Completed",style: (TextStyle(color: Colors.green[500])),):
                                      Text("Status : Ongoing",style: TextStyle(color: Colors.orange),),
                                      Text("Price : \$ ${widget.requestdetails['payment']}"),
                                      Text("Contact : ${widget.requestdetails['Contact_no']}"),
                                      Text("${widget.requestdetails['address']}"),
                                      SizedBox(height: 10.0,),
                                    ]
                                  )
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Worker Details",style: TextStyle(color: Colors.brown,fontSize: 25.0),),
                                      SizedBox(height: 10.0,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 6,
                                              child:  Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Username : ${snapshot.data!['Username']}'),
                                                  Text('Contact no : ${snapshot.data!['Contact_No']}'),
                                                  SizedBox(height: 20.0,),

                                                  RatingBar.builder(
                                                      minRating: 0,
                                                      updateOnDrag: true,
                                                      initialRating: (widget.requestdetails['rating']!=-1) ? widget.requestdetails['rating']:rating,
                                                      ignoreGestures: (widget.requestdetails['rating']!=-1)? true:false,
                                                      allowHalfRating: true,
                                                      itemBuilder: (context,_)=>Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rate){

                                                        rating=rate;
                                                      }
                                                  ),
                                                  Row(
                                                    children: [
                                                      ElevatedButton.icon(onPressed: (){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => viewworker(workerdata: snapshot.data!.data(),)),
                                                        );
                                                      },icon: Icon(Icons.person),label: Text("View"), style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all(Colors.green[500])
                                                      ) ),
                                                      SizedBox(width: 10.0,),
                                                      (widget.requestdetails['completed']&&widget.requestdetails['rating']==-1)?
                                                      ElevatedButton.icon(onPressed: ()async{
                                                        final d1=WorkRequests(Reciever: snapshot.data!['uid'],Contractor:widget.requestdetails['Contractor'] );
                                                        await d1.updaterating(widget.requestdetails, rating);
                                                        setState(() {

                                                        });

                                                      },icon: Icon(Icons.person),label: Text("Rate"), style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all(Colors.brown[500])
                                                      ) ): Container()
                                                    ],
                                                  )

                                                ],
                                              )
                                          ),
                                          Expanded(
                                              flex: 4,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.green[500],
                                                radius: 90.0,
                                                foregroundImage: NetworkImage(snapshot.data!['photoURL']),
                                              ))
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[200]
                                  ),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Location Details",style: TextStyle(color: Colors.brown,fontSize: 25.0),),
                                      SizedBox(height: 10.0,),
                                     Container(
                                       height: 300,
                                       child: GoogleMap(
                                         initialCameraPosition:CameraPosition(target:LatLng(widget.requestdetails['lat'],widget.requestdetails['long']),zoom: 15.0) ,
                                         markers: marks,
                                       ),
                                     )
                                    ],
                                  )
                              ),

                            ],
                          ),
                        )),
                        Container(
                          child:  Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [



                            ],
                          ),
                        )


                      ],
                    ),
                  )
                ),
          );
        }
        });

  }
}
