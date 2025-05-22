import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  //Create an instance of image picker to handle image selection
  final ImagePicker picker = ImagePicker();
  //initialise an empty list to store the seleted images
  List<File> images = [];
  //function to pick images from the gallery
  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      print('No image selected');
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Uploas Screen'),
    );
  }
}
