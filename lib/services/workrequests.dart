import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class WorkRequests {
  String? Contractor, Reciever;

  WorkRequests({this.Contractor, this.Reciever});

  final CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  final CollectionReference userdata =
      FirebaseFirestore.instance.collection('userdata');

  Future sendrequests(String name, String Address, double payment,
      String phoneno, LatLng location, String title, String date) async {
    await requests.add({
      'title': title,
      'Contractor': Contractor,
      'Reciever': Reciever,
      'Name': name,
      'address': Address,
      'payment': payment,
      'Contact_no': phoneno,
      'completed': false,
      'accepted': false,
      'lat': location.latitude,
      'long': location.longitude,
      'rating': -1,
      'date': date,
      'galleryrequest': false,
      'reported': false,
    });
  }

  Future<bool> checkongoing() async {
    QuerySnapshot doc = await requests
        .where('Contractor', isEqualTo: Contractor)
        .where('Reciever', isEqualTo: Reciever)
        .get();
    if (doc.docs != null) {
      for (var j in doc.docs) {
        if (j['Contractor'] == Contractor &&
            j['Reciever'] == Reciever &&
            j['completed'] == false) {
          return true;
        }
      }
    }
    return false;
  }

  Future deleterecord(var id) async {
    await requests.doc(id.id).delete();
  }

  Future updaterating(double r, String id) async {
    await requests.doc(id).update({'rating': r});

    await userdata.doc(Reciever).update({
      'Rating': FieldValue.increment(r),
      'ratecount': FieldValue.increment(1)
    });
  }

  Future acceptrequest(String id) async {
    await requests.doc(id).update({'accepted': true});
  }

  Future gettodayrequests() async {
    QuerySnapshot x =
        await requests.where('Contractor', isEqualTo: Contractor).get();
    List data = [];
    if (x.docs != null) {
      for (DocumentSnapshot i in x.docs) {
        if (i.get('date') == DateFormat('yyyy-MM-dd').format(DateTime.now()) &&
            i.get('accepted')) {
          data.add(i);
        }
      }
    }
    return data;
  }

  Future markascompleted(String id) async {
    await requests.doc(id).update({'completed': true});
  }
}
