import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/screens/Auth/Auth.dart';
import 'package:sem/screens/Home/Home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final currentuser =Provider.of<myUser?>(context);
    if(currentuser==null){

      return Container(
        child: Auth(),
      );
    }else if(currentuser.username!=null){

      return Container(
        child: Home(),
      );
    }else{
      return Container(
        child: Auth(),
      );
    }

  }
}
