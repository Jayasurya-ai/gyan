import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
class LoginScreen extends StatefulWidget {
  static const id="loginscreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email,password;
  bool visibility=false;
  bool progress=false;
  final _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffE99547),
                Color(0xffF05D0C),
              ]
          )
      ),
      child: ModalProgressHUD(
        inAsyncCall: progress,
        color: Color(0xffE99547),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                  flex:2,child: Hero(tag:"read",child: Image.asset("images/getstartimage.png",))),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  "Welcome Back! Login ",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Mosterratregular",
                    color: Color(0xff393e46),
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
                child: TextField(
                  onChanged: (value){
                    email=value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xff393e46),
                        size: 25,
                      )

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  onChanged: (value){
                    password=value;
                  },
                  obscureText: !visibility,
                  decoration: InputDecoration(
                      hintText: "Password",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          visibility?Icons.visibility:Icons.visibility_off,
                          color: Color(0xff393e46),
                        ),
                        onPressed: (){
                          setState(() {
                            visibility=!visibility;
                          });
                        },
                      )

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(180, 10, 20, 20),
                child: RawMaterialButton(
                    padding: EdgeInsets.all(20),

                    elevation: 5,
                    fillColor: Color(0xff393e46),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserratregular',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )

                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: ()async{
                      if(email!=null&&password!=null) {
                        try {
                          setState(() {
                            progress=true;
                          });
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            setState(() {
                              progress=false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                          }
                        }
                        catch (e) {
                          print(e);
                        }
                      }else{
                        print("Please enter all fields");
                      }


                    }),
              )
            ],
          ),

        ),
      ),
    );
  }
}
    