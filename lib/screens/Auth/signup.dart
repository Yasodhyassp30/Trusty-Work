import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/Authenticate.dart';

class signup extends StatefulWidget {
  final Function ?toggleview;
  final Function ?workusertoggle;
  const signup({Key? key,this.toggleview,this.workusertoggle}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final Authservice _auth=Authservice();

  String Email="";
  String Password="";
  String confirmpassword="";
  String username="";
  String phoneno="";
  String Error="";
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading ? loadfadingcube(): Scaffold(
      backgroundColor: Colors.white,
      body: Container(

          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child:Form(
            child:SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.1,
                        width: MediaQuery.of(context).size.width*0.1,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/signupimage.png')
                            )
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text("Register Trusty WORK",style: TextStyle(color: Colors.brown,fontSize: 18.0,fontWeight: FontWeight.bold),),
                    ],
                  ),
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
                      label: Text("Contact No",style: TextStyle(color: Colors.brown),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          )
                      ),

                    ),

                    onChanged: (val){
                      setState(() {
                        phoneno=val;
                      });
                    },
                  ),


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
                            dynamic result=await _auth.registerwithEmail(Email, Password,username,phoneno);
                            if(result==null){
                              setState(() {
                                Error ="User Registration Failed";
                                loading=false;
                              });
                            }

                          }
                        }, label: Text("REGISTER",style: TextStyle(fontSize: 20.0),),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[400],
                              padding: EdgeInsets.all(10)
                          )
                      ))
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton(onPressed: ()async {
                        widget.toggleview!();
                        Error="";
                      }, child: Text("Already User ?",style: TextStyle(fontSize: 20.0),),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[700],
                              padding: EdgeInsets.all(10)
                          )
                      ))
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton(onPressed: ()async {
                        widget.workusertoggle!();
                        Error="";
                      }, child: Text("Work with Trusty",style: TextStyle(fontSize: 20.0),),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[900],
                              padding: EdgeInsets.all(10)
                          )
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
