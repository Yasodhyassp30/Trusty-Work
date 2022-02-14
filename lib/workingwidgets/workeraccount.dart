import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/services/storage.dart';
import 'dart:io';

class workeraccount extends StatefulWidget {
  const workeraccount({Key? key}) : super(key: key);

  @override
  _workeraccountState createState() => _workeraccountState();
}

class _workeraccountState extends State<workeraccount> {
  String ? username,email,pic;
  @override

  Widget build(BuildContext context) {
    final currentuser =Provider.of<myUser?>(context);
    final Imagepic =ImagePicker();
    username=currentuser?.username;
    email=currentuser?.Email;
    pic=currentuser?.PicUrl;
    final datastore d1 = datastore();
    File name;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(

                onTap: ()async{
                  final picked =await Imagepic.pickImage(source: ImageSource.gallery);
                  name=File(picked!.path);
                  String ? filrselected =await d1.UploadProfileImage(name);
                  setState(() {
                    pic= filrselected;
                  });


                },
                child: CircleAvatar(

                  radius: 100.0,
                  backgroundColor: Colors.green[500],
                  child:CircleAvatar(

                    radius: 90.0,
                    backgroundColor: Colors.brown,
                    foregroundImage: pic!=null ? NetworkImage(pic!):null,

                  ),

                ),
              ),

              Text("$username",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.brown),),
              SizedBox(height: 10.0,),
              Text("$email"),
              SizedBox(height: 10.0,),


            ],
          )
        ],
      ),

    );
  }
}