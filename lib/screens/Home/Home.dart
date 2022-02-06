import 'package:flutter/material.dart';
import 'package:sem/services/Authenticate.dart';
import 'package:sem/userwidgets/useraccount.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authservice _auth=Authservice();
  int _selected=0;
  static const List<Widget> _options=<Widget>[
    useraccount(),

  ];
void _ontapped(int index){
  setState(() {
    _selected=index;
  });
}
  @override
  Widget build(BuildContext context) {

    return
    Scaffold(

      appBar: AppBar(
        actions: [
          TextButton.icon(
            icon: Icon(Icons.logout_rounded,size: 30,color: Colors.brown,),
              label: Text(""),
              onPressed:()async{
            await _auth.signout();
          },)
        ],
        backgroundColor: Colors.green[500],


      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
          child:_options.elementAt(_selected)
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[500],
        currentIndex:_selected ,
        onTap: _ontapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: "Home",



          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "Search",

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",

          )
        ],
      ),
    );

  }
}
