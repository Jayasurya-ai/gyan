import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

import '../StoryContentScreen.dart';
import 'package:visibility_detector/visibility_detector.dart';

int like = 0;
bool showText = false;
Color likecolor = Colors.black;
bool liked = false;
bool showheartOverlay = false;
FlickManager flickManager;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void dispose() {
    flickManager.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _storeAuth = FirebaseFirestore.instance;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.orange.withOpacity(.2), Colors.white])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   automaticallyImplyLeading: false,
          //   title: Center(
          //     child: Text(
          //       "IGYAN",
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Color(0xffF05D0C),
          //           fontSize: 25
          //       ),
          //     ),
          //   ),
          // ),
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
                      "IGYAN",
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _storeAuth.collection("Stories").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data.docs[index];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryContentScreen(
                                                        storyContentUrl: data[
                                                            "storyContentUrl"],
                                                        storyImageUrl: data[
                                                            "storyImageUrl"],
                                                        storyName:
                                                            data["storyName"],
                                                      )));
                                        },
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Color(0xffF05D0C),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                data["storyImageUrl"]),
                                            radius: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      data["storyName"],
                                      style: TextStyle(
                                        fontFamily: "Montserratregular",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
                      })),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  thickness: 2,
                  color: Colors.grey.withOpacity(.3),
                ),
              ),
              Expanded(
                flex: 5,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _storeAuth.collection("FeedData").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot value = snapshot.data.docs[index];
                            var docId = snapshot.data.docs[index].id;
                            flickManager = FlickManager(
                              autoInitialize: true,
                              autoPlay: false,
                              videoPlayerController:
                                  VideoPlayerController.network(
                                      value["videourl"]),           
                            );

                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage: value[
                                                          "profileImage"] ==
                                                      null
                                                  ? AssetImage(
                                                      "images/profile.png")
                                                  : NetworkImage(
                                                      value["profileImage"]),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              value["username"],
                                              style: TextStyle(
                                                  fontFamily:
                                                      "Montserratregular",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                        Icon(
                                          Icons.pending_outlined,
                                          color: Colors.black.withOpacity(.5),
                                          size: 26,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          showheartOverlay = true;
                                          liked = !liked;

                                          liked
                                              ? like = value["like"] + 1
                                              : like = value["like"] - 1;

                                          DocumentReference refe =
                                              FirebaseFirestore.instance
                                                  .collection("FeedData")
                                                  .doc(docId);
                                          refe.update({
                                            "like": like,
                                          });
                                          if (showheartOverlay) {
                                            Timer(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              setState(() {
                                                showheartOverlay = false;
                                              });
                                            });
                                          }
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: Container(
                                                  height: 250,
                                                  width: double.infinity,
                                                  child: value["imageurl"] == ""
                                                      ? FlickVideoPlayer(
                                                          flickManager:
                                                              flickManager)
                                                      : Image.network(
                                                          value["imageurl"],
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            liked && showheartOverlay
                                                ? Icon(
                                                    Icons.thumb_up,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        IconButton(
                                            icon: liked
                                                ? Icon(
                                                    Icons.thumb_up,
                                                    color: Colors.orange,
                                                    size: 25,
                                                  )
                                                : Icon(
                                                    Icons.thumb_up_outlined,
                                                    color: Colors.grey,
                                                    size: 25,
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                liked = !liked;

                                                liked
                                                    ? like = value["like"] + 1
                                                    : like = value["like"] - 1;

                                                DocumentReference refe =
                                                    FirebaseFirestore.instance
                                                        .collection("FeedData")
                                                        .doc(docId);
                                                refe.update({
                                                  "like": like,
                                                });
                                              });
                                            }),
                                        Text(value["like"].toString()),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          size: 25,
                                        ),
                                        Text("30"),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Icon(
                                          Icons.share,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${value["username"]} :",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily:
                                                      "Montserratregular",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                value["content"],
                                                maxLines: showText ? 16 : 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "Montserratregular",
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              showText = !showText;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              showText
                                                  ? Text(
                                                      "Read less",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Color(0xff393e46),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Montserratregular"),
                                                    )
                                                  : Text(
                                                      "Read more",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Color(0xff393e46),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Montserratregular"),
                                                    )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.grey.withOpacity(.2),
                                  )

                                  // Padding(
                                  //   padding: const EdgeInsets.all(4.0),
                                  //   child: Row(
                                  //     children: [
                                  //       CircleAvatar(
                                  //         backgroundImage:
                                  //             NetworkImage(value["profileImage"]),
                                  //         radius: 20,
                                  //       ),
                                  //       SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Text(
                                  //         value["username"],
                                  //         style: TextStyle(
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Divider(
                                  //   thickness: 0.2,
                                  //   color: Color(0xff393e46),
                                  // ),
                                  // Center(
                                  //   child: Container(
                                  //     height: 400,
                                  //     child: value["imageurl"] == ""
                                  //         ? FlickVideoPlayer(
                                  //             flickManager: FlickManager(
                                  //             videoPlayerController:
                                  //                 VideoPlayerController.network(
                                  //                     value["videourl"]),
                                  //           ))
                                  //         : Image.network(value["imageurl"]),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Row(
                                  //     children: [
                                  //       SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       IconButton(
                                  //         icon: Icon(
                                  //           Icons.thumb_up,
                                  //           size: 30,
                                  //           color: value["like"] != ""
                                  //               ? Color(0xffF05D0C)
                                  //               : Colors.black,
                                  //         ),
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             like = value["like"] + 1;
                                  //             likecolor = Color(0xffF05D0C);
                                  //           });

                                  //           DocumentReference refe = _storeAuth
                                  //               .collection("FeedData")
                                  //               .doc(docId);
                                  //           refe.update({
                                  //             "like": like,
                                  //           });
                                  //         },
                                  //       ),
                                  //       SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Text(
                                  //         value["like"].toString(),
                                  //         style: TextStyle(
                                  //             fontSize: 18,
                                  //             color: Color(0xffF05D0C),
                                  //             fontWeight: FontWeight.bold),
                                  //       ),
                                  //       SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Icon(
                                  //         Icons.call_made_sharp,
                                  //         size: 30,
                                  //       )
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          });
                    }),
              )
            ],
          )),
    );
  }
}

class BackGroundClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
