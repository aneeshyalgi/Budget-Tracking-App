import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:flushbar/flushbar.dart';
class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {

  FirebaseUser user;
  Future <void> getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
    });
  }
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: new ListView(
        padding: const EdgeInsets.all(20.0),
        //shrinkWrap: true,
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),
          Text(
            "Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          new ButtonTheme(
            minWidth: 150.0,
            height: 50.0,
            child: new RaisedButton(
              onPressed: (){
                print("${user?.email}");
                FirebaseAuth.instance.sendPasswordResetEmail(email: "${user?.email}").then((value){
                  Flushbar(
                    backgroundColor: Colors.greenAccent,
                    title:  "Email Sent Successfully! ",
                    message:  "Check your inbox. Sometimes the email will land up in your Junk or Spam Folder. ",
                    duration:  Duration(seconds: 5),
                  )..show(context);
                }).catchError((e){print(e);});
              },
              color: Colors.greenAccent,
              textColor: Colors.white,
              child: Column(
                children: <Widget>[
                  new Text("Reset Password", style: TextStyle(fontSize: 20, letterSpacing: 2),)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          new ButtonTheme(
            minWidth: 150.0,
            height: 50.0,
            child: new RaisedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              color: Colors.greenAccent,
              textColor: Colors.white,
              child: Column(
                children: <Widget>[
                  new Text("Log Out", style: TextStyle(fontSize: 20, letterSpacing: 2),)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          new ButtonTheme(
            minWidth: 150.0,
            height: 50.0,
            child: new RaisedButton(
              onPressed: (){
                print("h");
              },
              color: Colors.greenAccent,
              textColor: Colors.white,
              child: Column(
                children: <Widget>[
                  new Text("Version Info", style: TextStyle(fontSize: 20, letterSpacing: 2),)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
