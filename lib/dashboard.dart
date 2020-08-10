import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
var currDt = DateTime.now();
var user_post_data = [
  {
    "name":"Cafe and Restaurant",
    "spent":"€200",
    "total": "/€300",
    "icons": Icons.free_breakfast.codePoint,
  },
  {
    "name":"Food",
    "spent":"€150",
    "total": "/€1000",
    "icons": Icons.fastfood.codePoint,
  },
  {
    "name":"Home Expenses",
    "spent":"€150",
    "total": "/€400",
    "icons": Icons.home.codePoint,
  },
  {
    "name":"Education",
    "spent":"€150",
    "total": "/€1000",
    "icons": Icons.school.codePoint,
  },
];

String _remainingBudget = "0";
String _totalBudget = "0";
String _currencySymbol = "\$";
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardCode(),
    );
  }
}
var year = "Loading";
var month = "Loading";
class DashboardCode extends StatefulWidget {
  @override
  _DashboardCodeState createState() => _DashboardCodeState();
}

class _DashboardCodeState extends State<DashboardCode> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];
  FirebaseUser user;
  void getPostsData() async{
    FirebaseUser userData = await FirebaseAuth.instance.currentUser();
    setState(() {
      user = userData;
      //print(userData.email);
    });
    List<Widget> listItems = [];
    List months = ['January ', 'February', 'March ', "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    print(currDt.year);
    print(currDt.month);
    print(months[currDt.month - 1]);
    month = (months[currDt.month - 1]).toString();
    year = currDt.year.toString();
    final QuerySnapshot result = await Firestore.instance.collection('Categories').where("userEmail", isEqualTo:"${user?.email}").getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    //fetching budget info
    Firestore.instance.collection("Budgets").where("userEmail", isEqualTo: "${user?.email}").getDocuments()
        .then((querySnapshot) {
          querySnapshot.documents.forEach((result) {
            print(result.data);
            _totalBudget = result.data["total_budget"].toString();
            _remainingBudget = result.data["remaining_budget"].toString();
            _currencySymbol = result.data["currency_symbol"];
          });
          print(_remainingBudget);
          print(_totalBudget);
          print(_currencySymbol);
    })
    .catchError((e)=>print(e));
    documents.forEach((data) {
      listItems.add(
        GestureDetector(
          onTap: (){
            print(data["category_title"]);
            return showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(data["category_title"],style: TextStyle(color: Colors.black),),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        //Text(data["content"]),
                        Row(
                          children: <Widget>[
                            Text(
                              data["currency_symbol"]+data["category_budget_remaining"].toString(),
                              style: const TextStyle(fontSize: 20, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "/"+data["currency_symbol"]+data["category_budget_total"].toString(),
                              style: const TextStyle(fontSize: 20, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Text("   "),
                            Icon(IconData(data["icon"], fontFamily: 'MaterialIcons'), color: Colors.black,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.greenAccent,
                      child: Text('Close', style: TextStyle(color: Colors.black),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0)), color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 5.0),
              ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 200,
                          child: Text(
                            data["category_title"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              data["currency_symbol"]+data["category_budget_remaining"].toString(),
                              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "/"+data["currency_symbol"]+data["category_budget_total"].toString(),
                              style: const TextStyle(fontSize: 20, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Icon(IconData(data["icon"], fontFamily: 'MaterialIcons')),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    /*Icon(
                  Icons.school,
                  color: Colors.green,
                  size: 30.0,
                ),*/
                  ],
                ),
              )),
        )
          );
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset/119;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.greenAccent,width: 2),
                        color: Colors.greenAccent
                    ),
                    child: Text("$month" + ", $year", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: categoriesScroller
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return itemsData[index];
                      },

                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Text("Balance",style: TextStyle(fontSize: 20, color: Colors.grey),),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: "$_currencySymbol"+_remainingBudget, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 60),),
                    TextSpan(text: "/"+"$_currencySymbol"+_totalBudget, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),)
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}