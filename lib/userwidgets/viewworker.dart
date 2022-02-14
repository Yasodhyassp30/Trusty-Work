import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sem/userwidgets/chatbox.dart';
import 'package:sem/userwidgets/requests.dart';
import 'package:sem/workingwidgets/workeraccount.dart';

class viewworker extends StatefulWidget {
  final Map<String,dynamic>? workerdata;
  const viewworker({Key? key,this.workerdata}) : super(key: key);

  @override
  _viewworkerState createState() => _viewworkerState();
}

class _viewworkerState extends State<viewworker> {
  @override
  Widget getTextWidgets(List<dynamic> works)
  {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: works.map((item) => new Text(item,style: TextStyle(fontSize: 15.0,color: Colors.green),)).toList());
  }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text("Back"),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0,),
            Text(widget.workerdata!['Username'],style: TextStyle(fontSize: 25.0,color: Colors.brown),),
            Row(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 10.0,),
                    Text("Email",style: TextStyle(fontSize: 18.0,color: Colors.brown),),
                    SizedBox(height: 5.0,),
                    Text(widget.workerdata!['Email'],style: TextStyle(fontSize: 15.0,color: Colors.green[800]),),
                    SizedBox(height: 10.0,),
                    Text(widget.workerdata!['Contact_No'],style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                  ],
                ),),

                Expanded(
                  flex: 4,
                  child:
                    Column(

                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green[500],
                          radius: 80.0,
                          foregroundImage: NetworkImage(widget.workerdata!['photoURL']),

                        )
                      ],
                    )
                  ,
                )
              ],
            ),
            Text('Looking for work  :',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
            SizedBox(height: 10.0),
            getTextWidgets(widget.workerdata!['works']),
            SizedBox(height: 30.0,),
            Text("About",style: TextStyle(fontSize: 15.0,color: Colors.brown),),
            Text(
              widget.workerdata!['Summery'],
              style: TextStyle(color: Colors.green[800],fontSize: 15.0),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>messenger(reciver: widget.workerdata,)),
                  );
                },icon: Icon(Icons.messenger),label: Text("Message"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.  green[500])
                  ),),
                ElevatedButton.icon(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>requests()),
                  );
                },icon: Icon(Icons.assignment_turned_in),label: Text("Request  "),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.brown)
                  ),)
              ],
            )

          ],
        ),
      ),
    );
  }
}
