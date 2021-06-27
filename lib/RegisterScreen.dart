import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gyan/HomeScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  static const id = "register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;

  final _storeinstance = FirebaseFirestore.instance;
  String username, email, phone, password;

  bool visibility = false;

  bool progress = false;
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
          ])),
      child: ModalProgressHUD(
        inAsyncCall: progress,
        color: Colors.orange,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Hero(
                    tag: "read",
                    child: Image.asset(
                      "images/getstartimage.png",
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    onChanged: (value) {
                      username = value;
                    },
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "UserName",
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                            fontFamily: "Montserratregular", fontSize: 14),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.account_circle_rounded,
                          color: Color(0xff393e46),
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    onChanged: (value) {
                      phone = value;
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: TextStyle(
                            fontFamily: "Montserratregular", fontSize: 14),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color(0xff393e46),
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                            fontFamily: "Montserratregular", fontSize: 14),
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
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: !visibility,
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                            fontFamily: "Montserratregular", fontSize: 14),
                        fillColor: Colors.white,
                        filled: true,
                        b order: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff393e46),
                            size: 25,
                          ),
                          onPressed: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(180, 40, 20, 20),
                  child: RawMaterialButton(
                      padding: EdgeInsets.all(15),
                      elevation: 5,
                      fillColor: Color(0xff393e46),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserratregular',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
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
                      onPressed: () async {
                        if (email != null||
                            username !=null ||
                            password !=null||
                            phone != null) {
                          try {
                            setState(() {
                              progress = true;
                            });
                            final user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                            if (user != null) {
                              final DocumentReference ref = _storeinstance
                                  .collection("Users")
                                  .doc(_auth.currentUser.uid);
                              ref.set({
                                "email": email.toString(),
                                "password": password.toString(),
                                "username": username.toString(),
                                "phone": phone.toString(),
                                "uid": _auth.currentUser.uid.toString(),
                                "uproffesion": "",
                                "ubio": "",
                                "ulinkedin": "",
                                "ugithub": ""
                              });

                              setState(() {
                                progress = false;
                              });
                              sendUsername();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please enter all the fields",
                              toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,);
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", username);
  }
}
