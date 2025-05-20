import 'dart:convert';

import 'package:automex_store_vendor/global_variables.dart';
import 'package:automex_store_vendor/models/vendor.dart';
import 'package:automex_store_vendor/provider/vendor_provider.dart';
import 'package:automex_store_vendor/services/manage_http_response.dart';
import 'package:automex_store_vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

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
          onSuccess: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            //Extract the token from the response and save it in shared preferences
            String token = jsonDecode(response.body)['token'];
            //save the token in shared preferences
           await preferences.setString('auth_token', token);
            //Encode the user data received from the backend to json
            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);
            //update the application state with the vendor data
            providerContainer
                .read(vendorProvider.notifier)
                .setVendor(vendorJson);
            //store the data in shared preferences
            await preferences.setString('vendor', vendorJson);
            
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
