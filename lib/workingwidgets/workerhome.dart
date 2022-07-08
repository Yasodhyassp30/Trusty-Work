import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/workingwidgets/notifications.dart';
import 'package:intl/intl.dart';
import 'package:sem/workingwidgets/postsworker.dart';
import 'package:sem/workingwidgets/scheduler.dart';

import 'locationfinder.dart';

class workerhome extends StatefulWidget {
  final toggler;
  const workerhome({Key? key, this.toggler}) : super(key: key);

  @override
  _workerhomeState createState() => _workerhomeState();
}

class _workerhomeState extends State<workerhome> {
  List<DocumentSnapshot?> workers = [];
  bool searched = false;
  int total = 0;
  final DatabaseService d1 = DatabaseService();
  TextEditingController key = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool post = false;
  List menuitems = [
    ['Requests', 'Calender']
  ];
  bool calender = false;
  void toggle() {
    calender = !calender;
    setState(() {});
  }

  void togglepost() {
    post = !post;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);
    String? pic = currentuser?.PicUrl;
    List today = [];
    String? username = currentuser?.username;
    if (calender) {
      return calenderwork(
        toggler: toggle,
      );
    }
    if (post) {
      return postworkers(
        toggler: togglepost,
      );
    }
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
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(50))),
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
                              Text(
                                _auth.currentUser!.displayName!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.21,
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: menuitems.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/${menuitems[index][0]}.jpg'),
                                                    fit: BoxFit.cover)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: Text(
                                                "${total}",
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.end,
                                              ),
                                            )),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
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
                                                    menuitems[index][0],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        widget.toggler(2);
                                                      },
                                                      icon: Icon(
                                                          Icons.list_alt_sharp))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10)),
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/${menuitems[index][1]}.jpg'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
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
                                                    menuitems[index][1],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          calender = true;
                                                        });
                                                      },
                                                      icon: Icon(
                                                          Icons.calendar_today))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        })),
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: AssetImage('assets/posts.png'),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Public Orders',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    post = true;
                                  });
                                },
                                icon: Icon(Icons.post_add_sharp))
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: AssetImage('assets/today.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today Requests',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.timer)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 21, right: 21, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 21, right: 20),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('requests')
                          .where('Reciever', isEqualTo: _auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, todayrequests) {
                        if (todayrequests.connectionState !=
                            ConnectionState.waiting) {
                          today = [];
                          for (DocumentSnapshot i in todayrequests.data!.docs) {
                            if (i.get('date') ==
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now()) &&
                                i.get('accepted')) {
                              today.add(i);
                            }
                            if (!i.get('completed')) {
                              total += 1;
                            }
                          }
                        }
                        if (today.length > 0) {
                          return ListView.builder(
                              itemCount: today.length,
                              itemBuilder: (context, k) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.assignment),
                                          Text(
                                            "  " + today[k]['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(child: SizedBox()),
                                          (today[k]['completed'])
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Colors.green),
                                                  icon: Icon(Icons.timer),
                                                  onPressed: () {
                                                    Map directions = {
                                                      'lat': today[k]['lat'],
                                                      'long': today[k]['long']
                                                    };
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                locationfind(
                                                                  locationdetails:
                                                                      directions,
                                                                )));
                                                  },
                                                  label: Text("Start"),
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.payment),
                                          Text("   Payment  : " +
                                              today[k]['payment'].toString()),
                                          Expanded(child: SizedBox()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.person),
                                          Text("   Name  : " +
                                              today[k]['Name'].toString()),
                                          Expanded(child: SizedBox()),
                                        ],
                                      ),
                                      Divider(
                                        height: 5,
                                        thickness: 2,
                                        color: Colors.black26,
                                      )
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return Center(child: Text("No Requests for today"));
                        }
                      }),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
