import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/services/Authenticate.dart';
import 'package:sem/userwidgets/allrequests.dart';
import 'package:sem/userwidgets/chatlist.dart';
import 'package:sem/userwidgets/searchworkers.dart';
import 'package:sem/userwidgets/useraccount.dart';
import 'package:sem/workingwidgets/locationfinder.dart';
import 'package:sem/workingwidgets/workrequests.dart';
import 'package:sem/wrappers/wrapperprofile.dart';

import '../../services/notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authservice _auth = Authservice();
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selected = 0;
  static const List<Widget> _options = <Widget>[
    searchworkers(),
    chatlist(),
    allrequests(),
    useraccount(),
  ];
  void _ontapped(int index) {
    setState(() {
      _selected = index;
    });
  }

  void snapshotstream() async {
    Stream details = FirebaseFirestore.instance
        .collection('gallery')
        .where('Reciever', isEqualTo: auth.currentUser!.uid)
        .where('accepted', isEqualTo: false)
        .snapshots();
    StreamSubscription sub = details.distinct().listen((event) {
      bool notificationshave = false;
      if (event.docChanges.length > 0) {
        NotificationService.shownotification(
            title: 'Notify Me',
            body:
                'You have New Gallery Requests check them in Notification Section',
            payload: 'Notifications');
      }
    });
    auth.authStateChanges().listen((user) {
      if (user == null) {
        sub.cancel();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService.init();
    snapshotstream();
  }

  @override
  Widget build(BuildContext context) {
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
