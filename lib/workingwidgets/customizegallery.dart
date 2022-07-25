import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';

class customizeviewgallery extends StatefulWidget {
  const customizeviewgallery({Key? key}) : super(key: key);

  @override
  State<customizeviewgallery> createState() => _customizeviewgalleryState();
}

class _customizeviewgalleryState extends State<customizeviewgallery> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  QuerySnapshot? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('gallery')
              .where('sender', isEqualTo: _auth.currentUser!.uid)
              .where('accepted', isEqualTo: true)
              .get(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting) {
              data = snapshot.data;
              return Column(children: [
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
                          Navigator.pop(context);
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
                  height: 5,
                ),
                (data!.docs.length == 0)
                    ? (Expanded(
                        child: Center(
                          child: Text(
                            "No Gallery posts",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ))
                    : Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
                              itemCount: data!.docs.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: data!.docs[index]
                                                    .get('URL')
                                                    .length,
                                                itemBuilder: (context, i) {
                                                  return Container(
                                                    child: Row(children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            data!.docs[index]
                                                                .get('URL')
                                                                .length,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(data!
                                                                        .docs[index]
                                                                        .get(
                                                                            'URL')[i])
                                                                    as ImageProvider)),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      )
                                                    ]),
                                                  );
                                                }),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${data!.docs[index].get('title')}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Text(
                                                          'Images : ${data!.docs[index].get('URL').length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(child: SizedBox()),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                actions: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("Close")))
                                                                    ],
                                                                  )
                                                                ],
                                                                content:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.8,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.7,
                                                                  child: ListView
                                                                      .builder(
                                                                          itemCount: data!
                                                                              .docs[index]
                                                                              .get('URL')
                                                                              .length,
                                                                          itemBuilder: (context, j) {
                                                                            return Container(
                                                                              padding: EdgeInsets.all(3),
                                                                              child: InteractiveViewer(
                                                                                panEnabled: false,
                                                                                boundaryMargin: EdgeInsets.all(100),
                                                                                minScale: 1,
                                                                                maxScale: 3,
                                                                                child: Image.network(
                                                                                  data!.docs[index].get('URL')[j],
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                ),
                                                                title: Text(
                                                                    '${data!.docs[index].get('title')}'),
                                                              ));
                                                },
                                                icon: Icon(Icons.list),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.red),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('gallery')
                                                        .doc(data!
                                                            .docs[index].id)
                                                        .delete();
                                                    setState(() {});
                                                  },
                                                  child: Text('Remove'),
                                                ))
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              })),
                        ),
                      )
              ]);
            } else {
              return loadfadingcube();
            }
          },
        ),
      )),
    );
  }
}
