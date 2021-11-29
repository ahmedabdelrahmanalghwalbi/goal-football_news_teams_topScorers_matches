import 'package:flutter/material.dart';

class CheckConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.teal[600],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/goal_logo.PNG"),
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/wifii.png"),
                  )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "OOPS! check the Connection Please !",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "AbrilFatface"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
