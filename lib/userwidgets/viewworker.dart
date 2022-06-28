import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sem/userwidgets/chatbox.dart';
import 'package:sem/userwidgets/requests.dart';
import 'package:sem/userwidgets/viewgallery.dart';
import 'package:sem/userwidgets/viewprevious.dart';
import 'package:sem/workingwidgets/workeraccount.dart';
import 'package:collection/collection.dart';

import '../screens/Loadings/loadingscreenfadingcube.dart';
import '../services/workrequests.dart';

class viewworker extends StatefulWidget {
  final workerdata, toggler;
  const viewworker({Key? key, this.workerdata, this.toggler}) : super(key: key);

  @override
  _viewworkerState createState() => _viewworkerState();
}

class _viewworkerState extends State<viewworker> {
  @override
  Widget getTextWidgets(List<dynamic> works) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: works
            .map((item) => new Text(
                  item,
                  style: TextStyle(fontSize: 15.0, color: Colors.green),
                ))
            .toList());
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50))),
              child: Row(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.toggler();
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Back ",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
              padding: EdgeInsets.all(10),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.workerdata!['Username'],
                          style: TextStyle(fontSize: 25.0, color: Colors.brown),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => viewgallery(
                                            id: widget.workerdata['uid'],
                                          )));
                            },
                            icon: Icon(Icons.camera_alt))
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: (widget.workerdata!['ratecount'] > 0
                              ? widget.workerdata!['Rating'] /
                                  widget.workerdata!['ratecount']
                              : 0),
                          itemSize: 20.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        (widget.workerdata['ratecount'] > 100)
                            ? Text(
                                '(100+)',
                                style: TextStyle(fontSize: 15.0),
                              )
                            : Text(
                                '(${widget.workerdata['ratecount']})',
                                style: TextStyle(fontSize: 15.0),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.workerdata!['Email'],
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.green[800]),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                widget.workerdata!['Contact_No'],
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[500],
                                radius: 80.0,
                                foregroundImage: NetworkImage(
                                    widget.workerdata!['photoURL']),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      "About",
                      style: TextStyle(fontSize: 15.0, color: Colors.brown),
                    ),
                    Text(
                      widget.workerdata!['Summery'],
                      style:
                          TextStyle(color: Colors.green[800], fontSize: 15.0),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => messenger(
                                          reciver: widget.workerdata.data()
                                              as Map<String, dynamic>,
                                        )),
                              );
                            },
                            icon: Icon(Icons.messenger),
                            label: Text("Message"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.all(10)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => requests(
                                        reciever: widget.workerdata,
                                      )),
                            );
                          },
                          icon: Icon(Icons.assignment_turned_in),
                          label: Text("Request"),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              padding: EdgeInsets.all(10)),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('requests')
                          .where('Contractor',
                              isEqualTo: _auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List objects = [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadfadingcube();
                        } else {
                          if (snapshot.data?.docs != null) {
                            for (var i in snapshot.data!.docs) {
                              if (i.get('Reciever') ==
                                  widget.workerdata['uid']) {
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          objects[i]['title'],
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Colors
                                                                  .green[500]),
                                                        ),
                                                        (objects[i]
                                                                ['completed'])
                                                            ? Text(
                                                                'Status : Completed',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green),
                                                              )
                                                            : (objects[i][
                                                                    'accepted'])
                                                                ? Text(
                                                                    'Status : Ongoing',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .yellow))
                                                                : Text(
                                                                    'Status : Not Accepted yet',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                        Text(objects[i]
                                                            ['address']),
                                                        Text(
                                                            '${objects[i]['payment']}'),
                                                      ],
                                                    ),
                                                  ),
                                                  (!objects[i]['completed'] &&
                                                          !objects[i]
                                                              ['accepted']
                                                      ? Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child:
                                                              TextButton.icon(
                                                            onPressed:
                                                                () async {
                                                              final d1 = WorkRequests(
                                                                  Reciever:
                                                                      objects[i]
                                                                          [
                                                                          'Reciever'],
                                                                  Contractor:
                                                                      objects[i]
                                                                          [
                                                                          'Contractor']);
                                                              await d1
                                                                  .deleterecord(
                                                                      objects[
                                                                          i]);
                                                            },
                                                            icon: Icon(
                                                              Icons.cancel,
                                                              size: 30.0,
                                                              color: Colors.red,
                                                            ),
                                                            label: Text(""),
                                                          ),
                                                        )
                                                      : (objects[i]
                                                              ['completed'])
                                                          ? Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: TextButton
                                                                  .icon(
                                                                onPressed:
                                                                    () async {},
                                                                icon: Icon(
                                                                  Icons
                                                                      .assignment_turned_in,
                                                                  size: 30.0,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                label: Text(""),
                                                              ),
                                                            )
                                                          : Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Icon(
                                                                Icons
                                                                    .airport_shuttle,
                                                                size: 30.0,
                                                                color: Colors
                                                                    .yellow,
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
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.brown),
                                    ),
                                    alignment: Alignment.center,
                                  ));
                            }
                          } else {
                            return Container();
                          }
                        }
                      })),
            )
          ],
        ),
      ),
    ));
  }
}
