import 'package:flutter/material.dart';
import 'package:sem/services/Authenticate.dart';
import 'package:sem/userwidgets/allrequests.dart';
import 'package:sem/userwidgets/chatlist.dart';
import 'package:sem/userwidgets/searchworkers.dart';
import 'package:sem/userwidgets/useraccount.dart';
import 'package:sem/workingwidgets/locationfinder.dart';
import 'package:sem/workingwidgets/workrequests.dart';
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
    useraccount(),

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
          child:_options.elementAt(_selected)
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        currentIndex:_selected ,
        onTap: _ontapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            backgroundColor: Colors.lightGreen,
            label: "Home",



          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            backgroundColor: Colors.lightGreen,
            label: "Messages",

          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Requests",
            backgroundColor: Colors.lightGreen,

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.lightGreen,

          )
        ],
      ),
    );

  }
}
