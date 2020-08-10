import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
var currDt = DateTime.now();
const user_post_data = [
  {
    "name":"Version 2.0 is out",
    "date":"2/20/2020",
    "Category": "Home Expenses"
  },
  {
    "name":"You have exceeded your budget by €20",
    "date":"2/20/2020",
    "Category": "Home Expenses"
  },
  {
    "name":"Get premium subscription",
    "date":"2/20/2020",
    "Category": "Food"
  },
];
class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotificationsCode(),
    );
  }
}
var year = "Loading";
var month = "Loading";
class NotificationsCode extends StatefulWidget {
  @override
  _NotificationsCodeState createState() => _NotificationsCodeState();
}

class _NotificationsCodeState extends State<NotificationsCode> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() async{
    List<dynamic> responseList = user_post_data;
    List<Widget> listItems = [];
    final QuerySnapshot result = await Firestore.instance.collection('Alerts').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    List months = ['January ', 'February', 'March ', "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    print(currDt.year);
    print(currDt.month);
    print(months[currDt.month - 1]);
    month = (months[currDt.month - 1]).toString();
    year = currDt.year.toString();
    documents.forEach((post) {
      listItems.add(
          GestureDetector(
            onTap: (){
              print(post["name"]);
              return showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(post["name"],style: TextStyle(color: Colors.black),),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(post["content"],style: TextStyle(color: Colors.black),),
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
                            post["name"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          post["date"].toString(),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    /*Image.asset(
                  "assets/images/${post["image"]}",
                  height: double.infinity,
                )*/
                  ],
                ),
              ),),
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
        closeTopContainer = controller.offset > 50;
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
            Icons.notifications,
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
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return itemsData[index];
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

