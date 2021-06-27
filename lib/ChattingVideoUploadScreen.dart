import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String videomessage;
FlickManager flickManager;
String videoUrl;
bool progressBar=false;
class ChattingVideoUploadScreen extends StatefulWidget {
  String nameoftutor;
  File pickedVideo;


  ChattingVideoUploadScreen({this.nameoftutor,this.pickedVideo});


  @override
  _ChattingVideoUploadScreenState createState() => _ChattingVideoUploadScreenState();
}

class _ChattingVideoUploadScreenState extends State<ChattingVideoUploadScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(widget.pickedVideo),
    );
  }
  @override
  Widget build(BuildContext context) {
    final fireauth=FirebaseFirestore.instance;
    final _auth=FirebaseAuth.instance;
    return ModalProgressHUD(
      inAsyncCall: progressBar,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            setState(() {
              progressBar=true;
            });
            if (videomessage!= null) {
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

              await ref.putFile(widget.pickedVideo).whenComplete(() => {}).then(
                      (value) => value.ref
                      .getDownloadURL()
                      .then((value) => videoUrl= value));

              CollectionReference refe = fireauth.collection(widget.nameoftutor);
              refe.add({
                "message": "",
                "sender": _auth.currentUser.email.toString(),
                "videourl": videoUrl.toString(),
                "documenturl": "",
                "imageurl": "",
                "time":FieldValue.serverTimestamp(),
                "textvideoMessage":videomessage.toString(),
              });
            }
            setState(() {
              progressBar=false;
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
            Expanded(flex: 6, child:  FlickVideoPlayer(
                flickManager: flickManager
            ),),
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
                      color:  Colors.white,
                      fontFamily: "Montserratregular"
                    ),
                    onChanged: (val) {
                      videomessage = val;
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
