import 'package:flutter/material.dart';
import 'createCategory.dart';
import 'addSpend.dart';

class chooseOption extends StatefulWidget {
  @override
  _chooseOptionState createState() => _chooseOptionState();
}

class _chooseOptionState extends State<chooseOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: new Container(
        alignment: Alignment.center,
        child: new Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 300,
              ),
              new ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: new RaisedButton.icon(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => createCategoryCode()));
                  },
                  color: Colors.greenAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.dashboard),
                  label: new Text("Create new Group", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              new ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: new RaisedButton.icon(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => addSpend()));
                  },
                  color: Colors.greenAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.attach_money),
                  label: new Text("Add New Expense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
