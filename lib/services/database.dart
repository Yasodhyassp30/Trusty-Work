import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userdetails =
      FirebaseFirestore.instance.collection('userdata');

  Future? updateworkerdata(String? Username, String? Phoneno, String? email,
      List<String> works, String url) async {
    return await userdetails.doc(uid).set({
      'uid': uid,
      'photoURL': url,
      'type': 1,
      'Username': Username,
      'Contact_No': Phoneno,
      'Email': email,
      'Summery': "",
      "works": works,
      "Rating": 0,
      "ratecount": 0,
      "reportcount": 0,
      'reported': [],
      "ban": null
    });
  }

  Future? updateuserdata(
      String? Username, String? Phoneno, String? email, String? url) async {
    return await userdetails.doc(uid).set({
      'uid': uid,
      'photoURL': url,
      'type': 2,
      'Username': Username,
      'Contact_No': Phoneno,
      'Email': email,
    });
  }

  Future? Getdata() async {
    DocumentSnapshot snap = await userdetails.doc(uid).get();
    var data = snap.data() as Map;
    return data;
  }

  Future? FindWorkers(String Key) async {
    QuerySnapshot data = await userdetails
        .where('type', isEqualTo: 1)
        .where('works', arrayContains: Key)
        .get();

    return data;
  }

  Future? setURL(String URL) async {
    return await userdetails.doc(uid).update({'photoURL': URL});
  }

  Future? getindivdual(String uid) async {
    return await userdetails.doc(uid).get();
  }

  Future? getdatachats(List<String> s1) async {
    var results = await userdetails.where('uid', whereIn: s1).get();

    return results.docs;
  }
}
