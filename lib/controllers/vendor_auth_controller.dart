import 'package:automex_store_vendor/global_variables.dart';
import 'package:automex_store_vendor/models/vendor.dart';
import 'package:automex_store_vendor/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class VendorAuthController {
  Future<void> signUpVendor(
      {required String fullName,
      required String email,
      required String password,
      required context}) async {
    try {
      Vendor vendor = Vendor(
          id: '',
          fullName: fullName,
          email: email,
          state: '',
          city: '',
          locality: '',
          role: '',
          password: password);
      http.Response response = await http.post(
          Uri.parse("$uri//api/vendor/signup"),
          body: vendor.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          });
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Vendor Account Created');
          });
    } catch (error) {}
  }
}
