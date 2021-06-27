import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String pickedFileContent;
String downloadUrl;

class ChatImageUploadScreen extends StatefulWidget {
  File pickedfile;
  String tutName;
  ChatImageUploadScreen({this.pickedfile, this.tutName});

  @override
  _ChatImageUploadScreenState createState() => _ChatImageUploadScreenState();
}

class _ChatImageUploadScreenState extends State<ChatImageUploadScreen> {
  final stAuth = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool rotating=false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: rotating,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              rotating=true;
            });
            if (pickedFileContent != null) {
              final DateTime now = DateTime.now();
              final int millSeconds = now.millisecondsSinceEpoch;
              final String month = now.month.toString();
              final String date = now.day.toString();
              final String storageId = (millSeconds.toString());
              final String today = ('$month-$date');

              Reference ref = FirebaseStorage.instance
                  .ref()
                  .child("chatImage")
                  .child(today)
                  .child(storageId);

              await ref.putFile(widget.pickedfile).whenComplete(() => {}).then(
                  (value) => value.ref
                      .getDownloadURL()
                      .then((value) => downloadUrl = value));

              CollectionReference refe = stAuth.collection(widget.tutName);
              refe.add({
                "message": "",
                "sender": _auth.currentUser.email.toString(),
                "videourl": "",
                "documenturl": "",
                "imageurl": downloadUrl.toString(),
                "time":FieldValue.serverTimestamp(),
                "textimageMessage":pickedFileContent.toString(),
              });
            }
            setState(() {
              rotating=false;
            });
          },
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Expanded(flex: 6, child: Image.file(widget.pickedfile)),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 80, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Your Message",
                      hintStyle: TextStyle(color: Colors.white),

                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserratregular"
                    ),
                    onChanged: (val) {
                      pickedFileContent = val;
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
