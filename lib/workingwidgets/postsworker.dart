import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class postworkers extends StatefulWidget {
  final toggler;
  const postworkers({Key? key, this.toggler}) : super(key: key);

  @override
  State<postworkers> createState() => _postworkersState();
}

class _postworkersState extends State<postworkers> {
  List posts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      widget.toggler();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Back',
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('completed', isNotEqualTo: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting &&
                        snapshot.data != null) {
                      posts = snapshot.data!.docs;
                    }
                    return Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: (posts.length > 0)
                              ? (ListView.builder(
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    foregroundImage:
                                                        NetworkImage(
                                                            posts[index].get(
                                                                'imageurl')),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${posts[index].get('name')}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Looking For ${posts[index].get('looking')}',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${DateFormat('dd MMMM yyyy').format(DateTime.parse(posts[index].get('date').toDate().toString()))}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'Images : ${posts[index].get('URL').length}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black26)),
                                              Divider(
                                                height: 3,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                  '${posts[index].get('text')}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black38)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 200,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: posts[index]
                                                        .get('URL')
                                                        .length,
                                                    itemBuilder: (context, k) {
                                                      return Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          height: 200,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                          child: GestureDetector(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                child: Image
                                                                    .network(
                                                                  posts[index].get(
                                                                      'URL')[k],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              onTap: () => showDialog(
                                                                  context: context,
                                                                  builder: (context) => AlertDialog(
                                                                          actions: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                    child: ElevatedButton(
                                                                                  child: Text("Close"),
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ))
                                                                              ],
                                                                            )
                                                                          ],
                                                                          content: Container(
                                                                            height:
                                                                                MediaQuery.of(context).size.height * 0.7,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.9,
                                                                            child:
                                                                                InteractiveViewer(
                                                                              child: Image.network(
                                                                                posts[index].get('URL')[k],
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            ),
                                                                          )))));
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      if (!posts[index]
                                                          .get('interest')
                                                          .contains(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('posts')
                                                            .doc(
                                                                posts[index].id)
                                                            .update({
                                                          'interest': FieldValue
                                                              .arrayUnion([
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                          ])
                                                        });
                                                      } else {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('posts')
                                                            .doc(
                                                                posts[index].id)
                                                            .update({
                                                          'interest': FieldValue
                                                              .arrayRemove([
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                          ])
                                                        });
                                                      }
                                                    },
                                                    child: (!posts[index]
                                                            .get('interest')
                                                            .contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid))
                                                        ? Text(
                                                            "Send You Interested")
                                                        : Text("Interested"),
                                                    style: ElevatedButton.styleFrom(
                                                        primary: (!posts[index]
                                                                .get('interest')
                                                                .contains(
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid))
                                                            ? Colors.lightGreen
                                                            : Colors.lightGreen[
                                                                800]),
                                                  )
                                                ],
                                              )
                                            ]),
                                      ),
                                    );
                                  }))
                              : Container(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.grey[200]),
                                      child: Center(
                                        child: Text(
                                          'No Posts',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      )),
                                ),
                        ));
                  }))),
        ]),
      )),
    );
  }
}
