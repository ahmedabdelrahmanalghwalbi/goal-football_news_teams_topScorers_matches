import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopScorers extends StatefulWidget {
  String leagueCode;
  TopScorers({this.leagueCode});
  @override
  _TopScorersState createState() => _TopScorersState();
}

class _TopScorersState extends State<TopScorers> {
  List _topScorers = [];

  getTeamPayers(String leagueCode) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/competitions/$leagueCode/scorers'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    String body = response.body;
    if (response.statusCode == 200) {
      Map data = jsonDecode(body);
      setState(() {
        _topScorers = data['scorers'];
      });
      print("this is the data ==> $_topScorers");
    }
  }

  @override
  void initState() {
    super.initState();
    getTeamPayers(widget.leagueCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      appBar: AppBar(
          backgroundColor: Colors.teal[600],
          elevation: 0,
          title: Text(
            "Top Scorers",
            style: TextStyle(color: Colors.white, fontFamily: 'AbrilFatface'),
          ),
          centerTitle: true),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.grey[100]),
          child: _topScorers.length == 0
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal[600],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: _topScorers
                            .map((e) => Card(
                                  child: ListTile(
                                    title: Text('${e['player']['name']}'),
                                    subtitle: Text('${e['team']['name']}'),
                                    trailing: CircleAvatar(
                                      backgroundColor: Colors.teal[600],
                                      child: Center(
                                        child: Text(
                                          '${e['numberOfGoals'].toString()}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
