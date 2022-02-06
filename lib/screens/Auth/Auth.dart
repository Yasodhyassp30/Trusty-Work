import 'package:flutter/material.dart';
import 'package:sem/screens/Auth/signin.dart';
import 'package:sem/screens/Auth/signup.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showreg=false;
  void toggleview(){
    setState(()=>showreg=!showreg
    );
  }
  @override
  Widget build(BuildContext context) {
    if(showreg){
      return Container(child:signup(toggleview:toggleview));
    }else{
      return Container(child:SignIN(toggleview:toggleview));
    }

  }
}
