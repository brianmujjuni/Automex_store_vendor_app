import 'dart:convert';
import 'package:automex_store_vendor/global_variables.dart';
import 'package:automex_store_vendor/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  
  //fetch categories from server
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("$uri/api/categories"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
        
          
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories =
            data.map((category) => Category.fromJson(category)).toList();
        return categories;
      }else{
        throw Exception("Failed to load categories");
      }
    } catch (err) {
      throw Exception("Error loading categories: $err");
    }
  }
}
