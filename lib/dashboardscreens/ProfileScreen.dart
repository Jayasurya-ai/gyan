import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gyan/ProfileUpdateScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:gyan/Banner.dart';

var file, profilefile;
String uname, uprofession, uBio;

PickedFile pfile;
File imageFile;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _storAuth = FirebaseFirestore.instance;

  void getData() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
          uname = documentSnapshot.get("username");
          uprofession = documentSnapshot.get("uproffesion");
          uBio = documentSnapshot.get("ubio");
        });
      }
    });
  }

  @override
  void initState() {
    setState((){
      getData();
    });
   
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 280,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("23k"), Text("Projects")],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, bottom: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text("4/10"), Text("Rating")],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 210,
                      width: double.infinity,
                      decoration: file != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(file), fit: BoxFit.cover))
                          : BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/lifestyle.png"),
                                  fit: BoxFit.cover))),
                  Positioned(
                    left: MediaQuery.of(context).size.width - 40,
                    top: 170,
                    child: GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Icon(
                        Icons.edit,
                        color: Colors.orange,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2.7,
                    top: 160,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 45,
                          child: CircleAvatar(
                            // backgroundImage: file == null
                            backgroundImage: profilefile != null
                                ? FileImage(profilefile)
                                : AssetImage("images/profile.png"),
                            // : FileImage(file),
                            radius: 40,
                          ),
                        ),
                        Positioned(
                          width: 150,
                          height: 130,
                          child: GestureDetector(
                            onTap: () {
                              profilepickImage();
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: Color(0xff393e46),
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 35, right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              uname.toString(),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontFamily: "Montserratregular",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              width: 1,
                              height: 20,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              uprofession.toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Montserratregular",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Expanded(
                      child: Text(
                        "Bio\n\n${uBio.toString()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withOpacity(.5),
                          fontFamily: "Montserratregular",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10, 
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(context, _createRoute());
                    },
                    fillColor: Color(0xff393e46),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserratregular",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {},
                            shape: CircleBorder(),
                            elevation: 10,
                            fillColor: Color(0xff393e46),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "images/linkedin.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "LINKED IN",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontFamily: "Montserratregular",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {},
                            shape: CircleBorder(),
                            elevation: 10,
                            fillColor: Color(0xff393e46),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "images/github.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "GIT HUB",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontFamily: "Montserratregular",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {},
                            shape: CircleBorder(),
                            elevation: 10,
                            fillColor: Color(0xff393e46),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Image.asset(
                                  "images/cv.png",
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "RESUME",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontFamily: "Montserratregular",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {},
                            shape: CircleBorder(),
                            elevation: 10,
                            fillColor: Color(0xff393e46),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "images/mail.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "MAIL",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontFamily: "Montserratregular",
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // StreamBuilder(
              //     stream: FirebaseFirestore.instance
              //         .collection("FeedData")
              //         .snapshots(),
              //     builder: (BuildContext context, snapdhot) {
              //       if (!snapdhot.hasData) {
              //         return CircularProgressIndicator();
              //       }
              //       if (snapdhot.hasData) {
              //         return GridView.builder(
              //             shrinkWrap: true,
              //             itemCount: snapdhot.data.docs.length,
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                     crossAxisCount: 2),
              //             itemBuilder: (context, index) {
              //               var data = snapdhot.data.docs[index];
              //                 // if(data["uid"]==_auth.currentUser.uid){
              //                 return Container(
              //                   decoration: BoxDecoration(
              //                       image: DecorationImage(
              //                           image: NetworkImage(data["imageurl"]))),
              //                 );
              //                 // }
                          
                            
              //             });
              //       }
              //     })
            ],
          ),
        ));
  }

  void pickImage() async {
    try {
      file = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  void profilepickImage() async {
    try {
      profilefile = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  // getFromGallery() async {
  //   pfile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   imageFile = pfile as File;
  //   // _cropImage(pfile.path);
  // }
}

/// Crop Image
//   _cropImage(filePath) async {
//     File croppedImage = await ImageCropper.cropImage(
//       sourcePath: filePath,
//       maxWidth: 1080,
//       maxHeight: 1080,
//     );
//     if (croppedImage != null) {
//       imageFile = croppedImage;
//       setState(() {});
//     }
//   }
// }

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ProfileUpdateScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 0.5);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
