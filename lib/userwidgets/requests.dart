import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/workrequests.dart';
import 'package:sem/userwidgets/locationsend.dart';


class requests extends StatefulWidget {
  final reciever;
  const requests({Key? key,this.reciever}) : super(key: key);

  @override
  _requestsState createState() => _requestsState();
}

class _requestsState extends State<requests> {
  @override

  LatLng  ? loca;
  Set<Marker>mark={};
  GoogleMapController ? control;
  bool loading =false;
  final namecontroller = TextEditingController();
  final contactcontroller =TextEditingController();
  final paymentcontroller =TextEditingController();
  final addresscontroller=TextEditingController();
  final titlecontroller=TextEditingController();

  String ?name,address,contact,title,error="";
  double ? payment;
  final _auth =FirebaseAuth.instance;

  Widget build(BuildContext context) {
    if(loading){
      return loadfadingcube();
    }else{
      return Scaffold(
        appBar: AppBar(
          title: Text('Send Work Request'),
          backgroundColor: Colors.green[500],

        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
          child:Column(
            children: [

              Text('$error',style:TextStyle(color: Colors.red)),
              TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: 'Title',
                    hintStyle:TextStyle(color: Colors.brown),
                  )
              ),


              SizedBox(height: 10.0,),

              TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: 'Name of Contractor',
                    hintStyle:TextStyle(color: Colors.brown),
                  )
              ),


              SizedBox(height: 10.0,),

              TextFormField(
                  controller: contactcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: 'Contact No',
                    hintStyle:TextStyle(color: Colors.brown),
                  )
              ),

              SizedBox(height: 10.0,),


              TextFormField(
                  controller: paymentcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: 'Agreed Payment',
                    hintStyle:TextStyle(color: Colors.brown),
                  )

              ),

              SizedBox(height: 10.0,),


              TextFormField(
                  controller: addresscontroller,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: 'Address',
                    hintStyle:TextStyle(color: Colors.brown),
                  )
              ),
              SizedBox(height: 10.0,),


              (loca==null)?Text("not selected"):Container(
                height: 200.0,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller){

                      control=controller;

                  },
                  initialCameraPosition: CameraPosition(target: loca!,zoom: 10.0),
                  markers: mark,
                ),

              ),
              SizedBox(height: 10.0,),
              ElevatedButton(onPressed: ()async{
                dynamic result =await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>locationsender()),
                );
                setState(() {
                  loca=result;
                  if(result!=null){
                    mark.add(
                        Marker(markerId: MarkerId("Work Location"),
                            position: loca!,
                            icon: BitmapDescriptor.defaultMarker)
                    );
                    CameraUpdate update= CameraUpdate.newCameraPosition(CameraPosition(target: loca!,zoom: 10.0));
                    control?.moveCamera(update);
                  }
                });
              }, child: Text("Pick Location"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.  green[600])
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:FloatingActionButton(
          onPressed:()async{

            final requestobject=WorkRequests(Contractor: _auth.currentUser!.uid,Reciever: widget.reciever['uid']);
            if(!(await requestobject.checkongoing())){
              setState(() {
                name=namecontroller.text;
                address=addresscontroller.text;
                payment=double.tryParse(paymentcontroller.text);
                contact=contactcontroller.text;
                title=titlecontroller.text;
                loading=true;
              });
              if(name!=""&&address!=""&&paymentcontroller.text!=""&&(contact!=""&&contact!.length==10)&&loca!=null&& title!=""){

                await requestobject.sendrequests(name!, address!, payment!, contact!,loca!,title!);

                setState(() {
                  loading=false;
                  error="";
                });
                Navigator.pop(context);
              }else{
                if(contact!.length!=10){
                  setState(() {
                    error="Contact Number must be 10 digits long";
                    loading=false;
                  });
                }else if(loca==null){
                  error="Please Pick Location on the Map";
                  loading=false;
                }else{
                  error="Fill  all Fields";
                  loading=false;
                }
              }

            }else{
              setState(() {
                error='Ongoing Work request Remaining';
                loading=false;
              });
            }

          },
          child: Icon(Icons.assignment_turned_in),
          backgroundColor: Colors.brown,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      );

    }

  }
}
