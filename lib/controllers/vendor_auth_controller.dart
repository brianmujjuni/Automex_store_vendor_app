import 'dart:convert';

import 'package:automex_store_vendor/global_variables.dart';
import 'package:automex_store_vendor/models/vendor.dart';
import 'package:automex_store_vendor/services/manage_http_response.dart';
import 'package:automex_store_vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter/material.dart';
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
        Uri.parse("$uri/api/vendor/signup"),
        body: vendor.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Vendor Account Created');
          });
    } catch (error) {
      showSnackBar(context, '$error');
    }
  }

  //function to consume the backend vendor signin api
  Future<void> signInVendor(
      {required String email,
      required String password,
      required context}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return MainVendorScreen();
            }), (route) => false);
            showSnackBar(context, 'Logged In Successfully');
          });
    } catch (error) {
      showSnackBar(context, '$error');
    }
  }
}
