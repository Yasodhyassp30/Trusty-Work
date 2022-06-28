import 'package:flutter/material.dart';
import 'package:sem/screens/Loadings/loadingscreenfadingcube.dart';
import 'package:sem/services/Authenticate.dart';

class SignIN extends StatefulWidget {
  final Function ?toggleview;
  const SignIN({Key? key,
  this.toggleview,
  }) : super(key: key);

  @override
  _SignINState createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  final Authservice _auth=Authservice();
  String Email="";
  String Password="";
  String Error="";
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading ? loadfadingcube() : Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
            child:Column(
              children: [
                Form(
                  child: Column(
                    children: [
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
                      Text("$Error",style: TextStyle(color: Colors.redAccent),),
                      SizedBox(height: 20.0,),
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
                      SizedBox(height: 20.0,),
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
                      SizedBox(height: 20.0,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Expanded(child:ElevatedButton.icon(
                                  icon: Icon(Icons.arrow_forward_ios_rounded),
                                  onPressed: ()async {
                                    if(Email==""||Password==""){
                                      setState(() {
                                        Error="Fill All Fields";
                                      });
                                    }else{
                                      setState(() {
                                        Error="";
                                        loading=true;
                                      });
                                      dynamic result= await _auth.Signin_with_email(Email, Password);
                                      if(result==null){
                                        setState(() {
                                          Error="Failed to Log in";
                                          loading=false;
                                        });
                                      }
                                    }

                                  }, label: Text("SIGN IN",style: TextStyle(fontSize: 20.0),),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.lightGreen,
                                      padding: EdgeInsets.all(10)
                                  )
                              )),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(child: ElevatedButton.icon(
                                  icon: Icon(Icons.person),
                                  onPressed:(){
                                    widget.toggleview!();
                                  }

                                  , label: Text("Create new Account",style: TextStyle(fontSize: 20.0),
                                maxLines:2,
                                overflow: TextOverflow.ellipsis,
                                textAlign:TextAlign.justify,),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      padding: EdgeInsets.all(10)
                                  )
                              ),)
                            ],
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
                Expanded(child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/signin.png')
                    )
                  ),
                ))
              ],
            )
        ),
      )
    );
  }
}
