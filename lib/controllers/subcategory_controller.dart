import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:automex_store_vendor/models/subcategory.dart';
import 'package:automex_store_vendor/global_variables.dart';


class SubcategoryController {
  Future<List<Subcategory>> getSubCategoryByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/$categoryName/subcategories"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          });
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
