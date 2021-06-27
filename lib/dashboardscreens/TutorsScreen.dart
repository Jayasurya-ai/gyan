

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:gyan/TutorRegistrationScreen.dart';
class TutorsScreen extends StatefulWidget {
  const TutorsScreen({Key key}) : super(key: key);

  @override
  _TutorsScreenState createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {

  final storePath=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
       children: [
         ClipPath(
           clipper: BackGroundClipper(),
           child: Container(
             height:120,
             color: Color(0xffF05D0C),

             width: MediaQuery.of(context).size.width,
             child: Center(
               child: Text(
                 "Tutors Spot",
                 style: TextStyle(
                   fontSize: 23,
                   color: Colors.white,
                   fontFamily: "Montserratregular",
                   fontWeight: FontWeight.bold
                 ),

               ),
             ),


           ),
         ),
         Flexible(
           child: StreamBuilder<QuerySnapshot>(
             stream: storePath.collection("Tutors").snapshots(),
             builder: (context,snapshot){

               if(!snapshot.hasData){
                 return Center(child: CircularProgressIndicator());
               }
               return ListView.builder(
                 shrinkWrap: true,
                 itemCount: snapshot.data.docs.length,
                   itemBuilder:(context,index){
                     var data=snapshot.data.docs[index];
                     String rate=data["rating"];
                     double rating=double.parse(rate);
                     var docId = snapshot.data.docs[index].id;

                     return Padding(
                       padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                       child: GestureDetector(
                         onTap: () {
                           if (double.parse(data["registrationsLimit"]) > 1.0) {
                             Navigator.push(context, PageRouteBuilder(


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
                                   return TutorRegistrationScreen(
                                       courseName: data["courseName"],
                                       tutorDescription: data["tutorDescription"],
                                       tutorExperience: data["tutorExperience"],
                                       tutorName: data["tutorName"],
                                       tutorImageUrl: data["tutorImageUrl"],
                                       rating: double.parse(data["rating"]),
                                       batchNumber: data["batchNumber"],
                                       documentID: docId,
                                       registrationLimit: data["registrationsLimit"]);
                                 }
                             ));
                           }
                         },
                         child: Container(
                           height: 120,
                           child: Card(
                             elevation: 5,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(25),
                             ),
                             color:double.parse(data["registrationsLimit"])>1.0? Colors.white:Color(0xffddddddd),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(20),

                                     child: Container(
                                       child: Image.network(data["tutorImageUrl"],height: 100,width: 80,),

                                     ),
                                   ),
                                 ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Flexible(
                                       child: Text(
                                         data["tutorName"],
                                         softWrap: true,
                                         textAlign: TextAlign.start,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color: Color(0xff393e46),
                                           fontFamily: "Montserratregualar"
                                         ),
                                       ),
                                     ),
                                     SizedBox(
                                       height: 5,
                                     ),
                                     Text(
                                       data["courseName"],
                                       style: TextStyle(
                                         fontFamily: "Montserratregular",
                                         fontSize: 15,
                                         color:  Color(0xff393e46).withOpacity(0.5),
                                         fontWeight: FontWeight.bold
                                       ),
                                     ),
                                     SizedBox(
                                       height: 5,
                                     ),
                                     Row(
                                       children: [
                                         RatingBar(
                                           rating: rating,
                                           icon:Icon(Icons.star,size:20,color: Colors.grey,),
                                           starCount: 5,
                                           spacing: 5.0,
                                           size: 20,
                                           isIndicator: false,
                                           allowHalfRating: true,
                                           // onRatingCallback: (double value,ValueNotifier<bool> isIndicator){
                                           //   //change the isIndicator from false  to true ,the       RatingBar cannot support touch event;
                                           //   isIndicator.value=true;
                                           // },
                                           color: Colors.amber,
                                         ),
                                         SizedBox(
                                           width: 5,
                                         ),
                                         Text(
                                           data["rating"].toString(),
                                           style: TextStyle(
                                             color: Colors.grey.withOpacity(0.6),
                                             fontWeight: FontWeight.bold,
                                             fontSize: 18,
                                             fontFamily: "Montserratregualar"
                                           ),
                                         )

                                       ],
                                     ),
                                     Card(
                                       elevation: 6,
                                       color:double.parse(data["registrationsLimit"])<=10.0?Colors.red:Color(0xff47a626),
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(20),
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(4.0),
                                         child:double.parse(data["registrationsLimit"])>1.0? Text(
                                           "Seats left: ${data["registrationsLimit"]}",
                                           style: TextStyle(
                                               color:Colors.white,
                                               fontSize: 12,
                                               fontWeight: FontWeight.bold
                                           ),

                                         ):
                                             Text(
                                               "Seats Closed",
                                               style: TextStyle(
                                                   color:Colors.white,
                                                   fontSize: 12,
                                                   fontWeight: FontWeight.bold
                                               ),

                                             )
                                       ),
                                     )

                                   ],
                                 ),
                                 Container(
                                   width: 30,
                                   height: 120,
                                   decoration: BoxDecoration(
                                     color: Colors.orange,
                                     borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                                   ),
                                   child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Wrap(
                                       alignment: WrapAlignment.center,
                                       direction: Axis.vertical,
                                       children:[
                                         RotatedBox(quarterTurns: 1,child:
                                         Text(
                                         data["batchNumber"].toString(),
                                         style: TextStyle(
                                           fontSize: 15,
                                           fontFamily: "Montserratregular",
                                           color: Colors.black,
                                           fontWeight: FontWeight.bold
                                         ),
                                       ),
                                         )
                                     ]
                                     ),
                                   ),

                                 )
                               ],
                             ),
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

class BackGroundClipper extends CustomClipper<Path>{

  @override
  getClip(Size size) {
    Path path=Path();
    path.lineTo(0, size.height-30);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-30);
    path.lineTo(size.width,0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
   return true;
  }


}





