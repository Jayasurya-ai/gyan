import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String username;
var urlprofile;
int j=00000;

class ImageUploadPage extends StatefulWidget {
  File image;
  ImageUploadPage(this.image);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  bool loading=false;
  String imageContent;
  final _auth=FirebaseAuth.instance;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    final _storeAuth=FirebaseFirestore.instance;
    return ModalProgressHUD(
      inAsyncCall:loading,
      child: Scaffold(
          body:  Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.file(widget.image)
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (value){
                      imageContent=value;
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
                            'Post Image',
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
                    onPressed: ()async{
                      getImageUrl();
                      if (imageContent != null) {
                        final DateTime now = DateTime.now();
                        final int millSeconds = now.millisecondsSinceEpoch;
                        final String month = now.month.toString();
                        final String date = now.day.toString();
                        final String storageId = (millSeconds.toString());
                        final String today = ('$month-$date');
                        String downloadUrl;
                        setState(() {
                          loading = true;
                        });
                        Reference ref = FirebaseStorage.instance.ref().child(
                            "video").child(today).child(storageId);

                        await ref.putFile(widget.image).whenComplete(() =>
                        {
                        }).then((value) =>
                            value.ref.getDownloadURL().then((value) =>
                            downloadUrl = value));

                        CollectionReference refe=_storeAuth.collection("FeedData");
                        refe.add({
                          "username":username.toString(),
                          "imageurl":downloadUrl.toString(),
                          "videourl":"",
                          "like":0,
                          "uid":_auth.currentUser.uid.toString(),
                          "content":imageContent.toString(),
                          "profileImage":urlprofile.toString(),
                        });

                        setState(() {
                          loading = false;
                        });

                        print("The Url is " + downloadUrl);
                      }
                      else{
                        print("Please provide content and also your profile Image");
                      }
                    }
                      ),
              )
            ],
          )
      ),
    );;
  }
}
