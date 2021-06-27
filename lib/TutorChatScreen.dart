import 'dart:io';

import 'ChattingVideoUploadScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gyan/ChatImageUploadScreen.dart';
import 'package:pop_bottom_menu/pop_bottom_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

String usermessage;
String pdfDownload;
String downloadvalue;

bool statusProgress = false;

File file;

String userfilename;
String dowloadstate = "start";

FlickManager flickManager;
String filename;
String Url;

class TutorChatScreen extends StatefulWidget {
  String tutame, tutorcourse;

  TutorChatScreen({this.tutame, this.tutorcourse});

  @override
  _TutorChatScreenState createState() => _TutorChatScreenState();
}

class _TutorChatScreenState extends State<TutorChatScreen>
    with SingleTickerProviderStateMixin {
  final stauth = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final messagetext = TextEditingController();

  // Future download2(Dio dio,String url,String savePath)async{
  //   try{
  //     Response responce=await dio.get(
  //       url,
  //       onReceiveProgress: showDownload,
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         validateStatus: (status){
  //           return status<500;
  //         }
  //       )
  //
  //     );
  //     File file=File(savePath);
  //     var raf=file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(responce.data);
  //     await raf.close();
  //
  //   }catch(e){
  //
  //   }
  //
  // }
  // void showDownload(recieved,total){
  //   if(total!=-1){
  //     setState(() {
  //       downloadvalue=(recieved/total*100).toStringAsFixed(0)+"%";
  //     });
  //     if(downloadvalue=="100%"){
  //        pdfDownload="100%";
  //     }
  //     print(downloadvalue);
  //     CollectionReference r=FirebaseFirestore.instance.collection(widget.tutorName);
  //     r.add({
  //       "downloadvalue":pdfDownload.toString(),
  //     });
  //
  //   }
  //
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void selectedImage() async {
    try {
      final fileuploaded = File(await ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatImageUploadScreen(
                    pickedfile: fileuploaded,
                    tutName: widget.tutame,
                  )));
    } catch (error) {
      print(error);
    }
  }

  void selectedVideo() async {
    try {
      final fileVideo = File(await ImagePicker()
          .getVideo(source: ImageSource.gallery)
          .then((pickedfile) => pickedfile.path));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChattingVideoUploadScreen(
                    nameoftutor: widget.tutame,
                    pickedVideo: fileVideo,
                  )));
    } catch (error) {
      print(error);
    }
  }
  // Future getPdfAndUpload()async{
  //   // File file = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ["doc","pdf","jpg"]);
  //   // String filename = '${randomName}.pdf';
  //   FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,
  //     allowedExtensions: ['pdf']);
  //
  //   if(result != null) {
  //      file = File(result.files.single.path);
  //   } else {
  //     // User canceled the picker
  //   }
  //   dialog();
  // }

  void savePdf() async {
    final DateTime now = DateTime.now();
    final int millSeconds = now.millisecondsSinceEpoch;
    final String month = now.month.toString();
    final String date = now.day.toString();
    final String storageId = (millSeconds.toString());
    final String today = ('$month-$date');
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("documents")
        .child(today)
        .child(storageId);

    await reference.putFile(file).whenComplete(() => {}).then(
        (value) => value.ref.getDownloadURL().then((value) => Url = value));
    print(Url);
  }

  Widget dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height - 610,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Send File",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserratregular",
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      cursorColor: Colors.orange,
                      decoration: InputDecoration(hintText: "File name"),
                      onChanged: (value) {
                        userfilename = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            actions: [
              RawMaterialButton(
                onPressed: () {
                  savePdf();
                  // if(file!=null&&userfilename!=null&&Url!=null){
                  CollectionReference refe =
                      FirebaseFirestore.instance.collection(widget.tutame);
                  refe.add({
                    "message": "",
                    "sender": _auth.currentUser.email.toString(),
                    "videourl": "",
                    "documenturl": Url.toString(),
                    "imageurl": "",
                    "pdfname": userfilename.toString(),
                    "time": FieldValue.serverTimestamp(),
                    "textimageMessage": "",
                    "textvideoMessage": "",
                  });
                  Navigator.pop(context);
                  // }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                fillColor: Colors.orange,
                child: Text(
                  "send",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "Montserratregular",
                  ),
                ),
              )
            ],
          );
        });
  }

  void _showMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return PopBottomMenu(
          title: TitlePopBottomMenu(
            label: "ADD FILE",
          ),
          items: [
            ItemPopBottomMenu(
                label: "Upload an Image",
                icon: Icon(
                  Icons.navigate_next,
                ),
                onPressed: () {
                  selectedImage();
                }),
            ItemPopBottomMenu(
              onPressed: () {
                selectedVideo();
              },
              label: "Upload a video",
              icon: Icon(
                Icons.navigate_next,
                color: Colors.black,
              ),
            ),
            // ItemPopBottomMenu(
            //   onPressed: () {
            //      getPdfAndUpload();
            //   },
            //   label: "Upload a document",
            //   icon: Icon(
            //     Icons.navigate_next,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipPath(
            clipper: BackGroundClipper(),
            child: Container(
              height: 120,
              color: Color(0xffF05D0C),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  widget.tutorcourse.toString(),
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.white,
                      fontFamily: "Montserratregular",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: StreamBuilder<QuerySnapshot>(
                stream: stauth
                    .collection(widget.tutame)
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  print(widget.tutame);
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          final val = snapshot.data.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment:
                                  _auth.currentUser.email == val["sender"]
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  val["sender"],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontFamily: "Montserratregular"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                val["message"] == "" &&
                                        val["videourl"] == "" &&
                                        val["documenturl"] == ""
                                    ? Column(
                                        crossAxisAlignment:
                                            _auth.currentUser.email ==
                                                    val["sender"]
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: _auth.currentUser.email ==
                                                    val["sender"]
                                                ? const EdgeInsets.only(
                                                    left: 40)
                                                : const EdgeInsets.only(
                                                    right: 40),
                                            child: Image.network(
                                              val["imageurl"],
                                              height: 400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            val["textimageMessage"],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    "Montserratregular"),
                                          )
                                        ],
                                      )
                                    : val["message"] == "" &&
                                            val["imageurl"] == "" &&
                                            val["documenturl"] == ""
                                        ? Column(
                                            crossAxisAlignment:
                                                _auth.currentUser.email ==
                                                        val["sender"]
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    _auth.currentUser.email ==
                                                            val["sender"]
                                                        ? const EdgeInsets.only(
                                                            left: 40)
                                                        : const EdgeInsets.only(
                                                            right: 40),
                                                child: FlickVideoPlayer(
                                                    flickManager: FlickManager(
                                                  videoPlayerController:
                                                      VideoPlayerController
                                                          .network(
                                                              val["videourl"]),
                                                )),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                val["textvideoMessage"],
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "Montserratregular"),
                                              )
                                            ],
                                            // ):val["message"]==""&&val["imageurl"]==""&&val["videourl"]==""?Padding(
                                            //   padding:_auth.currentUser.email==val["sender"]?const EdgeInsets.only(left: 40):const EdgeInsets.only(right:50),
                                            //   child: Card(
                                            //     child: Padding(
                                            //       padding: const EdgeInsets.all(15.0),
                                            //       child: Row(
                                            //         children: [
                                            //           Text(
                                            //             val["pdfname"],
                                            //           ),
                                            //           SizedBox(
                                            //             width: 10,
                                            //           ),
                                            //           RawMaterialButton(onPressed: ()async{
                                            //             String path=await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
                                            //             String fullPath="$path/${val["pdfname"]}.pdf";
                                            //             download2(dio,val["documenturl"],fullPath);
                                            //           },
                                            //             shape: CircleBorder(),
                                            //             child: downloadvalue==null?Icon(
                                            //                 Icons.file_download
                                            //             ):downloadvalue!=null?Text(val["downloadvalue"].toString()):Icon(
                                            //               Icons.check
                                            //             )
                                            //           )
                                            //         ],
                                            //       ),
                                            //     ),
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius: BorderRadius.circular(20),
                                            //     ),
                                            //   ),
                                            // ):
                                          )
                                        : Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                val["message"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "Montserratregular",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            color: _auth.currentUser.email ==
                                                    val["sender"]
                                                ? Colors.orange
                                                : Colors.grey,
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: _auth.currentUser
                                                            .email ==
                                                        val["sender"]
                                                    ? BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(20))
                                                    : BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(20),
                                                        bottomRight:
                                                            Radius.circular(
                                                                20))),
                                          )
                              ],
                            ),
                          );
                        });
                  }
                }),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showMenu();
                  },
                  child: Icon(
                    Icons.attach_file,
                    size: 30,
                    color: Colors.orange,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: TextField(
                    controller: messagetext,
                    decoration: InputDecoration(
                      hintText: "Enter Your Message",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 3)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.orange,
                        width: 3,
                      )),
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 3)),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: IconButton(
                        onPressed: () async {
                          CollectionReference ref =
                              await stauth.collection(widget.tutame);
                          ref.add({
                            "sender": _auth.currentUser.email,
                            "message": messagetext.text.toString(),
                            "time": FieldValue.serverTimestamp(),
                            "documenturl": "",
                            "videourl": "",
                            "imageurl": "",
                          });
                          messagetext.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.orange,
                        ),
                      ),
                    )),
              ),
            ],
          ),
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
