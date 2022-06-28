import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sem/models/user.dart';
import 'package:sem/screens/Wrapped.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sem/services/Authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<myUser?>.value(
        value: Authservice().user,
        catchError: (_, __) {},
        initialData: null,
        child: const MaterialApp(
          home: Wrapper(),
        ));
  }
}
