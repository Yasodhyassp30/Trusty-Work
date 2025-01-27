import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/services/storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:sem/userwidgets/editprofile.dart';

class useraccount extends StatefulWidget {
  const useraccount({Key? key}) : super(key: key);

  @override
  _useraccountState createState() => _useraccountState();
}

class _useraccountState extends State<useraccount> {
  String? username, email, pic;
  bool edit = false;
  void toggle() {
    setState(() {
      edit = !edit;
    });
  }

  var selected;
  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);
    final Imagepic = ImagePicker();
    username = currentuser?.username;
    email = currentuser?.Email;
    pic = currentuser?.PicUrl;

    final datastore d1 = datastore();
    FirebaseAuth _auth = FirebaseAuth.instance;
    File name;
    if (edit) {
      return editprofile(
        user: selected,
        toggle: toggle,
      );
    }
    return Container(
        child: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightGreen[400],
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "User Profile ",
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picked = await Imagepic.pickImage(
                            source: ImageSource.gallery);
                        name = File(picked!.path);
                        String? filrselected =
                            await d1.UploadProfileImage(name);
                        setState(() {
                          pic = filrselected;
                        });
                      },
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.green[500],
                        child: CircleAvatar(
                          radius: 90.0,
                          backgroundColor: Colors.brown,
                          backgroundImage: AssetImage('assets/avatar.png'),
                          foregroundImage: pic != null
                              ? NetworkImage(pic!)
                              : NetworkImage('assets/avatar.png'),
                        ),
                      ),
                    ),
                    Text(
                      "$username",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("$email"),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[500]),
                          onPressed: () async {
                            dynamic user = await FirebaseFirestore.instance
                                .collection('userdata')
                                .doc(_auth.currentUser!.uid)
                                .get();
                            setState(() {
                              edit = true;
                              selected = user;
                            });
                          },
                          child: Text("Change Details")),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.brown),
                          onPressed: () async {
                            String error = "";
                            QuerySnapshot reqeusts = await FirebaseFirestore
                                .instance
                                .collection('requests')
                                .where('Contractor',
                                    isEqualTo: _auth.currentUser!.uid)
                                .where('completed', isEqualTo: false)
                                .get();

                            reqeusts.docs.forEach((element) {
                              if (DateTime.parse(element['date'])
                                  .isAfter(DateTime.now())) {
                                error = "You have Ongoing Requests";
                              }
                            });
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Delete account"),
                                      content: (error != "")
                                          ? Text(error)
                                          : Text(
                                              "Do you Want to Delete Your account ? "),
                                      actions: [
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            if (error != "") {
                                              Navigator.pop(context);
                                            } else {
                                              _auth.currentUser!.delete();
                                              _auth.signOut();
                                              Navigator.pop(context);
                                            }
                                          },
                                        )
                                      ],
                                    ));
                          },
                          child: Text("Delete Account")),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent),
                          onPressed: () {
                            _auth.signOut();
                          },
                          child: Text("Sign out")),
                    ),
                  ],
                ),
              ))
        ],
      ),
    )));
  }
}
