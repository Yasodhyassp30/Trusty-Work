import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/screens/Home/Home.dart';

class editprofile extends StatefulWidget {
  final user, toggle;
  const editprofile({Key? key, this.user, this.toggle}) : super(key: key);

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  final Imagepic = ImagePicker();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";
  FirebaseFirestore store = FirebaseFirestore.instance;
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  int index = 1;
  File? name;
  bool obsecure = true, loading = false, updated = false;
  @override
  Widget build(BuildContext context) {
    String? pic = _auth.currentUser!.photoURL;
    if (loading) {
      return Scaffold(
          body: SafeArea(
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        ),
      ));
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(245, 249, 249, 249),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Column(
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
                          widget.toggle();
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
                  height: 20,
                ),
                CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.amber,
                    foregroundImage: (pic == null)
                        ? AssetImage('assets/images/avatar.png')
                        : NetworkImage(pic) as ImageProvider),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () async {
                    final picked =
                        await Imagepic.pickImage(source: ImageSource.camera);
                    name = File(picked!.path);
                    FirebaseStorage? storage = FirebaseStorage.instance;
                    var stroeref =
                        storage.ref().child("image/${_auth.currentUser!.uid}");
                    setState(() {
                      loading = true;
                    });
                    if (name != null) {
                      var upload = await stroeref.putFile(name!);
                      String? completed = await upload.ref.getDownloadURL();
                      await _auth.currentUser!.updatePhotoURL(completed);
                      await store
                          .collection('patients')
                          .doc(_auth.currentUser!.uid)
                          .update({'pic': completed});

                      pic = completed;
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: Text('Change Profile photo'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2.0, color: Colors.amber),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Text(
                            'Personal Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: email,
                            decoration:
                                InputDecoration(hintText: widget.user['Email']),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: phone,
                            decoration: InputDecoration(
                                hintText: widget.user['Contact_No']),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: location,
                            decoration: InputDecoration(hintText: 'Location'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: password,
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              hintText: 'Old Password',
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon((obsecure)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: confirm,
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon((obsecure)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    Map<String, dynamic> newdata = new Map();
                                    if (phone.text.trim().isNotEmpty) {
                                      newdata['mobileNo'] = phone.text.trim();
                                    }
                                    if (location.text.trim().isNotEmpty) {
                                      newdata['location'] =
                                          location.text.trim();
                                    }
                                    try {
                                      await store
                                          .collection('patients')
                                          .doc(_auth.currentUser!.uid)
                                          .update(newdata);
                                      if (email.text.trim().isNotEmpty) {
                                        try {
                                          _auth.currentUser!
                                              .updateEmail(email.text.trim());
                                        } catch (e) {
                                          setState(() {
                                            error = 'Invalid Email';
                                          });
                                        }
                                        newdata['email'] = email.text.trim();
                                      }

                                      final cred = EmailAuthProvider.credential(
                                          email: _auth.currentUser!.email!,
                                          password: password.text.trim());
                                      if (confirm.text.trim().isNotEmpty) {
                                        await _auth.currentUser!
                                            .reauthenticateWithCredential(cred)
                                            .then((value) async {
                                          try {
                                            await _auth.currentUser!
                                                .updatePassword(
                                                    confirm.text.trim());
                                            updated = true;
                                          } catch (e) {
                                            setState(() {
                                              error = 'Password invalid';
                                            });
                                          }
                                        });
                                      }
                                      if (confirm.text.trim().isNotEmpty &&
                                          updated) {
                                        await _auth.signOut();
                                      }
                                    } catch (e) {
                                      setState(() {
                                        error = 'Invalid Details';
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Save',
                                    style: TextStyle(fontSize: 18),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
