import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/screens/Auth/Auth.dart';
import 'package:sem/screens/Home/Home.dart';
import 'package:sem/screens/Wrapped.dart';
import 'package:sem/screens/intro%20screens/splash.dart';
import 'package:sem/wrappers/wrapperprofile.dart';

class Wrappersp extends StatefulWidget {
  const Wrappersp({Key? key}) : super(key: key);

  @override
  State<Wrappersp> createState() => _WrapperspState();
}

class _WrapperspState extends State<Wrappersp> {
  bool End = false;
  @override
  void toggle() {
    setState(() {
      End = !End;
    });
  }

  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);

    if (!End && currentuser == null) {
      return Container(
        child: splash(
          toogle: toggle,
        ),
      );
    } else {
      return Container(
        child: Wrapper(),
      );
    }
  }
}
