import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
bool progress = false;

class ProfileUpdateScreen extends StatefulWidget {
  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  String userName, userProffesion, userBio, userLinkedin, userGithub;
  

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: progress,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    onChanged: (uNameData) {
                      userName = uNameData;
                    },
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: "Enter your UserName",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.orange)),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "Montserratregular"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    onChanged: (String uProfessiondata) {
                      userProffesion = uProfessiondata;
                    },
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: "Enter your Profession",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.orange)),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "Montserratregular"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    onChanged: (String uLinkedInData) {
                      userLinkedin = uLinkedInData;
                    },
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: "Enter your linked in profile link",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.orange)),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "Montserratregular"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    onChanged: (String uGitHubData) {
                      userGithub = uGitHubData;
                    },
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: "Enter your Github Link",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.orange)),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "Montserratregular"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "Montserratregular",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    onChanged: (uBioData) {
                      userBio = uBioData;
                    },
                    maxLines: 3,
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                      hintText: "Enter your Bio",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.orange),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.orange)),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: "Montserratregular"),
                    ),
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    setState(() {
                      progress = true;
                    });
                    DocumentReference refernce = FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser.uid);

                    await refernce.update({
                      "uproffesion": userProffesion.toString(),
                      "ubio": userBio.toString(),
                      "ulinkedin": userLinkedin.toString(),
                      "ugithub": userGithub.toString(),
                      "username": userName.toString()
                    });
                    setState(() {
                      progress = false;
                    });
                    Navigator.pop(context);
                    setState(() {
                                          
                   });
                  },
                  fillColor: Color(0xff393e46),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "Update",
                      style: TextStyle(
                          fontFamily: "Montserratregular",
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
