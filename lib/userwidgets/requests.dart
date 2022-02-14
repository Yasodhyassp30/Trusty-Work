import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class requests extends StatefulWidget {
  const requests({Key? key}) : super(key: key);

  @override
  _requestsState createState() => _requestsState();
}

class _requestsState extends State<requests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Work Request'),
        backgroundColor: Colors.green[500],

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
        child:Column(
          children: [
            TextFormField(),
            SizedBox(height: 10.0,),
            TextFormField(),
            SizedBox(height: 10.0,),
            ElevatedButton(onPressed: (){

            }, child: Text("Pick Location")),
          ],
        ),
      ),
    );
  }
}
