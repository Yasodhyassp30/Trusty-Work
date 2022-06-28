import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/services/storage.dart';

class galleryrequest extends StatefulWidget {
  final DocumentSnapshot? id;
  const galleryrequest({Key? key, this.id}) : super(key: key);

  @override
  State<galleryrequest> createState() => _galleryrequestState();
}

class _galleryrequestState extends State<galleryrequest> {
  List<File> files = [];
  final Imagepic = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final picked = await Imagepic.pickImage(source: ImageSource.gallery);
          files.add(File(picked!.path));
          setState(() {});
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
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
          Expanded(
              child: Container(
                  child: (files.length != 0)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: EdgeInsets.all(10),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green[300]),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Image ${index + 1}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                files.removeAt(index);
                                                setState(() {});
                                              },
                                              icon: Icon(Icons.clear))
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.file(
                                              files[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      (index == 0)
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton.icon(
                                                  onPressed: () async {
                                                    datastore d1 = datastore();
                                                    String wait = await d1
                                                        .galleryrequeststore(
                                                            files, widget.id!);
                                                    Navigator.pop(context);
                                                  },
                                                  label: Text('Send Request'),
                                                  icon: Icon(Icons.send),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          primary: Colors
                                                              .green[900]),
                                                ))
                                              ],
                                            )
                                          : Container()
                                    ],
                                  )),
                            );
                          }),
                        )
                      : Padding(
                          padding: EdgeInsets.all(15),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text("Add Images to the Gallery Request"),
                            ),
                          ),
                        ))),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          )
        ]),
      )),
    );
  }
}
