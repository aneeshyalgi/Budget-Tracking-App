import 'package:flutter/material.dart';
import 'mainApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class setBudget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: setBudget(),
    );
  }
}

class setBudget extends StatefulWidget {
  @override
  _setBudgetState createState() => _setBudgetState();
}

class _setBudgetState extends State<setBudget> {

  final amount = TextEditingController();
  String _value = "USD";
  var catAmount;
  var expenseAmount;
  FirebaseUser user;
  Future <void> getUserData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      print(userData.email);
    });
  }
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Set Budget", style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
      ),

      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.greenAccent,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Set Amount"),
                  controller: amount,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                new Text("Select Currency: ", style: TextStyle(fontSize: 18),),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: DropdownButton(
                      value: _value,
                      items: [
                        DropdownMenuItem(
                          child: Text("USD"),
                          value: "USD",
                        ),
                        DropdownMenuItem(
                          child: Text("Euros"),
                          value: "€",
                        ),
                        DropdownMenuItem(
                            child: Text("Indian Rupees"),
                            value: "₹",
                        ),
                        DropdownMenuItem(
                            child: Text("Pounds"),
                            value: "£",
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      }),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: new ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: new RaisedButton.icon(
                        onPressed: (){
                          catAmount = (int.parse(amount.text)) - 10;
                          expenseAmount = catAmount - 15;
                          if (catAmount < 0 && expenseAmount < 0){
                            catAmount = 10;
                            expenseAmount = 5;
                          }
                          if ((int.parse(amount.text)) <= 20){
                            Flushbar(
                              backgroundColor: Colors.red,
                              title:  "Error!",
                              message:  "Please enter a value greater than $_value 20. ",
                              duration:  Duration(seconds: 5),
                            )..show(context);
                          }
                          else{
                            if (_value == "USD"){
                              _value = "\$";
                            }
                            if ((int.parse(amount.text)) >= 50){
                              catAmount = 20;
                              expenseAmount = 8;
                            }
                            var remainingBudget = (int.parse(amount.text)) - catAmount;
                            var remainingCatBudget = catAmount - expenseAmount;
                            Firestore.instance.collection('Budgets').document("${user?.email}")
                                .setData({ 'total_budget': (int.parse(amount.text)), 'remaining_budget': remainingBudget, 'currency_symbol': _value, "userEmail" : "${user?.email}",})
                                .then((value){
                              //Navigator.of(context).pop();Navigator.of(context).push(MaterialPageRoute(builder: (context) => mainApp()));
                              Firestore.instance.collection('Categories').document()
                                  .setData({"category_title": "Birthday Gifts", "category_budget_total": catAmount, "category_budget_remaining": remainingCatBudget, "icon": 59638, "userEmail":"${user?.email}", 'currency_symbol': _value})
                                  .then((value) {
                                Firestore.instance.collection('Expenses').document()
                                    .setData({'expense_title': "Lego Set", 'expense_budget_total': expenseAmount, "userEmail":"${user?.email}", "Category":"Birthday Gifts", 'currency_symbol': _value})
                                    .then((value){Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (context) => mainApp()));})
                                    .catchError((e){print(e);});
                              })
                                  .catchError((e) {print(e);});
                            })
                                .catchError((e){print(e);});
                          }
                          //
                        },
                        color: Colors.greenAccent,
                        textColor: Colors.white,
                        icon: Icon(Icons.done),
                        label: new Text("Set Budget", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
