import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/screens/Home/HomeWorker.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';

import '../screens/Home/Home.dart';

class profilewrapper extends StatefulWidget {
  const profilewrapper({Key? key}) : super(key: key);

  @override
  _profilewrapperState createState() => _profilewrapperState();
}

class _profilewrapperState extends State<profilewrapper> {
  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('userdata')
            .doc(currentuser?.uid)
            .get(),
        builder: (context, documentsnapshot) {
          if (documentsnapshot.connectionState != ConnectionState.waiting) {
            if (documentsnapshot.data?.get('type') == 2) {
              return Home();
            } else {
              return homeworker();
            }
          }
          return loadfadingcube();
        });
  }
}
