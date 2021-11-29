import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goolazo/views/check_connection.dart';
import 'package:goolazo/views/home_screen.dart';
import 'package:goolazo/views/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'goolazo',
      home: WelcomeScreen(),
    );
  }));
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showSplashScreen = true;
  Future<bool> _prepareNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      setState(() {
        _showSplashScreen = prefs.getBool('show_splash_screens') ?? true;
      });
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      setState(() {
        _showSplashScreen = prefs.getBool('show_splash_screens') ?? true;
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prepareNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data
              ? _showSplashScreen
                  ? SplashScreen()
                  : HomeScreen()
              : CheckConnection();
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/goal_logo.PNG',
                    color: Colors.teal[600],
                  ),
                  //  App name
                  Text(
                    "Goal",
                    style: TextStyle(
                        fontFamily: "AbrilFatface",
                        color: Colors.teal[600],
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
