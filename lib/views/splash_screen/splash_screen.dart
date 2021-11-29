import 'package:flutter/material.dart';
import 'package:goolazo/views/utils/size_config.dart';

import 'components/slpash_body.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    //  It has to be called at the starting screen
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SplashBody(),
      ),
    );
  }
}
