import 'package:flutter/material.dart';
import 'package:sem/services/Authenticate.dart';
import 'package:sem/userwidgets/allrequests.dart';
import 'package:sem/userwidgets/chatlist.dart';
import 'package:sem/userwidgets/searchworkers.dart';
import 'package:sem/userwidgets/useraccount.dart';
import 'package:sem/wrappers/wrapperprofile.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authservice _auth=Authservice();
  int _selected=0;
  static const List<Widget> _options=<Widget>[
    searchworkers(),
    chatlist(),
    allrequests(),
    profilewrapper(),

  ];
void _ontapped(int index){
  setState(() {
    _selected=index;
  });
}
  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
          child:_options.elementAt(_selected)
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[500],
        currentIndex:_selected ,
        onTap: _ontapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: "Home",



          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: "Messages",

          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Requests",

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",

          )
        ],
      ),
    );

  }
}
