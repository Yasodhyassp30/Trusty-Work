import 'package:flutter/material.dart';
import 'package:sem/screens/Auth/Signupworker.dart';
import 'package:sem/screens/Auth/signin.dart';
import 'package:sem/screens/Auth/signup.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool showreg=false;
  bool regtowork=false;
  void toggleview(){
    setState(()=>showreg=!showreg
    );

  }
  void workusertoggle(){
    setState(()=>regtowork=!regtowork);
  }
  @override
  Widget build(BuildContext context) {
    if(showreg){
      if(regtowork){
        return Container(child:workersignup(workusertoggle:workusertoggle));
      }else{
        return Container(child:signup(toggleview:toggleview,workusertoggle:workusertoggle));
      }

    }else{
      return Container(child:SignIN(toggleview:toggleview));
    }

  }
}
