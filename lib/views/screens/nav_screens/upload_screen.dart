import 'dart:io';

import 'package:automex_store_vendor/controllers/category_controller.dart';
import 'package:automex_store_vendor/controllers/product_controller.dart';
import 'package:automex_store_vendor/controllers/subcategory_controller.dart';
import 'package:automex_store_vendor/models/category.dart';
import 'package:automex_store_vendor/models/subcategory.dart';
import 'package:automex_store_vendor/provider/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  late Future<List<Category>> futureCategories;
  Future<List<Subcategory>>? futureSubcategories;

  Category? selectedCategory;
  Subcategory? selectedSubcategory;

  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;

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

  getSubcategoryByCategory(value) {
    //fetch subcategories based on selected category
    futureSubcategories =
        SubcategoryController().getSubCategoriesByCategoryName(value.name);
    //reset the selected subcategory
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
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
                      onChanged: (value) {
                        productName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product Name";
                        } else {
                          return null;
                        }
                      },
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
                      onChanged: (value) {
                        productPrice = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product Price";
                        } else {
                          return null;
                        }
                      },
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
                      onChanged: (value) {
                        quantity = int.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product Quantity";
                        } else {
                          return null;
                        }
                      },
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
                  //Dropdown to select category
                  // FutureBuilder(
                  //     future: futureCategories,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return Center(child: CircularProgressIndicator());
                  //       } else if (snapshot.hasError) {
                  //         return Text('Error: ${snapshot.error}');
                  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //         return Text('No categories available');
                  //       } else {
                  //         List<Category> categories = snapshot.data!;
                  //         return DropdownButtonFormField<Category>(
                  //           decoration: InputDecoration(
                  //             labelText: 'Select Category',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           value: selectedCategory,
                  //           items: categories.map((Category category) {
                  //             return DropdownMenuItem<Category>(
                  //               value: category,
                  //               child: Text(category.name),
                  //             );
                  //           }).toList(),
                  //           onChanged: (Category? newValue) {
                  //             setState(() {
                  //               selectedCategory = newValue;
                  //             });
                  //             getSubcategoryByCategory(selectedCategory);
                  //           },
                  //         );
                  //       }
                  //     }),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text("No Category"),
                            );
                          } else {
                            return DropdownButton<Category>(
                              value: selectedCategory,
                              hint: Text("Select Category"),
                              items: snapshot.data!.map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                                getSubcategoryByCategory(selectedCategory);
                              },
                            );
                          }
                        }),
                  ),

                  //drop down to select subcategory
                  // FutureBuilder(
                  //     future: futureSubcategories,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return Center(child: CircularProgressIndicator());
                  //       } else if (snapshot.hasError) {
                  //         return Text('Error: ${snapshot.error}');
                  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  //         return Text('No Sub categories available');
                  //       } else {
                  //         List<Subcategory> subcategories = snapshot.data!;
                  //         return DropdownButtonFormField<Subcategory>(
                  //           decoration: InputDecoration(
                  //             labelText: 'Select SubCategory',
                  //             border: OutlineInputBorder(),
                  //           ),
                  //           value: selectedSubcategory,
                  //           items: subcategories.map((Subcategory subcategory) {
                  //             return DropdownMenuItem<Subcategory>(
                  //               value: subcategory,
                  //               child: Text(subcategory.subCategoryName),
                  //             );
                  //           }).toList(),
                  //           onChanged: (Subcategory? newValue) {
                  //             setState(() {
                  //               selectedSubcategory = newValue;
                  //             });
                  //           },
                  //         );
                  //       }
                  //     }),

                  SizedBox(
                    width: 200,
                    child: FutureBuilder<List<Subcategory>>(
                        future: futureSubcategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text('No Category'),
                            );
                          } else {
                            return DropdownButton<Subcategory>(
                              value: selectedSubcategory,
                              hint: Text('Select subcategory'),
                              items:
                                  snapshot.data!.map((Subcategory subcategory) {
                                return DropdownMenuItem<Subcategory>(
                                  value: subcategory,
                                  child: Text(subcategory.subCategoryName),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubcategory = value;
                                });
                              },
                            );
                          }
                        }),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Product description";
                        } else {
                          return null;
                        }
                      },
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                        labelText: 'Enter Product Description',
                        hintText: 'Enter Product Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () async {
                  final fullName = ref.read(vendorProvider)!.fullName;
                  final vendorId = ref.read(vendorProvider)!.id;
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await _productController
                        .uploadProduct(
                            productName: productName,
                            productPrice: productPrice,
                            quantity: quantity,
                            description: description,
                            category: selectedCategory!.name,
                            subCategory: selectedSubcategory!.subCategoryName,
                            pickedImages: images,
                            vendorId: vendorId,
                            fullName: fullName,
                            context: context)
                        .whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                      selectedCategory = null;
                      selectedSubcategory = null;
                      images.clear();
                    });
                  } else {
                    SnackBar(
                      content: Text('All fields are required'),
                      showCloseIcon: true,
                    );
                    // print('hii');
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Upload Product",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.7),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
