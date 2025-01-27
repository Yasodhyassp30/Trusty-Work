import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/workrequests.dart';
import 'package:sem/userwidgets/locationsend.dart';
import 'package:intl/intl.dart';

class requests extends StatefulWidget {
  final reciever;
  const requests({Key? key, this.reciever}) : super(key: key);

  @override
  _requestsState createState() => _requestsState();
}

class _requestsState extends State<requests> {
  @override
  LatLng loca = LatLng(0.0, 0.0);
  Set<Marker> mark = {};
  GoogleMapController? control;
  bool loading = false;
  DateTime? picked;
  Location userlocation = Location();
  final namecontroller = TextEditingController();
  final contactcontroller = TextEditingController();
  final paymentcontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final titlecontroller = TextEditingController();

  String? name, address, contact, title, error = "";
  double? payment;
  final _auth = FirebaseAuth.instance;
  void getlocation() async {
    LocationData temp;
    temp = await userlocation.getLocation();
    loca = LatLng(temp.latitude!, temp.longitude!);
    mark.add(Marker(
        markerId: MarkerId("User"),
        position: loca,
        icon: BitmapDescriptor.defaultMarker));
    control?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(loca.latitude, loca.longitude), zoom: 16)));
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocation();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (loading) {
      return loadfadingcube();
    } else {
      return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50))),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Create Request ",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  Text('$error', style: TextStyle(color: Colors.red)),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            controller: titlecontroller,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText: 'Title',
                              hintStyle: TextStyle(color: Colors.brown),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            controller: namecontroller,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText: 'Name of Contractor',
                              hintStyle: TextStyle(color: Colors.brown),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            controller: contactcontroller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText: 'Contact No',
                              hintStyle: TextStyle(color: Colors.brown),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            controller: paymentcontroller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText: 'Agreed Payment',
                              hintStyle: TextStyle(color: Colors.brown),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                            controller: addresscontroller,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText: 'Address',
                              hintStyle: TextStyle(color: Colors.brown),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        (picked == null)
                            ? Text("")
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.green[100]),
                                child: Text(
                                  'Date : ${DateFormat('yyyy-MM-dd').format(picked!)}',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.brown),
                                )),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Pick Location",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          height: 300.0,
                          child: GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              control = controller;
                            },
                            initialCameraPosition:
                                CameraPosition(target: loca, zoom: 16.0),
                            markers: mark,
                            onTap: (latlang) {
                              mark.clear();
                              loca = latlang;
                              mark.add(Marker(
                                  markerId: MarkerId("User"),
                                  position: loca,
                                  icon: BitmapDescriptor.defaultMarker));
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton.icon(
                                onPressed: () async {
                                  DateTime selectedDate = DateTime.now();

                                  picked = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: selectedDate,
                                      lastDate:
                                          DateTime(selectedDate.year + 1));
                                  if (picked != null)
                                    setState(() {
                                      selectedDate = picked!;
                                    });
                                },
                                icon: Icon(Icons.calendar_month),
                                label: Text("Pick Date"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black38,
                                    padding: EdgeInsets.all(12)),
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton.icon(
                          onPressed: () async {
                            final requestobject = WorkRequests(
                                Contractor: _auth.currentUser!.uid,
                                Reciever: widget.reciever['uid']);
                            if (!(await requestobject.checkongoing())) {
                              setState(() {
                                name = namecontroller.text;
                                address = addresscontroller.text;
                                payment =
                                    double.tryParse(paymentcontroller.text);
                                contact = contactcontroller.text;
                                title = titlecontroller.text;
                                loading = true;
                              });
                              if (name != "" &&
                                  address != "" &&
                                  paymentcontroller.text != "" &&
                                  (contact != "" && contact!.length == 10) &&
                                  loca != null &&
                                  title != "" &&
                                  picked != null) {
                                await requestobject.sendrequests(
                                    name!,
                                    address!,
                                    payment!,
                                    contact!,
                                    loca,
                                    title!,
                                    DateFormat('yyyy-MM-dd').format(picked!));

                                setState(() {
                                  loading = false;
                                  error = "";
                                });
                                Navigator.pop(context);
                              } else {
                                if (contact!.length != 10) {
                                  setState(() {
                                    error =
                                        "Contact Number must be 10 digits long";
                                    loading = false;
                                  });
                                } else if (loca == null) {
                                  error = "Please Pick Location on the Map";
                                  loading = false;
                                } else if (picked == null) {
                                  error = "Please pick a Date";
                                } else {
                                  error = "Fill  all Fields";
                                  loading = false;
                                }
                              }
                            } else {
                              setState(() {
                                error = 'Ongoing Work request Remaining';
                                loading = false;
                              });
                            }
                          },
                          icon: Icon(Icons.assignment_turned_in),
                          label: Text("Send Request"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.all(20)),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            )),
      );
    }
  }
}
