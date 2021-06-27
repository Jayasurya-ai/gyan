import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class Bann extends StatefulWidget {
  File imaged;
  Bann(this.imaged);
 
  @override
  _BannState createState() => _BannState();
}

class _BannState extends State<Bann> {
   final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color:  Colors.black,
      child:Crop(
        key:cropKey,
        image: FileImage(widget.imaged),
        aspectRatio: 4.0 / 3.0,
      )
    ));
  }
}
