import 'dart:io';
import 'package:automex_store_vendor/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:automex_store_vendor/models/product.dart';
import 'package:automex_store_vendor/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class ProductController {
  Future<void> uploadProduct(
      {required String productName,
      required int productPrice,
      required int quantity,
      required String description,
      required String category,
      required String subCategory,
      required List<File>? pickedImages,
      required String vendorId,
      required String fullName,
      required context}) async {
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
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final Product product = Product(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          subCategory: subCategory,
          images: images,
          vendorId: vendorId,
          fullName: fullName,
        );
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-product"),
          body: product.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
        );
        manageHttpResponse(
            response: response,
            context: context,
            onSuccess: () {
              showSnackBar(context, 'Product saved successfully');
            });
      } else {
        showSnackBar(context, 'Fill all fields');
        // print('failed');
      }
    } else {
      showSnackBar(context, 'Select image');
    }
  }
}
