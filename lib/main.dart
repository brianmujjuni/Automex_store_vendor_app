import 'package:automex_store_vendor/provider/vendor_provider.dart';
import 'package:automex_store_vendor/views/screens/authentication/login_screen.dart';
import 'package:automex_store_vendor/views/screens/main_vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> checkTokenAndUser(WidgetRef ref) async {
      //Obtain an instance of sharedPreference
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //retrieve the authentication token and user data stored locally
      String? token = preferences.getString('auth_token');
      String? vendorJson = preferences.getString('vendor');

      //if both the token and the data are available,update the vendor state
      if (token != null && vendorJson != null) {
        ref.read(vendorProvider.notifier).setVendor(vendorJson);
      } else {
        ref.read(vendorProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: checkTokenAndUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final vendor = ref.watch(vendorProvider);
          return vendor != null ? MainVendorScreen() : LoginScreen();
        },
      ),
    );
  }
}
