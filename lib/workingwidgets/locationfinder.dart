import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class locationfind extends StatefulWidget {
  final locationdetails;
  const locationfind({Key? key, this.locationdetails}) : super(key: key);

  @override
  _locationfindState createState() => _locationfindState();
}

class _locationfindState extends State<locationfind> {
  Location location = Location();
  LocationData? current;
  String? error;
  LatLng? initital = LatLng(0, 0);
  GoogleMapController? control;

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> marks = {};

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    locationservice();
    marks.add(Marker(
        markerId: MarkerId("Work Location"),
        position: LatLng(
            widget.locationdetails['lat'], widget.locationdetails['long']),
        icon: BitmapDescriptor.defaultMarker));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Route",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: initital!, zoom: 20),
                  onMapCreated: (GoogleMapController ctrl) {
                    control = ctrl;
                  },
                  markers: marks,
                  polylines: Set<Polyline>.of(polylines.values),
                  myLocationEnabled: true,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextButton.icon(
                          onPressed: () async {
                            PolylineResult result =
                                await polylinePoints.getRouteBetweenCoordinates(
                                    "AIzaSyAgC4P5p4181BA5_CuceOL844uAsXvw57Y",
                                    PointLatLng(initital!.latitude,
                                        initital!.longitude),
                                    PointLatLng(widget.locationdetails['lat'],
                                        widget.locationdetails['long']),
                                    travelMode: TravelMode.driving);
                            polylineCoordinates = [];
                            result.points.forEach((element) {
                              polylineCoordinates.add(
                                  LatLng(element.latitude, element.longitude));
                            });
                            setState(() {
                              polylines = {};
                              PolylineId id = PolylineId("route");
                              Polyline polyline = Polyline(
                                polylineId: id,
                                color: Colors.green,
                                points: polylineCoordinates,
                                width: 10,
                              );
                              polylines[id] = polyline;
                            });
                          },
                          icon: Icon(
                            Icons.airport_shuttle,
                            size: 40.0,
                            color: Colors.green[500],
                          ),
                          label: Text(
                            "  Start",
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.green),
                          ),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  Future locationservice() async {
    bool serviceen = await location.serviceEnabled();
    await location.requestPermission();
    if (!serviceen) {
      bool reqserviceres = await location.requestService();
      if (!reqserviceres) {
        setState(() {
          error = "Service Not Enabled";
          return;
        });
      }
    }

    PermissionStatus permission = await location.hasPermission();
    if (!serviceen) {
      PermissionStatus reqserviceres = await location.requestPermission();
      if (reqserviceres == PermissionStatus.denied) {
        setState(() {
          error = "Permission Not Granted";
          return;
        });
      }
    }
    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000, distanceFilter: 5);
    current = await location.getLocation();
    location.onLocationChanged.listen((event) async {
      print(event);
      setState(() {
        current = event;
        initital = LatLng(event.latitude!, event.longitude!);
        control?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(event.latitude!, event.longitude!), zoom: 20)));
      });
    });
  }
}
