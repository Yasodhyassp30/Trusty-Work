import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/services/workrequests.dart';
import 'package:sem/userwidgets/dashboardtodayrequests.dart';
import 'package:sem/userwidgets/postsuser.dart';
import 'package:sem/userwidgets/searchlist.dart';
import 'package:sem/userwidgets/viewworker.dart';
import 'package:sem/workingwidgets/notifications.dart';

class searchworkers extends StatefulWidget {
  const searchworkers({Key? key}) : super(key: key);

  @override
  _searchworkersState createState() => _searchworkersState();
}

class _searchworkersState extends State<searchworkers> {
  String? Keyword;
  List worktypes = [
    'Mechanic',
    'Plumber',
    'Gardener',
    'Electrician',
    'Cleaner',
    'Painter'
  ];

  List<DocumentSnapshot?> workers = [];
  bool searched = false;
  final DatabaseService d1 = DatabaseService();

  FirebaseAuth _auth = FirebaseAuth.instance;
  List todayservices = [];
  QuerySnapshot? dataworkers;

  getdayrequests() async {
    WorkRequests worktoday = WorkRequests(Contractor: _auth.currentUser!.uid);
    todayservices = await worktoday.gettodayrequests();
  }

  void toggler() {
    setState(() {
      searched = !searched;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getdayrequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);
    String? pic = currentuser?.PicUrl;
    String? username = currentuser?.username;
    FirebaseAuth _auth = FirebaseAuth.instance;

    TextEditingController key = TextEditingController();
    if (username != null) {
      if (searched) {
        return searchedlist(
          sreachedlist: dataworkers,
          togglerfunction: toggler,
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.lightGreen[400],
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome !",
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                  Text(username,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('gallery')
                                    .where('Reciever',
                                        isEqualTo: _auth.currentUser!.uid)
                                    .where('accepted', isEqualTo: false)
                                    .snapshots(),
                                builder: (context, notifications) {
                                  if (notifications.data != null &&
                                      notifications.connectionState !=
                                          ConnectionState.waiting) {
                                    return IconButton(
                                        onPressed: () {
                                          print(notifications.data!.docs);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      notificationlist()));
                                        },
                                        icon: Icon(
                                          (notifications.data != null &&
                                                  notifications
                                                          .data!.docs.length !=
                                                      0)
                                              ? Icons.notifications_active
                                              : Icons.notifications,
                                          size: 30,
                                          color: Colors.white,
                                        ));
                                  } else {
                                    return Container(
                                      child: Text('No new requests'),
                                    );
                                  }
                                }),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  TextField(
                                    controller: key,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide:
                                              BorderSide(color: Colors.green)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                      ),
                                      hintText: 'Search of Workers',
                                      hintStyle: TextStyle(color: Colors.brown),
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.search_rounded,
                                              color: Colors.brown),
                                          onPressed: () async {
                                            dataworkers = await d1.FindWorkers(
                                                key.text.toLowerCase());

                                            if (mounted) {
                                              setState(() {
                                                searched = true;
                                                Keyword = key.text;
                                              });
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upcoming Services",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      (todayservices.length > 0)
                                          ? Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    todayservices[0]['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.brown),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                ),
                                                Container(
                                                  child: Text(
                                                    todayservices[0]['Name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.brown),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                ),
                                                Container(
                                                  child: Text(
                                                    todayservices[0]['date'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.brown),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                ),
                                              ],
                                            )
                                          : Container(
                                              child: Text(
                                                "No Upcoming Service Requests",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black26),
                                              ),
                                            )
                                    ],
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: Colors.brown),
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                expandedtodayrequests(
                                                  requests: todayservices,
                                                )),
                                      );
                                    },
                                    color: Colors.green[500],
                                    icon: Icon(
                                      Icons.assignment,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width - 20,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.lightGreen[200],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Public Offers",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        child: Text(
                                          "Post/View Your Public Requests",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black26),
                                        ),
                                      )
                                    ],
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: Colors.brown),
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => posts()),
                                      );
                                    },
                                    color: Colors.green[500],
                                    icon: Icon(
                                      Icons.post_add,
                                      size: 30,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Quick Find",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black26),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            itemCount: worktypes.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10)),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/${worktypes[index]}.jpg'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    worktypes[index],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Container(
                                                  child: ElevatedButton(
                                                onPressed: () async {
                                                  dataworkers =
                                                      await d1.FindWorkers(
                                                          worktypes[index]
                                                              .toString()
                                                              .toLowerCase());
                                                  setState(() {
                                                    searched = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                ),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Colors.lightGreen,
                                                      Colors.lightGreen.shade200
                                                    ]),
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    constraints:
                                                        const BoxConstraints(
                                                            minWidth: 88.0,
                                                            minHeight: 36.0),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      'View all',
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    )
                                  ],
                                ),
                              );
                            })),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      return loadfadingcube();
    }
  }
}
