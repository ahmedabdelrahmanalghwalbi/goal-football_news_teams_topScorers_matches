import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpecificTeamMatches extends StatefulWidget {
  //important hint :=> http://api.football-data.org/v2/teams/86/matches/?status=LIVE
  // to seperate matches about it is status
  final String teamId;
  SpecificTeamMatches({this.teamId});
  @override
  _SpecificTeamMatchesState createState() => _SpecificTeamMatchesState();
}

class _SpecificTeamMatchesState extends State<SpecificTeamMatches> {
  List _teamMatches = [];

  getTeamPayers(String teamId) async {
    http.Response response = await http.get(
        Uri.parse('http://api.football-data.org/v2/teams/$teamId/matches'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    String body = response.body;
    if (response.statusCode == 200) {
      Map data = jsonDecode(body);
      setState(() {
        _teamMatches = data['matches'];
      });
      var status =
          data['matches'].map((e) => e['status']).toList().toSet().toSet();
      print("this is status =>$status");
      print("this is the data ==> $_teamMatches");
    }
  }

  @override
  void initState() {
    super.initState();
    getTeamPayers(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              const Color(0xffe84860),
              const Color(0xffe70066),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _teamMatches.length == 0
                ? Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'league Matches',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(
                        children: _teamMatches
                            .map((e) => GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: 100,
                                    height: 100,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Text('${e['homeTeam']['name']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('${e['awayTeam']['name']}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('${e['utcDate'].toString()}'),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text('${e['status'].toString()}')
                                      ],
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
