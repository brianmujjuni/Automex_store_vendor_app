import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';

class ProductController {
  void uploadProduct(
      {required String productName,
      required int productPrice,
      required int quantity,
      required String description,
      required String category,
      required String subCategory,
      required List<File>? pickedImages,
      required String vendorId,
      required String fullName}) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic("automex", "automex store");
      List<String> images = [];
      //loop through each image on the pickedimage list
      for (var i = 0; i < pickedImages.length; i++) {
        //await the upload of the current image to cloudinary
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(pickedImages[i].path, folder: productName),
        );
        //add the secure url to the images list

        images.add(cloudinaryResponse.secureUrl);
      }
      print(images);
    }
  }
}
