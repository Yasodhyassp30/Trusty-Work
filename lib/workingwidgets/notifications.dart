import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class notificationlist extends StatefulWidget {
  const notificationlist({Key? key}) : super(key: key);

  @override
  State<notificationlist> createState() => _notificationlistState();
}

class _notificationlistState extends State<notificationlist> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<DocumentSnapshot> data = [];
  int? selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
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
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )),
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
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gallery')
                  .where('Reciever', isEqualTo: _auth.currentUser!.uid)
                  .where('accepted', isEqualTo: false)
                  .snapshots(),
              builder: (context, notifications) {
                if (notifications.data != null &&
                    notifications.connectionState != ConnectionState.waiting) {
                  data = notifications.data!.docs;
                }
                return Expanded(
                  child: Container(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        data[index].get('title'),
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.green),
                                      ),
                                    ),
                                    Text(
                                      'Images : ${data[index].get('URL').length}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (selected != index) {
                                              setState(() {
                                                selected = index;
                                              });
                                            } else {
                                              setState(() {
                                                selected = null;
                                              });
                                            }
                                          },
                                          child: Text('View'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.amber),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('gallery')
                                                .doc(data[index].id)
                                                .update({'accepted': true});
                                          },
                                          child: Text('Accept'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightGreen),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('gallery')
                                                .doc(data[index].id)
                                                .update({'accepted': false});
                                          },
                                          child: Text('Reject'),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    (selected != null && selected == index)
                                        ? (Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  data[index].get('URL').length,
                                              itemBuilder: ((context, i) {
                                                return Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors
                                                              .green[300]),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Image ${i + 1}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  child:
                                                                      InteractiveViewer(
                                                                    panEnabled:
                                                                        false,
                                                                    boundaryMargin:
                                                                        EdgeInsets.all(
                                                                            100),
                                                                    minScale: 1,
                                                                    maxScale: 3,
                                                                    child: Image
                                                                        .network(
                                                                      data[index]
                                                                          .get(
                                                                              'URL')[i],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              }),
                                            )))
                                        : Container()
                                  ],
                                )),
                          );
                        })),
                  ),
                );
              }),
        ]),
      )),
    );
  }
}
