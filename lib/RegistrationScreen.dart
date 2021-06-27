import 'package:flutter/material.dart';
import 'package:gyan/LoginScreen.dart';
import 'package:gyan/RegisterScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = "registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 25,
                ),
                Hero(
                    tag: "read",
                    child: Image.asset('images/getstartimage.png')),
                    SizedBox(
                      height: 20,
                    ),
                Image.asset("images/logof.png"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'A PEER LEARNING PLATFORM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Montserratsemibold',
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Find your best learning COURSES with best MENTORS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserratsemibold',
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                  child: RawMaterialButton(
                      padding: EdgeInsets.all(15),
                      elevation: 10,
                      fillColor: Color(0xff393e46),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              'Register Here',
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
                            color:Colors.white,
                          )
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.id);
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an Account ? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserratregular',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xff393e46),
                          fontFamily: 'Montserratregular',
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}
