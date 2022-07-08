import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/services/messaging.dart';
import 'package:sem/services/storage.dart';

class messenger extends StatefulWidget {
  final Map<String, dynamic>? reciver;
  const messenger({Key? key, this.reciver}) : super(key: key);

  @override
  _messengerState createState() => _messengerState();
}

class _messengerState extends State<messenger> {
  @override
  String single = "";
  List messageslist = [];
  TextEditingController boxcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid = '';
  var con = ScrollController();

  Widget build(BuildContext context) {
    uid = _auth.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          messageslist = [];
          if (snapshot.data?.data() != null) {
            for (var i in snapshot.data!['messages']) {
              if (i['reciever'] == widget.reciver!['uid'] ||
                  i['sender'] == widget.reciver!['uid']) {
                messageslist.add(i);
              }
            }
          }

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
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
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
                      widget.reciver!['Username'],
                      style: TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: messageslist.length,
                    itemBuilder: (context, i) {
                      return Align(
                          alignment: messageslist[i]['sender'] ==
                                  _auth.currentUser!.uid
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Column(
                            children: [
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.4),
                                  child: messageslist[i]['message'] != null
                                      ? Container(
                                          child: Text(
                                            messageslist[i]['message'],
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: (messageslist[i]['sender'] ==
                                                    _auth.currentUser!.uid
                                                ? Colors.green[500]
                                                : Colors.green[900]),
                                          ),
                                          padding: EdgeInsets.all(10),
                                        )
                                      : GestureDetector(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      (messageslist[i]['URL'])),
                                                  fit: BoxFit.cover),
                                            ),
                                            padding: EdgeInsets.all(10),
                                          ),
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      actions: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                              child:
                                                                  Text("Close"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ))
                                                          ],
                                                        )
                                                      ],
                                                      content: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        child:
                                                            InteractiveViewer(
                                                          child: Image.network(
                                                            messageslist[i]
                                                                ['URL'],
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ))))),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ));
                    }),
              )),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: 25.0, right: 10.0, bottom: 10.0, top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: boxcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Message',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          hintStyle: TextStyle(color: Colors.green[500]),
                        ),
                        onTap: () {},
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          single = boxcontroller.text.trim();
                          boxcontroller.clear();
                          final picker = ImagePicker();
                          XFile? imagepicked = await picker.pickImage(
                              source: ImageSource.camera);
                          if (imagepicked != null) {
                            File Image = File(imagepicked.path);
                            datastore d1 = datastore();
                            await d1.msgimage(Image, widget.reciver!['uid'],
                                _auth.currentUser!.uid);
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 40.0,
                          color: Colors.black38,
                        )),
                    IconButton(
                        onPressed: () async {
                          single = boxcontroller.text.trim();
                          boxcontroller.clear();
                          final picker = ImagePicker();
                          XFile? imagepicked = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (imagepicked != null) {
                            File Image = File(imagepicked.path);
                            datastore d1 = datastore();
                            await d1.msgimage(Image, widget.reciver!['uid'],
                                _auth.currentUser!.uid);
                          }
                        },
                        icon: Icon(
                          Icons.attach_file,
                          size: 40.0,
                          color: Colors.black38,
                        )),
                    IconButton(
                        onPressed: () async {
                          single = boxcontroller.text.trim();
                          boxcontroller.clear();
                          if (single.length > 0) {
                            massege sender = massege(
                              reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,
                            );
                            massege reciver = massege(
                              reciever: widget.reciver!['uid'],
                              sender: _auth.currentUser!.uid,
                            );
                            await sender.senderupdate(single);
                            await reciver.Recieverupdate(single);
                            setState(() {
                              single = '';
                            });
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          size: 40.0,
                          color: Colors.green[500],
                        )),
                  ],
                ),
              ),
            ]),
          )));
        });
  }
}
