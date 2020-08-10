import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'mainApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'setBudget.dart';


class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(seconds: 3);



  @override
  Widget build(BuildContext context) {

    Future<String> _logIn(LoginData data) {
      print('Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) async {
        FirebaseAuth.instance.signInWithEmailAndPassword(email: data.name, password: data.password)
            .then((signedInUser){Navigator.of(context).pop();Navigator.of(context).push(MaterialPageRoute(builder: (context) => mainApp()));})
            .catchError((e){
          print(e);
          showDialog(context: context, builder: (BuildContext context){
             return AlertDialog(title: new Text("Authentication Error!", style: TextStyle(color: Colors.red),), content:new Text("The account you entered does not exist. \nTap anyware to dismiss.", style: TextStyle(color: Colors.red)),);});
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
            });
        return null;
      });
    }

    Future<String> _signUp(LoginData data) {
      print('Name: ${data.name}, Password: ${data.password}');
      return Future.delayed(loginTime).then((_) async {
        if((data.password).length < 7){
          return "Password must be greater than 7 characters";
        }
        FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.name, password: data.password)
            .then((signedInUser){
          Firestore.instance.collection("Users").document(data.name).setData({"email": data.name}).then((signedInUser){Navigator.of(context).pop();Navigator.of(context).push(MaterialPageRoute(builder: (context) => setBudget1()));}).catchError((e){print(e);});
        })
            .catchError((e){print(e); showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(title: new Text("Authentication Error!", style: TextStyle(color: Colors.red),), content:new Text("The Email you have entered already exists. \nTap anyware to dismiss.", style: TextStyle(color: Colors.red)),);});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
            });
        return null;
      });
    }

    Future<String> _recoverPassword(String name) {
      print('Name: $name');
      return Future.delayed(loginTime).then((_) {

        return null;
      });
    }




    return FlutterLogin(
      title: 'Digital Wallet',
      //logo: 'assets/digital_wallet_icon.png',
      onLogin: _logIn,
      onSignup: _signUp,
      onSubmitAnimationCompleted: () {

      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: Colors.greenAccent,
        accentColor: Colors.greenAccent,
        cardTheme: CardTheme(
          elevation: 10,
          color: Colors.white,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.greenAccent.withOpacity(0.9),
        shadows: [
          Shadow(
            offset: Offset(5.0, 1.0),
            blurRadius: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          Shadow( // bottomLeft
              offset: Offset(-2.5, -2.5),
              color: Colors.black
          ),
          Shadow( // bottomRightmain_app.dart
              offset: Offset(2.5, -2.5),
              color: Colors.black
          ),
          Shadow( // topRight
              offset: Offset(2.5, 2.5),
              color: Colors.black
          ),
          Shadow( // topLeft
              offset: Offset(-2.5, 2.5),
              color: Colors.black
          ),
        ],
          fontFamily: 'Quicksand',
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.greenAccent.withOpacity(0.3),

        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.green,
          elevation: 5.0,
          highlightElevation: 6.0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          backgroundColor: Colors.greenAccent
        ),
      ),
    );
  }
}