import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
class addSpend extends StatefulWidget {
  @override
  _addSpendState createState() => _addSpendState();
}

class _addSpendState extends State<addSpend> {

  final expenseName = TextEditingController();
  final expenseAmount = TextEditingController();
  var _queryCat;
  var _category;
  var _totalCategoryBudget;
  var _remainingCategoryBudget;
  var _remainingCategoryBudget2;
  var selectedCategory;
  var _value;

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
      appBar: new AppBar(
        title: new Text("Add new Expense", style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
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
                  decoration: InputDecoration(labelText: "Expense Name"),
                  controller: expenseName,
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Add Amount"),
                  controller: expenseAmount,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 40,
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Text("Choose Group:", style: TextStyle(fontSize: 18),),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection("Categories").where("userEmail", isEqualTo: "${user?.email}").snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            const Text("Loading.....");
                          else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 50.0),
                                DropdownButton(
                                  items: snapshot.data.documents.map((DocumentSnapshot document) {
                                    return new DropdownMenuItem<String>(
                                        value: document.data['category_title'],
                                        child: new Container(
                                          child: new Text(document.data['category_title']),
                                        )
                                    );
                                  }).toList(),
                                  onChanged: (categoryValue) {
                                    setState(() {
                                      selectedCategory = categoryValue;
                                      print(selectedCategory);
                                    });
                                  },
                                  value: selectedCategory,
                                ),
                              ],
                            );
                          }
                          return Container(width: 0.0,height: 0.0,);
                        }),
                  ],
                ),
                SizedBox(
                  height: 150.0,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: new ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: new RaisedButton.icon(
                        onPressed: (){
                          print(selectedCategory);
                          Firestore.instance.collection("Budgets").where("userEmail", isEqualTo: "${user?.email}").getDocuments()
                          .then((querySnapshot) {
                            querySnapshot.documents.forEach((result) {
                              print(result.data);
                              _value = result.data["currency_symbol"];
                              Firestore.instance.collection("Categories").where("userEmail", isEqualTo: "${user?.email}").where("category_title", isEqualTo: selectedCategory).getDocuments()
                                  .then((querySnapshot){
                                querySnapshot.documents.forEach((result) {
                                  print(result.data);
                                  _totalCategoryBudget = result.data["category_budget_total"];
                                  _remainingCategoryBudget = result.data["category_budget_remaining"];
                                  _remainingCategoryBudget2 = (_remainingCategoryBudget - (int.parse(expenseAmount.text)));
                                  print(_remainingCategoryBudget);
                                  if(selectedCategory == null){
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      title:  "Error! ",
                                      message:  "Please choose a category. ",
                                      duration:  Duration(seconds: 3),
                                    )..show(context);
                                  }
                                  else if(_remainingCategoryBudget <= 0){
                                    print("error 2.0");
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      title:  "Error! ",
                                      message:  "You cannot add more expenses to this as your budget is finished. ",
                                      duration:  Duration(seconds: 3),
                                    )..show(context);
                                  }
                                  else if (_totalCategoryBudget < (int.parse(expenseAmount.text)) && _remainingCategoryBudget < (int.parse(expenseAmount.text))){
                                    print("error");
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      title:  "Error! ",
                                      message:  "The number you have entered has exceeded your budget. ",
                                      duration:  Duration(seconds: 3),
                                    )..show(context);
                                  }
                                  else if (_remainingCategoryBudget2 < 0){
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      title:  "Error!",
                                      message:  "The value you have entered will make your remaining group budget negative. ",
                                      duration:  Duration(seconds: 5),
                                    )..show(context);
                                  }
                                  else{
                                    print(selectedCategory);
                                    Firestore.instance.collection('Expenses').document()
                                        .setData({ 'expense_title': expenseName.text, 'expense_budget_total': (int.parse(expenseAmount.text)), "userEmail":"${user?.email}", "Category":selectedCategory, "currency_symbol": _value })
                                        .then((value){
                                      Firestore.instance.collection("Categories").where("userEmail", isEqualTo: "${user?.email}").where("category_title", isEqualTo: selectedCategory).getDocuments().then((value){
                                        value.documents.forEach((element) {
                                          element.reference.updateData({"category_budget_remaining":_remainingCategoryBudget2}).then((value) =>
                                          Flushbar(
                                            backgroundColor: Colors.greenAccent,
                                            title:  "Expense Successfully Added! ",
                                            message:  "You can add multiple expenses in one group. ",
                                            duration:  Duration(seconds: 3),
                                          )..show(context)
                                          );
                                        });
                                      });
                                    })
                                        .catchError((e){print(e);});
                                  }
                                });
                              }).catchError((e){print(e);});
                            });
                          })
                          .catchError((e)=>print(e));

                        },
                        color: Colors.greenAccent,
                        textColor: Colors.white,
                        icon: Icon(Icons.done),
                        label: new Text("Add Expense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
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
