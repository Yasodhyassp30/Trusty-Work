import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/workingwidgets/gallery_request.dart';
import 'package:sem/workingwidgets/locationfinder.dart';
import '../services/workrequests.dart';

class singlerequest extends StatefulWidget {
  final requestdetails;
  const singlerequest({Key? key, this.requestdetails}) : super(key: key);

  @override
  _singlerequestState createState() => _singlerequestState();
}

class _singlerequestState extends State<singlerequest> {
  @override
  Set<Marker> marks = {};
  double rating = 0.0;

  Widget build(BuildContext context) {
    final requestobject = WorkRequests(
        Contractor: widget.requestdetails['Contractor'],
        Reciever: widget.requestdetails['Reciever']);

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('userdata')
            .doc(widget.requestdetails['Reciever'])
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
          } else {
            marks.add(Marker(
                markerId: MarkerId("Work Location"),
                position: LatLng(widget.requestdetails['lat'],
                    widget.requestdetails['long']),
                icon: BitmapDescriptor.defaultMarker));

            return Scaffold(
                body: SafeArea(
              child: SingleChildScrollView(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen[400],
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(50)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Back ",
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Request Details",
                                    style: TextStyle(
                                        color: Colors.brown, fontSize: 30.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    widget.requestdetails['title'],
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    widget.requestdetails['Name'],
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  (!widget.requestdetails['accepted'])
                                      ? Text(
                                          "Status : Not Accepted",
                                          style: (TextStyle(color: Colors.red)),
                                        )
                                      : (widget.requestdetails['completed'])
                                          ? Text(
                                              "Status : Completed",
                                              style: (TextStyle(
                                                  color: Colors.green[500])),
                                            )
                                          : Text(
                                              "Status : Ongoing",
                                              style: TextStyle(
                                                  color: Colors.orange),
                                            ),
                                  Text(
                                      "Price : \$ ${widget.requestdetails['payment']}"),
                                  Text(
                                      "Contact : ${widget.requestdetails['Contact_no']}"),
                                  Text("${widget.requestdetails['address']}"),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                      height: 300.0,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                widget.requestdetails['lat'],
                                                widget.requestdetails['long']),
                                            zoom: 15.0),
                                        markers: marks,
                                      )),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  (widget.requestdetails['accepted'])
                                      ? (widget.requestdetails['completed'] &&
                                              !widget.requestdetails[
                                                  'galleryrequest']
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          var wait = await Navigator
                                                              .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          galleryrequest(
                                                                            id: widget.requestdetails,
                                                                          )));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "Gallery Request"),
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                            .orangeAccent[
                                                                        500]))))
                                              ],
                                            )
                                          : (!widget
                                                  .requestdetails['completed'])
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            locationfind(
                                                                              locationdetails: widget.requestdetails,
                                                                            )),
                                                              );
                                                            },
                                                            child: Text(
                                                                "View Route"),
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.lightGreen[
                                                                            500]))))
                                                  ],
                                                )
                                              : (widget.requestdetails[
                                                      'accepted'])
                                                  ? Container()
                                                  : Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ElevatedButton
                                                                    .icon(
                                                                        onPressed:
                                                                            () async {
                                                                          await requestobject.acceptrequest(widget
                                                                              .requestdetails
                                                                              .id);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: Icon(Icons
                                                                            .check),
                                                                        label: Text(
                                                                            "Accept"),
                                                                        style: ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.lightGreen[500]))))
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ElevatedButton
                                                                    .icon(
                                                                        onPressed:
                                                                            () async {
                                                                          await requestobject
                                                                              .deleterecord(widget.requestdetails);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: Icon(Icons
                                                                            .clear),
                                                                        label: Text(
                                                                            "Reject"),
                                                                        style: ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.redAccent[500]))))
                                                          ],
                                                        )
                                                      ],
                                                    ))
                                      : Container()
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ));
          }
        });
  }
}
