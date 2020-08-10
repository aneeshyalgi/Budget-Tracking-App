import 'package:budget_tracking_app/mainApp.dart';
import 'package:flutter/material.dart';
import 'introPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
FirebaseAuth auth = FirebaseAuth.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = new Introduction_screen();
  if (await auth.currentUser() == null) {
    _defaultHome = new Introduction_screen();
  }
  else{
    _defaultHome = new mainApp();
  }
  runApp(
      MaterialApp(
        home: _defaultHome,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      ));
}
