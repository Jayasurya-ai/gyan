
import 'package:flutter/material.dart';


double percent = 0.0;
AnimationController _controller;

class StoryContentScreen extends StatefulWidget {
  String storyContentUrl, storyImageUrl, storyName;

  StoryContentScreen(
      {this.storyContentUrl, this.storyImageUrl, this.storyName});

  @override
  _StoryContentScreenState createState() => _StoryContentScreenState();
}

class _StoryContentScreenState extends State<StoryContentScreen>
    with SingleTickerProviderStateMixin {
  // Timer timer;

  // void startTimer() {
  //   timer = Timer.periodic(Duration(milliseconds: 5), (timer) {
  //     setState(() {
  //       percent += 0.001;
  //       if (percent > 1) {
  //         timer.cancel();
  //         Navigator.pop(context);
  //         percent = 0.0;
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        duration: Duration(seconds: 20),
        vsync: this);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
    _controller.addStatusListener((status) {
      print(status);
      // if (status == "isCompleted") {
      //   Navigator.pop(context);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.storyContentUrl),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                widget.storyContentUrl != null &&
                        widget.storyImageUrl != null &&
                        widget.storyName != null
                    ? LinearProgressIndicator(
                        value: _controller.value,
                      )
                    : CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.storyImageUrl),
                        radius: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.storyName.toString(),
                        style: TextStyle(
                            fontFamily: "Montserratregular",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
      ),
    
      ),
    );
  }
}
