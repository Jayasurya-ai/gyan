import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

var urlprofile;

String username;
String videoContent;
int i=00000;

class VideoUploadPage extends StatefulWidget {
  File video;
  VideoUploadPage(this.video);

  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {

  bool _progress=false;
  final _auth=FirebaseAuth.instance;

  FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.file(widget.video),
     );
    getUsername();
  }

  void getImageUrl()async{
    await FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser.uid).get().then((value){
      urlprofile= value.get("profileImage");
    });
  }

  void getUsername()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    username=prefs.getString("username");

  }

  @override
  Widget build(BuildContext context) {
    final _auth=FirebaseAuth.instance;
    final  storageAuth=FirebaseFirestore.instance;
    return ModalProgressHUD(
      inAsyncCall: _progress,
      child: Scaffold(
        body:  Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 400,
                child: FlickVideoPlayer(
                    flickManager: flickManager
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value){
                    videoContent=value;
                  },
                  maxLines: 8,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Write a Caption",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
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
                          'Post Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserratregular',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.check,
                        color: Colors.white,
                      )

                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  onPressed: ()async {
                    if (videoContent !=null) {
                      final DateTime now = DateTime.now();
                      final int millSeconds = now.millisecondsSinceEpoch;
                      final String month = now.month.toString();
                      final String date = now.day.toString();
                      final String storageId = (millSeconds.toString());
                      final String today = ('$month-$date');
                      String downloadUrl;
                      setState(() {
                        _progress = true;
                      });
                      Reference ref = FirebaseStorage.instance.ref().child(
                          "video").child(today).child(storageId);

                      await ref.putFile(widget.video).whenComplete(() =>
                      {
                      }).then((value) =>
                          value.ref.getDownloadURL().then((value) =>
                          downloadUrl = value));
                      CollectionReference refe = storageAuth.collection(
                          "FeedData");
                      refe.add({
                        "username": username.toString(),
                        "videourl": downloadUrl.toString(),
                        "imageurl": "",
                        "like":0,
                        "uid": _auth.currentUser.uid.toString(),
                        "content": videoContent.toString(),
                        "profileImage": urlprofile.toString()
                      });

                      setState(() {
                        _progress = false;
                      });
                    }
                    else{
                      print("please upload your profile image");
                    }


                  }),
            )
          ],
        )
      ),
    );
  }
}