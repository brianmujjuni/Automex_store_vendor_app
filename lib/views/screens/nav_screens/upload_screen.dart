import 'dart:io';

import 'package:automex_store_vendor/controllers/category_controller.dart';
import 'package:automex_store_vendor/models/category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    // Call the function to fetch categories when the widget is initialized
    futureCategories = CategoryController().fetchCategories();
  }
  //Create an instance of image picker to handle image selection
  final ImagePicker picker = ImagePicker();
  //initialise an empty list to store the seleted images
  List<File> images = [];
  //function to pick images from the gallery
  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: images.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return index == 0
                ? Center(
                    child: IconButton(
                      onPressed: () {
                        chooseImage();
                      },
                      icon: Icon(Icons.add),
                    ),
                  )
                : SizedBox(
                    width: 50,
                    height: 40,
                    child: Image.file(images[index - 1]),
                  );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Product Name',
                    hintText: 'Enter Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Product Price',
                    hintText: 'Enter Product Price',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Product Quantity',
                    hintText: 'Enter Product Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Enter Product Description',
                    hintText: 'Enter Product Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
