import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyan/VideoUploadPage.dart';
import 'dashboardscreens/ChatScreen.dart';
import 'dashboardscreens/FeedScreen.dart';
import 'dashboardscreens/ProfileScreen.dart';
import 'dashboardscreens/TutorsScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ImageUploadPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {

  static const id="home";


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int i=0;


  List<Widget> screens=[
    FeedScreen(),
    ChatScreen(),
    TutorsScreen(),
    ProfileScreen()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,

        ),
        backgroundColor:  Color(0xff393e46),
        onPressed: (){
          sheet();

          // upload();

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
        child: BottomNavigationBar(
          currentIndex: i,
          elevation: 5,
          backgroundColor:Color(0xffF05D0C),
          selectedItemColor:  Color(0xff393e46),
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:5),
                  child: Icon(
                    Icons.home,
                    size: 32,
                  ),
                ),
              label: ""
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 30, 0),
                  child: Icon(
                    Icons.chat,
                    size: 32,
                  ),
                ),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Icon(
                  Icons.book,
                  size: 32,
                ),
              ),
              label: ""
            ),
            BottomNavigationBarItem(icon: Padding(
              padding: const EdgeInsets.only(top:5),
              child: Icon(
                Icons.assignment_ind,
                size: 32,
              ),
            ),
            label: ""),
          ],
          onTap: (value){
            setState(() {
              i=value;
            });
          },
        ),
      ),
      body: screens[i],
    );
  }


  void sheet(){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20))
      ),
        context: context,builder: (builder){
      return Container(
        height: 200,

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Upload your Feed",
                style: TextStyle(
                  fontSize:20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF05D0C)
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    pickImage();
                  },
                  child: Container(

                    decoration: BoxDecoration(
                      color: Color(0xffE99547).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)

                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          color:Color(0xff393e46)
                        ),
                        Text(
                          "Upload Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff393e46)

                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    pickVideo();
                  },
                  child: Container(

                    decoration: BoxDecoration(
                        color: Color(0xffE99547).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20)

                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                            Icons.video_call,
                          color: Color(0xff393e46),
                        ),
                        Text(
                          "Upload Video",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff393e46)

                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],

            ),
          ],
        )
      );
    });
  }

  void pickVideo()async{
    try {
       final file =  File(await ImagePicker().getVideo(source: ImageSource.gallery).then((pickedfile) =>pickedfile.path ));
       if(file!=null) {
         Navigator.push(context,
             MaterialPageRoute(builder: (context) => VideoUploadPage(file)));
       }
    } catch (error) {
    print(error);
    }

  }

  void pickImage()async{
    try {
      final file =  File(await ImagePicker().getImage(source: ImageSource.gallery).then((pickedfile) =>pickedfile.path ));
      if(file!=null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageUploadPage(file)));
      }
    } catch (error) {
    print(error);
    }

  }
}
