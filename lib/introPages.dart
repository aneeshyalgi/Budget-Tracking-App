import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login_page.dart';

class Introduction_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen1()),
    );*/
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 300.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 25.0,);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //pageColor: Color(0xFF4C4B4B),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Digital Wallet",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Swipe to Continue ", style: bodyStyle),
            ],
          ),
          image: _buildImage('digital_wallet_icon'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Set a Budget",
          body:
          "Set a monthly budget and we will make sure you do not overspend.",
          image: _buildImage('setBudget'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "View Expenses",
          body:
          "You can view your spending habits in a clean looking interface.",
          image: _buildImage('viewSpends'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create Groups",
          body:
          "You can create groups for certain types of expenses, to make it easier to track.",
          image: _buildImage('categoriesCreate'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "End of Introduction",
          body: "Click on the button below to continue.",
          footer: RaisedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )
              );
            },
            child: const Text(
              'Get Started',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            color: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          image: _buildImage('endIntro'),
          decoration: pageDecoration,
        ),
      ],
      onDone: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        )
        );
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.greenAccent,
        activeColor: Colors.greenAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
