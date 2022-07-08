import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sem/userwidgets/viewworker.dart';
import '../services/storage.dart';

class posts extends StatefulWidget {
  const posts({Key? key}) : super(key: key);

  @override
  State<posts> createState() => _postsState();
}

class _postsState extends State<posts> {
  List posts = [];
  List<String> types = [
    'Electrician',
    'Mechanic',
    'Plumber',
    'Gardener',
    'Cleaner',
    'Painter',
    'Other'
  ];
  String error = "";
  TextEditingController text = TextEditingController();
  List<File> images = [];
  String? dropdown1;
  int? selected;
  bool view = false;
  void toggler() {
    setState(() {
      view = !view;
    });
  }

  DocumentSnapshot? documentdata;

  @override
  Widget build(BuildContext context) {
    if (view) {
      return viewworker(workerdata: documentdata, toggler: toggler);
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  StatefulBuilder(builder: ((context, setState) {
                    return AlertDialog(
                      title: Text('Create Post'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView(children: [
                          Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  hint: Text(
                                    'I\'m Looking For',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  value: dropdown1,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  onChanged: (String? values) {
                                    dropdown1 = values;
                                    setState(() {});
                                  },
                                  items:
                                      types.map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: text,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Describe Request",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 18.0)),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    final picker = ImagePicker();
                                    XFile? imagepicked = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (imagepicked != null) {
                                      File Image = File(imagepicked.path);
                                      images.add(Image);
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(Icons.camera_alt)),
                              IconButton(
                                  onPressed: () async {
                                    final picker = ImagePicker();
                                    XFile? imagepicked = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (imagepicked != null) {
                                      File Image = File(imagepicked.path);
                                      images.add(Image);
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(Icons.attach_file))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ListView.builder(
                                itemCount: images.length,
                                itemBuilder: (context, j) {
                                  return Container(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.file(
                                                  images[j],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    images.removeAt(j);
                                                  });
                                                },
                                                icon: Icon(Icons.clear))
                                          ],
                                        )),
                                  );
                                }),
                          )
                        ]),
                      ),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton.icon(
                              onPressed: () async {
                                datastore d1 = datastore();
                                if (dropdown1 != null) {
                                  var wait = await d1.posts(
                                      images,
                                      FirebaseAuth.instance.currentUser!,
                                      dropdown1!,
                                      text.text.trim());
                                  images.clear();
                                  text.clear();
                                  error = "";
                                  setState(() {});
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    error = "Select a Job";
                                  });
                                }
                              },
                              label: Text('Create'),
                              icon: Icon(Icons.send),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(10),
                                  primary: Colors.lightGreen),
                            ))
                          ],
                        )
                      ],
                    );
                  })));
        },
        child: Icon(
          Icons.add,
        ),
      ),
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
                      .where('owner',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                              Text(
                                                'Looking For ${posts[index].get('looking')}',
                                                style: TextStyle(fontSize: 18),
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
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          child: Image.network(
                                                            posts[index]
                                                                .get('URL')[k],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              (index == selected)
                                                  ? Container(
                                                      height: 200,
                                                      child: (posts[index]
                                                                  .get(
                                                                      'interest')
                                                                  .length >
                                                              0)
                                                          ? ListView.builder(
                                                              itemCount: posts[
                                                                      index]
                                                                  .get(
                                                                      'interest')
                                                                  .length,
                                                              itemBuilder:
                                                                  (context, z) {
                                                                return FutureBuilder<
                                                                        DocumentSnapshot>(
                                                                    future: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'userdata')
                                                                        .doc(posts[index].get('interest')[
                                                                            z])
                                                                        .get(),
                                                                    builder:
                                                                        (context,
                                                                            workerdata) {
                                                                      if (workerdata
                                                                              .connectionState !=
                                                                          ConnectionState
                                                                              .waiting) {
                                                                        return Container(
                                                                          child:
                                                                              Row(children: [
                                                                            CircleAvatar(
                                                                              radius: MediaQuery.of(context).size.width * 0.1,
                                                                              foregroundImage: NetworkImage(workerdata.data!.get('photoURL')),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(workerdata.data!.get('Username')),
                                                                            Expanded(child: SizedBox()),
                                                                            ElevatedButton.icon(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  view = true;
                                                                                  documentdata = workerdata.data;
                                                                                });
                                                                              },
                                                                              label: Text("View"),
                                                                              icon: Icon(Icons.person),
                                                                              style: ElevatedButton.styleFrom(primary: Colors.lightGreen),
                                                                            )
                                                                          ]),
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    });
                                                              })
                                                          : Container(
                                                              child: Center(
                                                                  child: Text(
                                                                      "No Responses")),
                                                            ),
                                                    )
                                                  : Container(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: !posts[index]
                                                            .get('completed')
                                                        ? () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'posts')
                                                                .doc(
                                                                    posts[index]
                                                                        .id)
                                                                .update({
                                                              'completed': true
                                                            });
                                                          }
                                                        : null,
                                                    child: !posts[index]
                                                            .get('completed')
                                                        ? Text(
                                                            'Mark as Completed')
                                                        : Text('Completed'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (selected == null) {
                                                        setState(() {
                                                          selected = index;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          selected = null;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                        'Responses : ${posts[index].get('interest').length}'),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Colors
                                                                .lightGreen),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          )
        ]),
      )),
    );
  }
}
