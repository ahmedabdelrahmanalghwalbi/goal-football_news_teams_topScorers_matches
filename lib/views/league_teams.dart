import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goolazo/utilites/constants.dart';
import 'package:goolazo/views/all_league_matchs.dart';
import 'package:goolazo/views/team_players.dart';
import 'package:http/http.dart' as http;

class LeagueTeams extends StatefulWidget {
  final String leagueCode;
  LeagueTeams({this.leagueCode});
  @override
  _LeagueTeamsState createState() => _LeagueTeamsState();
}

class _LeagueTeamsState extends State<LeagueTeams> {
  List _leagueTeams = [];

  getLeagueTeams(String leagueCode) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/competitions/$leagueCode/teams'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    String body = response.body;
    if (response.statusCode == 200) {
      Map data = jsonDecode(body);
      setState(() {
        _leagueTeams = data['teams'];
      });
      print("this is the league teams ==> $_leagueTeams");
    }
  }

  Widget optionButton(
      Color color, Text title, FaIcon icon, Function onPressed) {
    return Expanded(
        child: GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RotatedBox(quarterTurns: 3, child: title),
              icon,
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    getLeagueTeams(widget.leagueCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      appBar: AppBar(
          backgroundColor: Colors.teal[600],
          elevation: 0,
          title: Text(
            "League Teams",
            style: TextStyle(color: Colors.white, fontFamily: 'AbrilFatface'),
          ),
          centerTitle: true),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Colors.grey[100]),
          child: _leagueTeams.length == 0
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
                        children: _leagueTeams
                            .map((e) => GestureDetector(
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${e['shortName']}",
                                                        style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text('Founded :',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        Text(
                                                            '${e['founded'].toString()}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ],
                                                    ),
                                                    Text(
                                                      '${e['venue'].toString()}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          optionButton(
                                                              primaryColor,
                                                              Text(
                                                                'Players',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .users,
                                                                color: Colors
                                                                    .white,
                                                                size: 35,
                                                              ), () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            TeamPlayers(
                                                                              teamId: e['id'].toString(),
                                                                            )));
                                                          }),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          optionButton(
                                                              Colors.white,
                                                              Text(
                                                                'matches',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .futbol,
                                                                color:
                                                                    primaryColor,
                                                                size: 35,
                                                              ), () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AllLeagueMatches(
                                                                leagueCode: e[
                                                                        'id']
                                                                    .toString(),
                                                                matchesType:
                                                                    "teams",
                                                                leagueTeams:
                                                                    _leagueTeams,
                                                              ),
                                                              // SpecificTeamMatches(
                                                              //   teamId: e['id'].toString(),
                                                              // )
                                                            ));
                                                          }),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.teal[600]
                                                      .withOpacity(0.2),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.network(
                                                    e['crestUrl'],
                                                    placeholderBuilder:
                                                        (BuildContext
                                                                context) =>
                                                            Image.asset(
                                                                "assets/blanck.png"),
                                                  ),
                                                ),
                                              )),
                                        ],
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
