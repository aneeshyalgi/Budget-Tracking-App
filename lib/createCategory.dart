import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
class createCategoryCode extends StatefulWidget {
  @override
  _createCategoryCodeState createState() => _createCategoryCodeState();
}

class _createCategoryCodeState extends State<createCategoryCode> {

  final categoryName = TextEditingController();
  final categoryBudget = TextEditingController();
  var _icon;
  var _totalBudget;
  var _remaining_budget;
  var _remaining_budget2;
  var _iconColor = Colors.black;
  var catTitle;
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

  _showIconGrid() {
    var ls = [
      Icons.weekend,
      Icons.whatshot,
      Icons.widgets,
      Icons.wifi,
      Icons.wifi_lock,
      Icons.wifi_tethering,
      Icons.work,
      Icons.straighten,
      Icons.style,
      Icons.theaters,
      Icons.train,
      Icons.tram,
      Icons.restaurant_menu,
      Icons.restore,
      Icons.restore_from_trash,
      Icons.restore_page,
      Icons.spa,
      Icons.room,
      Icons.smoking_rooms,
      Icons.room_service,
      Icons.face,
      Icons.fastfood,
      Icons.favorite_border,
      Icons.home,
      Icons.school,
      Icons.done_outline,
      Icons.event_seat,
      Icons.flight,
      Icons.flight_land,
      Icons.flight_takeoff,
      Icons.sd_card,
      Icons.card_giftcard,
      Icons.router,
      Icons.pets,
      Icons.store,
      Icons.local_gas_station,
      Icons.local_grocery_store,
      Icons.toys,
      Icons.directions_car,
      Icons.add_shopping_cart
    ];

    return GridView.count(
      crossAxisCount: 8,
      children: List.generate(ls.length, (index) {
        var iconData = ls[index];
        return IconButton(
            onPressed: () {
              //_iconColor = Colors.greenAccent;
              _icon = iconData.codePoint;
              print(_icon);
            },
            color: _iconColor,
            icon: Icon(
              iconData,
            )
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Create New Group", style: TextStyle(color: Colors.black),),
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
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.greenAccent,
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Group Title"),
                      controller: categoryName,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Set Group Budget"),
                      controller: categoryBudget,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    new Text("Set Icon", style: TextStyle(fontSize: 25),),
                    Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: _showIconGrid())),
                    new ButtonTheme(
                      minWidth: 150.0,
                      height: 50.0,
                      child: new RaisedButton.icon(
                        onPressed: () async{
                          var enteredName = categoryName.text;
                          print("${user?.email}");
                          Firestore.instance.collection("Budgets").where("userEmail", isEqualTo: "${user?.email}").getDocuments()
                              .then((querySnapshot) {
                            querySnapshot.documents.forEach((result) {
                              print(result.data);
                              _value = result.data["currency_symbol"];
                            });
                          })
                              .catchError((e)=>print(e));
                          Firestore.instance.collection("Categories").where("userEmail", isEqualTo: "${user?.email}").where("category_title", isEqualTo: categoryName.text).getDocuments()
                          .then((querySnapshot){
                            querySnapshot.documents.forEach((result) {
                              catTitle = result.data["category_title"];
                              print("Here: "+result.data["category_title"]);
                            });
                          }).catchError((e){print(e);});
                          var result = await Firestore.instance.collection("Categories")
                              .where("userEmail", isEqualTo: "${user?.email}")
                              .where("category_title", isEqualTo: categoryName.text)
                              .getDocuments();
                          if (result.documents.length == 0) {
                            Firestore.instance.collection("Budgets").where("userEmail", isEqualTo: "${user?.email}").getDocuments()
                                .then((querySnapshot) {
                              querySnapshot.documents.forEach((result) {
                                print(catTitle);
                                _totalBudget = result.data["total_budget"];
                                _remaining_budget = result.data["remaining_budget"];
                                _remaining_budget2 = (_remaining_budget - (int.parse(categoryBudget.text)));
                                print(_totalBudget);
                                print(_remaining_budget);
                                print((int.parse(categoryBudget.text)));
                                if (_remaining_budget <=0){
                                  print("error 2.0");
                                  Flushbar(
                                    backgroundColor: Colors.red,
                                    title:  "Error! ",
                                    message:  "You cannot create more groups as your budget is finished. ",
                                    duration:  Duration(seconds: 3),
                                  )..show(context);
                                }
                                else if (_totalBudget < (int.parse(categoryBudget.text))&& _remaining_budget < (int.parse(categoryBudget.text))){
                                  print("error");
                                  Flushbar(
                                    backgroundColor: Colors.red,
                                    title:  "Error!",
                                    message:  "The number you have entered has exceeded your budget. ",
                                    duration:  Duration(seconds: 5),
                                  )..show(context);
                                }
                                else if (_remaining_budget2 < 0){
                                  Flushbar(
                                    backgroundColor: Colors.red,
                                    title:  "Error!",
                                    message:  "The group budget you entered will make your total budget a negative figure. ",
                                    duration:  Duration(seconds: 5),
                                  )..show(context);
                                }
                                else if (_icon == null){
                                  Flushbar(
                                    backgroundColor: Colors.red,
                                    title:  "Error!",
                                    message:  "Please Select an Icon. ",
                                    duration:  Duration(seconds: 5),
                                  )..show(context);
                                }
                                else{
                                  print(_remaining_budget2);
                                  Firestore.instance.collection('Categories').document()
                                      .setData({ 'category_title': categoryName.text, 'category_budget_total': (int.parse(categoryBudget.text)), 'category_budget_remaining': (int.parse(categoryBudget.text)), "icon":_icon, "userEmail":"${user?.email}", "currency_symbol": _value})
                                      .then((value){})
                                      .catchError((e){print(e);});
                                  Firestore.instance.collection("Budgets").document("${user?.email}").updateData({"remaining_budget": _remaining_budget2}).then((value){
                                    Flushbar(
                                      backgroundColor: Colors.greenAccent,
                                      title:  "Group Successfully Created",
                                      message: "You can add multiple expenses in a group. ",
                                      duration:  Duration(seconds: 3),
                                    )..show(context);
                                  });
                                }
                              });
                            });
                          }
                          else {
                            Flushbar(
                              backgroundColor: Colors.red,
                              title:  "Error!",
                              message: "You already have a Group named $enteredName. ",
                              duration:  Duration(seconds: 3),
                            )..show(context);
                          }
                        },
                        color: Colors.greenAccent,
                        textColor: Colors.white,
                        icon: Icon(Icons.done),
                        label: new Text("Create Group", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}