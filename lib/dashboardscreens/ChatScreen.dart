import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyan/TutorChatScreen.dart';
import 'package:gyan/dashboardscreens/TutorsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  String coursename, tutorName;
  ChatScreen({this.coursename, this.tutorName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firauth = FirebaseFirestore.instance;

  String tutorName;
  String nameoftutor;
  String uid;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getUID();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameoftutor = prefs.getString("tutorname");
  }

  void getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("uid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: BackGroundClipper(),
            child: Container(
              height: 120,
              color: Color(0xffF05D0C),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Chat Box",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontFamily: "Montserratregular",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: firauth
                  .collection("RegisteredUsers")
                  .doc(_auth.currentUser.uid)
                  .collection("MyCourses")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.docs[index];

                      var docid = snapshot.data.docs[index].id;

                      // tutorName=data["tutorName"];
                      // final snap = firauth.collection(tutorName).snapshots();

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        child: GestureDetector(
                          onTap: () {
                            // CollectionReference refer=FirebaseFirestore.instance.collection(widget.tutorName);
                            // refer.add({
                            //
                            // });

                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration: Duration(seconds: 1),
                                    transitionsBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secanimation,
                                        Widget screen) {
                                      animation = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.elasticInOut);
                                      return ScaleTransition(
                                        alignment: Alignment.center,
                                        scale: animation,
                                        child: screen,
                                      );
                                    },
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secanimation) {
                                      return TutorChatScreen(
                                        tutame: data["tutorName"],
                                        tutorcourse: data["courseName"],
                                      );
                                    }));
                          },
                          child: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "images/comment.png",
                                            height: 40,
                                            width: 40,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data["courseName"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff393e46),
                                                    fontFamily:
                                                        "Montserratregualar"),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Tutor : ${data["tutorName"]} ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserratregular",
                                                    fontSize: 15,
                                                    color: Color(0xff393e46)
                                                        .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${data["batchNumber"]} ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserratregular",
                                                    fontSize: 15,
                                                    color: Color(0xff393e46)
                                                        .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Column(
                                      //   children: [
                                      //     nameoftutor==data["tutorName"]&&uid==_auth.currentUser.uid?
                                      //     Icon(
                                      //       Icons.lock_open,
                                      //       size: 30,
                                      //       color: Colors.green,
                                      //     ):
                                      //     Icon(
                                      //       Icons.lock_outline_sharp,
                                      //       size: 30,
                                      //       color: Colors.amber,
                                      //     )
                                      //
                                      //
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 0.8,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

class BackGroundClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
