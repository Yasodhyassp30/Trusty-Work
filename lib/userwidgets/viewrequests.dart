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
              appBar: AppBar(
                title: Text('Back'),
                backgroundColor: Colors.green[500],
              ),
              body: SafeArea(
                child:SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Request Details",style: TextStyle(color: Colors.brown,fontSize: 30.0),),
                      SizedBox(height: 10.0,),
                      Text(widget.requestdetails['title'],style: TextStyle(fontSize: 20.0),),
                      SizedBox(height: 10.0,),
                      (!widget.requestdetails['accepted'])? Text("Status : Not Accepted",style: (TextStyle(color: Colors.red)),):
                      (widget.requestdetails['completed'])? Text("Status : Completed",style: (TextStyle(color: Colors.green[500])),):
                      Text("Status : Ongoing",style: TextStyle(color: Colors.orange),),
                      Text("Price : \$ ${widget.requestdetails['payment']}"),
                      Text("Contact : ${widget.requestdetails['Contact_no']}"),
                      Text("${widget.requestdetails['address']}"),
                      SizedBox(height: 20.0,),
                      Container(
                          height: 300.0,
                          child:GoogleMap(
                            initialCameraPosition:CameraPosition(target:LatLng(widget.requestdetails['lat'],widget.requestdetails['long']),zoom: 15.0) ,
                            markers: marks,
                          )
                      ),
                      SizedBox(height: 10.0,),
                      Text("Worker Details",style: TextStyle(color: Colors.brown,fontSize: 30.0),),
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
                                      initialRating: (widget.requestdetails['rating']!=-1) ? widget.requestdetails['rating']:0,
                                      ignoreGestures: (widget.requestdetails['rating']!=-1)? true:false,
                                      allowHalfRating: true,
                                      itemBuilder: (context,_)=>Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rate){
                                              setState(() {
                                                rating=rate;
                                              });
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
                                      ElevatedButton.icon(onPressed: (){
                                        final d1=WorkRequests(Reciever: snapshot.data!['uid'],Contractor:widget.requestdetails['Contractor'] );
                                        d1.updaterating(widget.requestdetails, rating);

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
                  ),
                ),
              )
          );
        }
        });

  }
}
