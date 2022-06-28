import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class locationsender extends StatefulWidget {
  const locationsender({Key? key}) : super(key: key);

  @override
  _locationsenderState createState() => _locationsenderState();
}

class _locationsenderState extends State<locationsender> {
  @override
 final _position=CameraPosition(target: LatLng(6,80),zoom: 10.0);
  Set<Marker>marker={};
  bool pickinglocation=false;
  LatLng ? current ;
  GoogleMapController ? _con;

  void togglepicker(){
    setState(() {
      pickinglocation=!pickinglocation;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
        actions: [
      ElevatedButton.icon(
        icon: Icon(Icons.assignment_turned_in),
        label: Text('Confirm'),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.brown)
        ),
        onPressed: (){
          Navigator.pop(context,current);
        },
      )
      ],
        backgroundColor: Colors.green[500],

      ),
      body:GoogleMap(initialCameraPosition: _position,
      onMapCreated: (GoogleMapController controller){
        _con=controller;
      },
      markers:marker,
      mapType: MapType.normal,
      onTap: (latlang){
        setState(() {
          if(pickinglocation) {
            marker.add(
                Marker(markerId: MarkerId("Work Location"),
                    position: latlang,
                    icon: BitmapDescriptor.defaultMarker)
            );
            current=latlang;
            togglepicker();
          }
        });

      },
    ),

        floatingActionButton: FloatingActionButton(
        onPressed: togglepicker,
          child: Icon(Icons.location_on),
          backgroundColor: Colors.brown,
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );

  }
}
