import 'package:automex_store_vendor/controllers/vendor_auth_controller.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorAuthController _vendorAuthController = VendorAuthController();
  bool isLoading = false;
  late String email;
  late String fullName;
  late String password;
  registerVendor() async {
    setState(() {
      isLoading = true;
    });
    await _vendorAuthController
        .signUpVendor(
            fullName: fullName,
            email: email,
            password: password,
            context: context)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
