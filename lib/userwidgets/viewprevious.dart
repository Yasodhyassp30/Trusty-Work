import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/workrequests.dart';

class requestforindividual extends StatefulWidget {
  final uid;
  const requestforindividual({Key? key, this.uid}) : super(key: key);

  @override
  _requestforindividualState createState() => _requestforindividualState();
}

class _requestforindividualState extends State<requestforindividual> {
  @override
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('Contractor', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          List objects = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
          } else {
            if (snapshot.data?.docs != null) {
              for (var i in snapshot.data!.docs) {
                if (i.get('Reciever') == widget.uid) {
                  objects.add(i);
                }
              }
              objects = objects.reversed.toList();

              if (objects.length > 0) {
                return Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                        child: ListView.builder(
                            itemCount: objects.length,
                            itemBuilder: (context, i) {
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
                                            objects[i]['title'],
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.green[500]),
                                          ),
                                          (objects[i]['completed'])
                                              ? Text(
                                                  'Status : Completed',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )
                                              : (objects[i]['accepted'])
                                                  ? Text('Status : Ongoing',
                                                      style: TextStyle(
                                                          color: Colors.yellow))
                                                  : Text(
                                                      'Status : Not Accepted yet',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                          Text(objects[i]['address']),
                                          Text('${objects[i]['payment']}'),
                                        ],
                                      ),
                                    ),
                                    (!objects[i]['completed'] &&
                                            !objects[i]['accepted']
                                        ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                final d1 = WorkRequests(
                                                    Reciever: objects[i]
                                                        ['Reciever'],
                                                    Contractor: objects[i]
                                                        ['Contractor']);
                                                await d1
                                                    .deleterecord(objects[i]);
                                              },
                                              icon: Icon(
                                                Icons.cancel,
                                                size: 30.0,
                                                color: Colors.red,
                                              ),
                                              label: Text(""),
                                            ),
                                          )
                                        : (objects[i]['completed'])
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton.icon(
                                                  onPressed: () async {},
                                                  icon: Icon(
                                                    Icons.assignment_turned_in,
                                                    size: 30.0,
                                                    color: Colors.green,
                                                  ),
                                                  label: Text(""),
                                                ),
                                              )
                                            : Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                  Icons.airport_shuttle,
                                                  size: 30.0,
                                                  color: Colors.yellow,
                                                ),
                                              )),
                                  ],
                                ),
                              ));
                            })));
              } else {
                return Container(
                    height: 300.0,
                    child: Align(
                      child: Text(
                        'No Previous Requests',
                        style: TextStyle(fontSize: 25.0, color: Colors.brown),
                      ),
                      alignment: Alignment.center,
                    ));
              }
            } else {
              return Container();
            }
          }
        });
  }
}
