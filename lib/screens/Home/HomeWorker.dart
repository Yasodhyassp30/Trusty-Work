import 'package:flutter/material.dart';
import 'package:sem/workingwidgets/workeraccount.dart';
import 'package:sem/workingwidgets/workerhome.dart';
import 'package:sem/workingwidgets/workrequests.dart';

import '../../services/Authenticate.dart';
import '../../userwidgets/allrequests.dart';
import '../../userwidgets/chatlist.dart';
import '../../userwidgets/searchworkers.dart';
import '../../wrappers/wrapperprofile.dart';

class homeworker extends StatefulWidget {
  const homeworker({Key? key}) : super(key: key);

  @override
  _homeworkerState createState() => _homeworkerState();
}

class _homeworkerState extends State<homeworker> {
  final Authservice _auth = Authservice();
  int _selected = 0;

  void _ontapped(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _options = <Widget>[
      workerhome(
        toggler: _ontapped,
      ),
      chatlist(),
      workrequests(),
      workeraccount(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(child: _options.elementAt(_selected)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        currentIndex: _selected,
        onTap: _ontapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
            backgroundColor: Colors.lightGreen,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: "Messages",
            backgroundColor: Colors.lightGreen,
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
