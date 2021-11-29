import 'package:flutter/material.dart';
import 'package:goolazo/views/home_screen.dart';
import 'package:goolazo/views/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashGetStartedButton extends StatelessWidget {
  void _moveToWelcomeScreen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_splash_screens', false);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.teal[600],
      ),
      onPressed: () async {
        _moveToWelcomeScreen(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLogged", true);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(16),
                    letterSpacing: 0.75,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
