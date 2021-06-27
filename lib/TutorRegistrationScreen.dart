import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:razorpay_flutter/razorpay_flutter.dart";

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gyan/TutorChatScreen.dart';
import 'dashboardscreens/ChatScreen.dart';

Razorpay razor;

class TutorRegistrationScreen extends StatefulWidget {
  String courseName,
      tutorDescription,
      tutorExperience,
      tutorName,
      tutorImageUrl,
      documentID,
      batchNumber;

  double rating;
  String registrationLimit;

  TutorRegistrationScreen(
      {this.courseName,
      this.tutorDescription,
      this.tutorExperience,
      this.tutorName,
      this.batchNumber,
      this.tutorImageUrl,
      this.rating,
      this.documentID,
      this.registrationLimit});

  @override
  _TutorRegistrationScreenState createState() =>
      _TutorRegistrationScreenState();
}

class _TutorRegistrationScreenState extends State<TutorRegistrationScreen> {
  bool showText = false;
  final _storeAuth = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tutorname", widget.tutorName);
  }

  void setUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", _auth.currentUser.uid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    razor = Razorpay();
    razor.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razor.on(Razorpay.EVENT_PAYMENT_ERROR, handlerError);
    razor.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razor.clear();
  }

  void checkOut() {
    var option = {
      "key": "rzp_test_Zt4171K7QHDt91",
      "amount": 300.toString(),
      "name": "Jayasurya",
      "description": "Your paying to IGYAN",
      "prefill": {"contact": "657658656", "email": "fhgvhgvhgchvc@gmail.com"},
      "external": {
        "wallets": ["paytm"],
      }
    };
    try {
      razor.open(option);
    } catch (e) {
      print(e);
    }
  }

  void handlerPaymentSuccess() {
    // Toast.show("Payment Success", context);
    print("Payment SuccessFull");
    setData();
    // CollectionReference ref=_storeAuth.collection(widget.tutorName);
    // ref.add({
    //
    // });
  }

  void handlerError() {
    // Toast.show("Payment Error", context);
  }

  void handlerExternalWallet() {
    // Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 8,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.chevron_left,
                            color: Color(0xff393e46),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.mail_outline,
                          size: 30,
                          color: Color(0xff393e46),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.tutorImageUrl,
                        height: 180,
                        width: 140,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tutorName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: "Montserratregular",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.courseName,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 18,
                              fontFamily: "Montserratregular",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                              ),
                              elevation: 6,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: "Montserratregular",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${(widget.rating).toString()} out of 5",
                                  style: TextStyle(
                                      fontFamily: "Montserratregular",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.group,
                                  color: Color(0xff393e46),
                                  size: 30,
                                ),
                              ),
                              elevation: 6,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Students",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: "Montserratregular",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "${widget.tutorExperience.toString()} +",
                                  style: TextStyle(
                                      fontFamily: "Montserratregular",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bio",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserratregular"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              widget.tutorDescription,
                              maxLines: showText ? 10 : 3,
                              style: TextStyle(
                                  fontFamily: "Montserratregular",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showText = !showText;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  showText
                                      ? Text(
                                          "Read less",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff393e46),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserratregular"),
                                        )
                                      : Text(
                                          "Read more",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff393e46),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserratregular"),
                                        )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 160,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: RawMaterialButton(
                elevation: 10,
                onPressed: () async {
                  // checkOut();
                  // setData();
                  // setUID();
                  print(widget.documentID);
                  DocumentReference reference = await FirebaseFirestore.instance
                      .collection("Tutors")
                      .doc(widget.documentID);
                  reference.update({
                    "registrationsLimit":
                        (double.parse(widget.registrationLimit) - 1).toString(),
                    // "regitrationstatus":"true",
                  });
                  CollectionReference rere = FirebaseFirestore.instance
                      .collection("RegisteredUsers")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection("MyCourses");
                  rere.add({
                    "tutorName": widget.tutorName,
                    "courseName": widget.courseName,
                    "uid": _auth.currentUser.uid,
                    "batchNumber": widget.batchNumber
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              coursename: widget.courseName,
                              tutorName: widget.tutorName)));
                  // CollectionReference refere=FirebaseFirestore.instance.collection("RegisteredUsers");
                  // refere.add({
                  //   "tutorName":widget.tutorName,
                  //   "courseName":widget.courseName,
                  //   "timeStamp":
                  // });

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Color(0xffF05D0C),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Book your Course",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "Montserratregular",
                            fontSize: 20),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
