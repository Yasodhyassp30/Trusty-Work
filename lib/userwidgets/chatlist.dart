import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/database.dart';
import 'package:intl/intl.dart';

import 'chatbox.dart';

class chatlist extends StatefulWidget {
  const chatlist({Key? key}) : super(key: key);

  @override
  _chatlistState createState() => _chatlistState();
}

class _chatlistState extends State<chatlist> {
  String searchkey = "";
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    List<String> ids = [];
    Map<dynamic, dynamic> msgs = {};
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(_auth.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
          } else {
            msgs = {};
            ids = [];
            Map<dynamic, dynamic> detailsmsg = {};
            if (snapshot.data?.data() != null &&
                snapshot.data!.get("messages").length != 0) {
              for (Map i in snapshot.data!['messages']) {
                detailsmsg = {};
                if (i.containsKey('URL')) {
                  detailsmsg['msg'] = 'Attachment';
                } else {
                  detailsmsg['msg'] = i['message'];
                }
                detailsmsg['time'] = i['time'];
                if (ids.contains(i['with'])) {
                  msgs[i['with']] = detailsmsg;
                } else {
                  ids.add(i['with']);
                  msgs[i['with']] = detailsmsg;
                }
              }

              return Scaffold(
                  body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[400],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    Icons.message,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Messages ",
                                    style: TextStyle(
                                        fontSize: 25.0, color: Colors.white),
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextField(
                                controller: name,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.green)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide:
                                          BorderSide(color: Colors.green)),
                                  hintText: 'Search by Name',
                                  hintStyle: TextStyle(color: Colors.brown),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.brown,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    searchkey = val;
                                  });
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('userdata')
                              .where('uid', whereIn: ids)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final docs =
                                  snapshot.data!.docs.reversed.toList();
                              List result = [];

                              if (searchkey != "") {
                                docs.forEach((element) {
                                  if (element
                                      .get('Username')
                                      .toLowerCase()
                                      .contains(searchkey.toLowerCase())) {
                                    result.add(element);
                                  }
                                });
                              } else {
                                result = docs;
                              }
                              return Expanded(
                                  child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListView.builder(
                                    itemCount: result.length,
                                    itemBuilder: (context, j) {
                                      return GestureDetector(
                                          onTap: () {
                                            Map<String, dynamic> data = {};
                                            data = result[j].data()
                                                as Map<String, dynamic>;

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      messenger(
                                                        reciver: data,
                                                      )),
                                            );
                                          },
                                          child: Card(
                                              child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Expanded(
                                                          flex: 3,
                                                          child: CircleAvatar(
                                                            radius: 50.0,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/avatar.png'),
                                                            foregroundImage:
                                                                NetworkImage(
                                                                    result[j][
                                                                        'photoURL']),
                                                          )),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Expanded(
                                                          flex: 7,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                result[j][
                                                                    'Username'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                              Text(msgs[result[
                                                                      j]['uid']]
                                                                  ['msg']),
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child: Text(
                                                                  '${DateFormat('yy-MM-dd  ').add_jm().format(msgs[result[j]['uid']]['time'].toDate())}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0),
                                                                ),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  ))));
                                    }),
                              ));
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  )),
                ),
              ));
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
                          Icons.message,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Messages ",
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Conversations Found',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  )
                ],
              )));
            }
          }
        });
  }
}
