import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/Authenticate.dart';

class workersignup extends StatefulWidget {
  final Function ?workusertoggle;
  const workersignup({Key? key,this.workusertoggle}) : super(key: key);

  @override
  _workersignupState createState() => _workersignupState();
}

class _workersignupState extends State<workersignup> {
  final Authservice _auth=Authservice();
  String Email="";
  String Phoneno="";
  String Password="";
  String confirmpassword="";
  String username="";
  String Error="";
  String type="";
  List<String> workarea=[];
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading ? loadfadingcube():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
      ),
      body: Container(

          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child:Form(
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0,),
                  Text("WORK WITH TESTER",style: TextStyle(color: Colors.brown,fontSize: 20.0),),
                  SizedBox(height: 10.0,),
                  Text("$Error",style: TextStyle(color: Colors.redAccent),),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Email",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),


                    ),
                    onChanged: (val){
                      setState(() {
                        Email=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Username",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),

                    ),

                    onChanged: (val){
                      setState(() {
                        username=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Mobile No",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),

                    ),

                    onChanged: (val){
                      setState(() {
                        Phoneno=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Type Of Work",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),
                    ),

                    onChanged: (val){
                      setState(() {
                        type=val;

                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(child:
                      TextButton(onPressed: () {
                        if (type.length > 0) {
                          setState(() {
                            workarea.add(type.toLowerCase());
                          });
                        }
                      }, child: Text("Add",style: TextStyle(fontSize: 20.0,color: Colors.green[500]),)),

                      ),

                    ],
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Password",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),

                    ),
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        Password=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    style: TextStyle(color: Colors.brown),
                    decoration: InputDecoration(
                      label: Text("Confirm Password",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),

                    ),
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        confirmpassword=val;
                      });
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton.icon(
                        icon: Icon(Icons.assignment_turned_in),
                        onPressed: ()async {
                          if(Email==""||Password==""||confirmpassword==""||username==""){
                            setState(() {
                              Error="Please Fill All Fields";
                            });

                          }else if(Password!=confirmpassword){
                            setState(() {
                              Error="Passwords not Matching";
                            });

                          }else{
                            setState(() {
                              Error="";

                            });
                            setState(() {
                              loading=true;
                            });
                            dynamic result=await _auth.registerwithEmailworker(Email, Password,username,workarea,Phoneno);
                            if(result==null){
                              setState(() {
                                Error ="User Registration Failed";
                                loading=false;
                              });
                            }

                          }
                        }, label: Text("REGISTER",style: TextStyle(fontSize: 20.0),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.  brown[600])
                        ),
                      ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton.icon(onPressed: ()async {
                        widget.workusertoggle!();
                        Error="";
                      }, label :Text("Back",style: TextStyle(fontSize: 20.0),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.  green[500])
                        ),
                        icon: Icon(Icons.arrow_back),
                      ))
                    ],
                  ),

                ],
              ),
            ),

          )
      ),
    );


  }
}
