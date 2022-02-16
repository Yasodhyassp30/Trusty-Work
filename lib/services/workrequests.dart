import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkRequests {
  String ? Contractor, Reciever;

  WorkRequests({this.Contractor, this.Reciever});

  final CollectionReference requests = FirebaseFirestore.instance.collection(
      'requests');

  Future sendrequests(String name, String Address, double payment,
      String phoneno, LatLng location,String title) async {
      DocumentSnapshot s1=await requests.doc(Contractor).get();
      if(!s1.exists){
        await requests.doc(Contractor).set({
          'Purpose':'messages'
        });
      }
      DocumentReference ref =await requests.doc(Contractor).collection('$Reciever').add({

          'title':title,
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

      });

      DocumentSnapshot s2=await requests.doc(Reciever).get();
      if(!s2.exists){
        await requests.doc(Reciever).set({
          'Purpose':'messages'
        });

      }
      await requests.doc(Reciever).collection('$Contractor').doc(ref.id).set({


        'title':title,
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


      });


  }



  Future<bool> checkongoing() async {
    QuerySnapshot doc = await requests.doc(Contractor).collection('$Reciever').get();
    if (doc.docs.isNotEmpty) {
      for (var j in doc.docs) {
          if (j['Contractor'] == Contractor && j['Reciever'] == Reciever &&
              j['completed'] == false) {
            return true;

        }

      }

    }
    return false;
  }
  Future deleterecord(String docid,var e)async{
    await requests.doc(Reciever).collection('$Contractor').doc(docid).delete();
    return await requests.doc(Contractor).collection("$Reciever").doc(docid).delete();

  }

  Future getpreviousindi(String uid)async{
    DocumentSnapshot doc = await requests.doc(Contractor).get();
    List objects=[];
    if(doc.data()!=null){
      for(var  i in doc.get('requests')){
        if(i['Reciever']==uid){
          objects.add(i);
        }
      }
    }
    return objects;
  }
}