import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/storage.dart';
import 'dart:io';

class workeraccount extends StatefulWidget {
  const workeraccount({Key? key}) : super(key: key);

  @override
  _workeraccountState createState() => _workeraccountState();
}

class _workeraccountState extends State<workeraccount> {
  String? username, email, pic;

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
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('userdata')
            .doc(_auth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
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
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50)),
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
                                backgroundImage:
                                    AssetImage('assets/avatar.png'),
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
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.all(10),
                                child: Column(children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/rating.png'))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      'Rating :${snapshot.data!.get('ratecount') > 0 ? (snapshot.data!.get('Rating') / snapshot.data!.get('ratecount')).toStringAsFixed(2) : 0.0}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber)),
                                ]),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  thickness: 1,
                                  width: 1,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.all(10),
                                child: Column(children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/danger.png'))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      'Reports :${snapshot.data!.get('reportcount')}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ]),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green[500]),
                                onPressed: () {},
                                child: Text("Change Details")),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.brown),
                                onPressed: () {},
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
        });
  }
}
