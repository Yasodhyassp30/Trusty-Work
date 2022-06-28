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

  bool plumber=false;
  bool elec=false;
  bool clean=false;
  bool paint=false;
  bool mech=false;
  bool garden=false;

  List<String> workarea=[];

  TextEditingController workareasadd=TextEditingController();
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return loading ? loadfadingcube():Scaffold(
      body:SafeArea(
        child:  Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
            child:Column(
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
                    Text("Trusty WORK",style: TextStyle(color: Colors.brown,fontSize: 25.0,fontWeight: FontWeight.bold),),
                  ],
                ),
                Expanded(
                  child: Container(
                      child: ListView(
                        children: [
                          Column(
                            children: [

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

                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                padding: EdgeInsets.only(left: 50.0,right: 50,top: 10.0),
                                child: Column(
                                    children:[
                                      Text("Experienced in ",style: TextStyle(color: Colors.brown,fontSize: 15.0),),
                                      Row(
                                        children: [
                                          Text('Plumbing',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: plumber, onChanged:(value){
                                            if(plumber){
                                              workarea.remove('plumber');
                                            }else{
                                              workarea.add('plumber');

                                            }
                                            setState(() {
                                              plumber=!plumber;
                                            });
                                            print(workarea);
                                          })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Cleaning',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: clean, onChanged:(value){
                                            if(clean){
                                              workarea.remove('cleaner');
                                            }else{
                                              workarea.add('cleaner');

                                            }
                                            setState(() {
                                              clean=!clean;
                                            });
                                            print(workarea);
                                          })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Electric works',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: elec, onChanged:(value){
                                            if(elec){
                                              workarea.remove('electrician');
                                            }else{
                                              workarea.add('electrician');

                                            }
                                            setState(() {
                                              elec=!elec;
                                            });
                                            print(workarea);
                                          })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Mechanic',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: mech, onChanged:(value){
                                            if(mech){
                                              workarea.remove('mechanic');
                                            }else{
                                              workarea.add('mechanic');

                                            }
                                            setState(() {
                                              mech=!mech;
                                            });
                                          })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Gardening',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: garden, onChanged:(value){
                                            if(garden){
                                              workarea.remove('gardner');
                                            }else{
                                              workarea.add('gardner');

                                            }
                                            setState(() {
                                              garden=!garden;
                                            });
                                            print(workarea);
                                          })
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Painting',style: TextStyle(fontSize: 15.0,color: Colors.brown),),
                                          Expanded(child: SizedBox()),
                                          Checkbox(value: paint, onChanged:(value){
                                            if(paint){
                                              workarea.remove('painter');
                                            }else{
                                              workarea.add('painter');

                                            }
                                            setState(() {
                                              paint=!paint;
                                            });
                                            print(workarea);
                                          })
                                        ],
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text("Not Listed Above Please Add (max:8)",style: TextStyle(fontSize: 10.0),),
                                      SizedBox(height: 10.0,),
                                      Container(
                                        child: Row(
                                          children: [
                                            Expanded(child: TextField(
                                              controller: workareasadd,
                                            )),
                                            IconButton(onPressed: (){
                                              workarea.add(workareasadd.text.toLowerCase());
                                            }, icon:Icon(Icons.add)),
                                            IconButton(onPressed: (){
                                              setState(() {
                                                mech=false;
                                                clean=false;
                                                garden=false;
                                                paint=false;
                                                elec=false;
                                                plumber=false;
                                                workarea=[];
                                              });
                                            }, icon:Icon(Icons.delete))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.0,)
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.0),
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
                                        if(Email==""||Password==""||confirmpassword==""||username==""||Phoneno==""||workarea.length==0){
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
                                  ElevatedButton.icon(onPressed: ()async {
                                    widget.workusertoggle!();
                                    Error="";
                                  }, label :Text("Back",style: TextStyle(fontSize: 20.0),),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green[900],
                                        padding: EdgeInsets.all(10)
                                    ),
                                    icon: Icon(Icons.arrow_back),
                                  ))
                                ],
                              ),

                            ],
                          ),
                        ],
                      )
                  ),
                )
              ],
            )

            )
        ),
      );


  }
}
