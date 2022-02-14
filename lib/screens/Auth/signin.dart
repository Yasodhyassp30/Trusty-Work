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
      appBar: AppBar(
        backgroundColor: Colors.green[500],


      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
        child:Form(
          child: Column(
            children: [
              Text("SIGN IN TO YOUR TESTER",style: TextStyle(color: Colors.brown,fontSize: 20.0),),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.  brown[600])
                        ),
                      )),
                    ],
                  ),
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.  green[500])
                        ),
                      ),)
                    ],
                  ),

                ],
              ),

            ],
          ),
        )
      ),
    );
  }
}
