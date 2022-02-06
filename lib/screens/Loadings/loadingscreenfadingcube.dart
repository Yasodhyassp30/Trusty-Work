import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loadfadingcube extends StatelessWidget {
  const loadfadingcube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.green[500],
          size: 60.0,
        ),
      ),
    );
  }
}
