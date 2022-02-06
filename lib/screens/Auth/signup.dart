import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/Authenticate.dart';

class signup extends StatefulWidget {
  final Function ?toggleview;
  const signup({Key? key,this.toggleview}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final Authservice _auth=Authservice();

  String Email="";
  String Password="";
  String confirmpassword="";
  String username="";
  String Error="";
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading ? loadfadingcube(): Scaffold(
      backgroundColor: Colors.white,
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
                  Text("REGISTER WITH TESTER",style: TextStyle(color: Colors.brown,fontSize: 20.0),),
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

                  SizedBox(height: 10.0,),
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
                            dynamic result=await _auth.registerwithEmail(Email, Password,username);
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
                      ElevatedButton(onPressed: ()async {
                        widget.toggleview!();
                        Error="";
                      }, child: Text("Already User ?",style: TextStyle(fontSize: 20.0),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.  green[500])
                        ),
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
