import 'package:flutter/material.dart';

class LeagueContainer extends StatelessWidget {
  final String image;
  LeagueContainer({this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.teal[600],
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Image.asset(
          image,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
