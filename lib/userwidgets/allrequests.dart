import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/database.dart';
import 'package:sem/userwidgets/viewrequests.dart';
import '../services/workrequests.dart';
import 'package:intl/intl.dart';

class allrequests extends StatefulWidget {
  const allrequests({Key? key}) : super(key: key);

  @override
  _allrequestsState createState() => _allrequestsState();
}

class _allrequestsState extends State<allrequests> {
  @override
  final _auth = FirebaseAuth.instance;
  bool all = true;
  bool onging = false;
  bool completed = false;
  bool not = false;
  bool viewdetails = false;
  void toggle() {
    setState(() {
      viewdetails = !viewdetails;
    });
  }

  var selected;

  Widget build(BuildContext context) {
    if (viewdetails) {
      return viewrequest(
        toggler: toggle,
        requestdetails: selected,
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('Contractor', isEqualTo: _auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            List objects = [];
            if (snapshot.data?.docs != null) {
              if (all) {
                objects = snapshot.data!.docs;
              } else if (onging) {
                for (var i in snapshot.data!.docs) {
                  if (i.get('accepted') && !i.get('completed')) {
                    objects.add(i);
                  }
                }
              } else if (completed) {
                for (var i in snapshot.data!.docs) {
                  if (i.get('completed')) {
                    objects.add(i);
                  }
                }
              } else if (not) {
                for (var i in snapshot.data!.docs) {
                  if (!i.get('accepted') && !i.get('completed')) {
                    objects.add(i);
                  }
                }
              }

              return Container(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[400],
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(50)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.list_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Orders ",
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        all = true;
                                        completed = false;
                                        onging = false;
                                        not = false;
                                      });
                                    },
                                    child: Text(
                                      'All',
                                      style: TextStyle(
                                          color: all
                                              ? Colors.green[900]
                                              : Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        all = false;
                                        completed = true;
                                        onging = false;
                                        not = false;
                                      });
                                    },
                                    child: Text(
                                      'Completed',
                                      style: TextStyle(
                                          color: completed
                                              ? Colors.green[900]
                                              : Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        all = false;
                                        completed = false;
                                        onging = true;
                                        not = false;
                                      });
                                    },
                                    child: Text(
                                      'Ongoing',
                                      style: TextStyle(
                                          color: onging
                                              ? Colors.green[900]
                                              : Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        all = false;
                                        completed = false;
                                        onging = false;
                                        not = true;
                                      });
                                    },
                                    child: Text(
                                      'Not Accepted',
                                      style: TextStyle(
                                          color: not
                                              ? Colors.green[900]
                                              : Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ListView.builder(
                                  itemCount: objects.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    objects[index]['title'],
                                                    style: TextStyle(
                                                        fontSize: 25.0,
                                                        color:
                                                            Colors.green[500]),
                                                  ),
                                                  (DateTime.parse(objects[index]
                                                                  ['date'])
                                                              .isBefore(DateTime
                                                                  .now()) &&
                                                          !objects[index]
                                                              ['completed'])
                                                      ? Text(
                                                          'Status : Overdue',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : (objects[index]
                                                              ['completed'])
                                                          ? Text(
                                                              'Status : Completed',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : (objects[index]
                                                                  ['accepted'])
                                                              ? Text(
                                                                  'Status : Ongoing',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .orange))
                                                              : Text(
                                                                  'Status : Not Accepted yet',
                                                                  style: TextStyle(
                                                                      color: Colors.red)),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  Text(
                                                    'Address : ${objects[index]['address']}',
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  ),
                                                  Text(
                                                    'Agreed Payment : \$ ${objects[index]['payment']}',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.brown),
                                                  ),
                                                  ((DateTime.parse(
                                                                  objects[index]
                                                                      ['date'])
                                                              .isBefore(DateTime
                                                                  .now()) &&
                                                          !objects[index]
                                                              ['completed']))
                                                      ? Text(
                                                          "Overdued Requests only be mark as completed by Contractor",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      : Text(""),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            selected =
                                                                objects[index];
                                                            viewdetails = true;
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                              "View Details"),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                              .lightGreen[
                                                                          500]))),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      (DateTime.parse(objects[index]['date'])
                                                                  .isBefore(DateTime
                                                                      .now()) &&
                                                              !objects[index]
                                                                  ['completed'])
                                                          ? ElevatedButton.icon(
                                                              icon: Icon(Icons
                                                                  .warning),
                                                              onPressed:
                                                                  (!objects[index]
                                                                          [
                                                                          'reported'])
                                                                      ? () {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                    title: Text("Report Service Provider"),
                                                                                    content: Text("Service Provider has missed your work request do you want to Report the service Provider ?"),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                          onPressed: () async {
                                                                                            await FirebaseFirestore.instance.collection('requests').doc(objects[index].id).update({
                                                                                              'reported': true
                                                                                            });
                                                                                            DocumentSnapshot workerdetails = await FirebaseFirestore.instance.collection('userdata').doc(objects[index]['Reciever']).get();

                                                                                            if (workerdetails.get('ban') == null) {
                                                                                              if (workerdetails.get('reportcount') > 20) {
                                                                                                await FirebaseFirestore.instance.collection('userdata').doc(objects[index]['Reciever']).update({
                                                                                                  'ban': {
                                                                                                    'start': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                                                    'end': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 7))),
                                                                                                  }
                                                                                                });
                                                                                              }
                                                                                              if (workerdetails.get('reportcount') > 15) {
                                                                                                await FirebaseFirestore.instance.collection('userdata').doc(objects[index]['Reciever']).update({
                                                                                                  'ban': {
                                                                                                    'start': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                                                    'end': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 5))),
                                                                                                  }
                                                                                                });
                                                                                              }
                                                                                              if (workerdetails.get('reportcount') > 10) {
                                                                                                await FirebaseFirestore.instance.collection('userdata').doc(objects[index]['Reciever']).update({
                                                                                                  'ban': {
                                                                                                    'start': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                                                    'end': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 3))),
                                                                                                  }
                                                                                                });
                                                                                              }
                                                                                            }
                                                                                            if (!workerdetails.get('reported').contains(_auth.currentUser!.uid)) {
                                                                                              await FirebaseFirestore.instance.collection('userdata').doc(objects[index]['Reciever']).update({
                                                                                                'reportcount': FieldValue.increment(1),
                                                                                                'reported': FieldValue.arrayUnion([
                                                                                                  _auth.currentUser!.uid
                                                                                                ])
                                                                                              });
                                                                                            }

                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                          child: Text('Submit'))
                                                                                    ],
                                                                                  ));
                                                                        }
                                                                      : null,
                                                              label: (!objects[index]['reported'])
                                                                  ? Text(
                                                                      "Report")
                                                                  : Text(
                                                                      "Reported"),
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(Colors.red[500])))
                                                          : Container()
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            (!objects[index]['completed'] &&
                                                    !objects[index]['accepted']
                                                ? Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: TextButton.icon(
                                                      onPressed: () async {
                                                        final d1 = WorkRequests(
                                                            Reciever: objects[
                                                                    index]
                                                                ['Reciever'],
                                                            Contractor: objects[
                                                                    index]
                                                                ['Contractor']);
                                                        await d1.deleterecord(
                                                            objects[index]);
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        size: 30.0,
                                                        color: Colors.red,
                                                      ),
                                                      label: Text(""),
                                                    ),
                                                  )
                                                : (objects[index]['completed'])
                                                    ? Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Icon(
                                                          Icons
                                                              .assignment_turned_in,
                                                          size: 30.0,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                    : Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Icon(
                                                          Icons.airport_shuttle,
                                                          size: 30.0,
                                                          color: Colors.orange,
                                                        ),
                                                      )),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                  body: SafeArea(
                child: Column(
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
                            Icons.list_alt,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Orders ",
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                all = true;
                                completed = false;
                                onging = false;
                                not = false;
                              });
                            },
                            child: Text(
                              'All',
                              style: TextStyle(
                                  color: all ? Colors.green[900] : Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                all = false;
                                completed = true;
                                onging = false;
                                not = false;
                              });
                            },
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                  color: completed
                                      ? Colors.green[900]
                                      : Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                all = false;
                                completed = false;
                                onging = true;
                                not = false;
                              });
                            },
                            child: Text(
                              'Ongoing',
                              style: TextStyle(
                                  color:
                                      onging ? Colors.green[900] : Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                all = false;
                                completed = false;
                                onging = false;
                                not = true;
                              });
                            },
                            child: Text(
                              'Not Accepted',
                              style: TextStyle(
                                  color: not ? Colors.green[900] : Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Requests Found',
                          style: TextStyle(
                            color: Colors.brown,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
            }
          });
    }
  }
}
