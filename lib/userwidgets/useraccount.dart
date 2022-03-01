import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sem/services/storage.dart';
import 'dart:io';



class useraccount extends StatefulWidget {
  const useraccount({Key? key}) : super(key: key);

  @override
  _useraccountState createState() => _useraccountState();
}

class _useraccountState extends State<useraccount> {


  String ? username,email,pic;

  @override

  Widget build(BuildContext context) {


    final currentuser =Provider.of<myUser?>(context);
    final Imagepic =ImagePicker();
      username=currentuser?.username;
      email=currentuser?.Email;
      pic=currentuser?.PicUrl;
      final datastore d1 = datastore();
      FirebaseAuth _auth=FirebaseAuth.instance;
      File name;



    return Scaffold(
      body: SafeArea(
      child:
         SingleChildScrollView(
           child:  Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Row(
                 children: [

                   SizedBox(height: 5.0,),
                   Text("User Profile ",style: TextStyle(fontSize: 25.0,color: Colors.green[900]),),
                   Expanded(child:SizedBox()),
                   IconButton(
                     icon: Icon(Icons.exit_to_app_outlined,size: 30,color: Colors.brown,),
                     onPressed:()async{
                       await _auth.signOut();
                     },)

                 ],
               ),
               SizedBox(height: 20.0,),
               Container(
                 padding: EdgeInsets.all(10.0),

                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                     color: Colors.grey[200],
                     borderRadius: BorderRadius.circular(15.0)
                 ),
                 child:Column(
                   children: [
                     SizedBox(height: 10,),
                     GestureDetector(
                       onTap: ()async{
                         final picked =await Imagepic.pickImage(source: ImageSource.camera);
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
                           backgroundImage: AssetImage('assets/avatar.png'),
                           foregroundImage: pic!=null ? NetworkImage(pic!):null,

                         ),

                       ),
                     ),

                     Text("$username",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.brown),),
                     SizedBox(height: 10.0,),
                     Text("$email"),
                     SizedBox(height: 30.0,),

                     Container(
                       width: MediaQuery.of(context).size.width,
                       child:ElevatedButton(
                           style: ElevatedButton.styleFrom(primary: Colors.green[500]),
                           onPressed: (){}, child:Text("Change Details")) ,
                     ),

                     Container(
                       width: MediaQuery.of(context).size.width,
                       child:ElevatedButton(
                           style: ElevatedButton.styleFrom(primary: Colors.brown),
                           onPressed: (){}, child:Text("Delete Account")
                       ) ,
                     ),


                   ],
                 ) ,
               )



             ],
           )
           ,
         )

      )
    );
  }
}
