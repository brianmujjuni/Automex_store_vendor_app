import 'package:automex_store_vendor/models/vendor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//SateNotifier: StateNotifier is a class that allows you to manage the state of your application in a more structured way. It is part of the Riverpod package, which is a popular state management solution for Flutter applications.
class VendorProvider extends StateNotifier<Vendor?> {
  VendorProvider()
      : super(Vendor(
          id: '',
          fullName: '',
          email: '',
          state: '',
          city: '',
          locality: '',
          role: '',
          password: '',
        ));
  //Getter Method to extract the vendor data
  Vendor? get vendor => state;
  //Method to set user state from json
  //purpose: updates user state based on json string representation of the user vendor object
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  //method to clear the vendor user state
  void signOut() {
    state = null;
  }
}
//make the data accessible to the entire app
final vendorProvider = StateNotifierProvider<VendorProvider, Vendor?>((ref) {
  return VendorProvider();
});
