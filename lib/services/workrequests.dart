import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';


class WorkRequests {
  String ? Contractor, Reciever;

  WorkRequests({this.Contractor, this.Reciever});

  final CollectionReference requests = FirebaseFirestore.instance.collection('requests');
  final CollectionReference userdata =FirebaseFirestore.instance.collection('userdata');

  Future sendrequests(String name, String Address, double payment,
      String phoneno, LatLng location,String title,String date) async {
      DocumentSnapshot s1=await requests.doc(Contractor).get();
      if(!s1.exists){
        await requests.doc(Contractor).set({'requests':[

                {

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
                  'rating':-1,
                  'date':date

                }
              ]

        }

          );
      }else{
        await requests.doc(Contractor).update({'requests':FieldValue.arrayUnion([
              {

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
                'rating':-1,
                'date':date


              }
            ]
            )

        }

        );

      }
      s1=await requests.doc(Reciever).get();
      if(!s1.exists){
        await requests.doc(Reciever).set({'requests':[

          {

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
            'rating':-1,
            'date':date

          }
        ]

        }

        );
      }else{
        await requests.doc(Reciever).update({'requests':FieldValue.arrayUnion([
          {

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
            'rating':-1,
            'date':date

          }
        ]
        )

        }

        );
      }


  }

  Future<bool> checkongoing() async {
    DocumentSnapshot doc = await requests.doc(Contractor).get();
    if (doc.exists) {
      for (var j in doc.get('requests')) {
          if (j['Contractor'] == Contractor && j['Reciever'] == Reciever &&
              j['completed'] == false) {
            return true;

        }

      }

    }
    return false;
  }

  Future deleterecord(var e)async{
    var s1 = await requests.doc(Reciever).get();
    List obj = s1.get('requests');
    for(var i in obj){
      if(mapEquals(i, e)){
        obj.remove(i);
        break;
      }
    }
    await requests.doc(Reciever).update({'requests':obj});
    s1 =await requests.doc(Contractor).get();
    obj=s1.get('requests');
    for(var i in obj){
      if(mapEquals(i, e)){
        obj.remove(i);
        break;
      }
    }
    await requests.doc(Contractor).update({
      'requests':obj
    });

  }
  Future updaterating(var e,double r)async{
    var s1 = await requests.doc(Contractor).get();
    List obj = s1.get('requests');
    for(int i=0;i<obj.length;i++){
      if(mapEquals(obj[i], e)){
        obj[i]['rating']=r;
        break;
      }
    }
    await requests.doc(Contractor).update({'requests':obj});
    await userdata.doc(Reciever).update({
      'Rating':FieldValue.increment(r),
      'ratecount':FieldValue.increment(1)
    });
    s1=await requests.doc(Reciever).get();
    obj = s1.get('requests');
    for(int i=0;i<obj.length;i++){
      if(mapEquals(obj[i], e)){
        obj[i]['rating']=r;
        break;
      }
    }
    await requests.doc(Reciever).update({'requests':obj});

  }
  Future acceptrequest(var e)async{
    var s1 = await requests.doc(Contractor).get();
    List obj = s1.get('requests');
    for(int i=0;i<obj.length;i++){
      if(mapEquals(obj[i], e)){
        obj[i]['accepted']=true;
        break;
      }
    }
    await requests.doc(Contractor).update({'requests':obj});
    s1=await requests.doc(Reciever).get();
    obj = s1.get('requests');
    for(int i=0;i<obj.length;i++){
      if(mapEquals(obj[i], e)){
        obj[i]['accepted']=true;
        break;
      }
    }
    await requests.doc(Reciever).update({'requests':obj});

  }

  Future gettodayrequests()async{
    var x = await requests.doc(Contractor).get();
    List data=[];
   if(x.data()!=null){
     for(var i in x.get('requests')){
       if(i['date']==DateFormat('yyyy-MM-dd').format(DateTime.now())){
         data.add(i);
       }
     }
   }
    return data;
  }


}