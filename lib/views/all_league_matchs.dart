import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goolazo/utilites/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AllLeagueMatches extends StatefulWidget {
  final String leagueCode;
  final String matchesType;
  final dynamic leagueTeams;
  AllLeagueMatches({this.leagueCode, this.matchesType, this.leagueTeams});
  @override
  _AllLeagueMatchesState createState() => _AllLeagueMatchesState();
}

class _AllLeagueMatchesState extends State<AllLeagueMatches> {
  List _leagueTeams = [];
  List _finishedMatches = [];
  List _schedualMatches = [];
  List _liveMatches = [];
  //Finished matches
  getFinishedMatches(String leagueCode, String matchesType) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/$matchesType/$leagueCode/matches/?status=FINISHED'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});

    if (response.statusCode == 200) {
      setState(() {
        _finishedMatches = jsonDecode(response.body)["matches"];
      });
      print("this is the finished matches ${_finishedMatches.length}");
    }
  }

  //schedualed matches
  getSchedualMatches(String leagueCode, String matchesType) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/$matchesType/$leagueCode/matches/?status=SCHEDULED'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    if (response.statusCode == 200) {
      setState(() {
        _schedualMatches = jsonDecode(response.body)["matches"];
      });
      print("this is schedual matches ${_schedualMatches.length}");
    }
  }

  //live Matches
  getLivedMatches(String leagueCode, String matchesType) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/$matchesType/$leagueCode/matches/?status=LIVE'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    if (response.statusCode == 200) {
      setState(() {
        _liveMatches = jsonDecode(response.body)["matches"];
      });
      print("this is live matches ${_liveMatches.length}");
    }
  }

  getLeagueTeams(String leagueCode) async {
    if (widget.leagueTeams != null) {
      setState(() {
        _leagueTeams = widget.leagueTeams;
      });
    } else {
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
        print("this is the league teams ==> ${_leagueTeams.length}");
      }
    }
  }

  calling() async {
    await getFinishedMatches(widget.leagueCode, widget.matchesType);
    await getLivedMatches(widget.leagueCode, widget.matchesType);
    await getSchedualMatches(widget.leagueCode, widget.matchesType);
    await getLeagueTeams(widget.leagueCode);
  }

  @override
  void initState() {
    super.initState();
    calling();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffF6F6F6),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: Colors.teal[600],
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Matches",
            style: TextStyle(color: Colors.white, fontFamily: 'AbrilFatface'),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Live",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "AbrilFatface"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Finish",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "AbrilFatface"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Schedual",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "AbrilFatface"),
                ),
              ),
            ],
          ),
        ),
        body: _leagueTeams.length == 0
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal[600],
                  ),
                ))
            : TabBarView(
                children: [
                  //live matches
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: _liveMatches.length == 0
                          ? Center(
                              child: Text(
                                "No Live matches ..!",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView(
                              scrollDirection: Axis.vertical,
                              children: _liveMatches.map((match) {
                                var team1Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['homeTeam']['id']);

                                var team2Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['awayTeam']['id']);

                                final DateTime date =
                                    DateTime.parse(match["utcDate"]);
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd hh:mm');
                                final String formatted = formatter.format(date);
                                print(formatted);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                    formatted.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team1Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              match['score'][
                                                                          'fullTime']
                                                                      [
                                                                      'homeTeam']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 25),
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                            Text(
                                                              match['score'][
                                                                          'fullTime']
                                                                      [
                                                                      'awayTeam']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team2Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: Center(
                                                              child: Text(
                                                            team1Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                        Expanded(
                                                            child: Center(
                                                          child: Container(
                                                              child: Text(
                                                            team2Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                    ),
                  ),
                  ////////////////////////////////////////////////////////
                  //finished matches
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: _finishedMatches.length == 0
                          ? Center(
                              child: Text(
                                "No Finished matches ..!",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView(
                              scrollDirection: Axis.vertical,
                              children: _finishedMatches.map((match) {
                                var team1Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['homeTeam']['id']);

                                var team2Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['awayTeam']['id']);

                                final DateTime date =
                                    DateTime.parse(match["utcDate"]);
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd hh:mm');
                                final String formatted = formatter.format(date);
                                print(formatted);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                    formatted.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              // color:
                                              //     Colors.grey.withOpacity(0.2),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team1Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              match['score'][
                                                                          'fullTime']
                                                                      [
                                                                      'homeTeam']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 25),
                                                            ),
                                                            Text(
                                                              ":",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                            Text(
                                                              match['score'][
                                                                          'fullTime']
                                                                      [
                                                                      'awayTeam']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25,
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team2Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: Center(
                                                              child: Text(
                                                            team1Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                        Expanded(
                                                            child: Center(
                                                          child: Container(
                                                              child: Text(
                                                            team2Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                    ),
                  ),
                  ////////////////////////////////////////////////////////
                  //schedualed matches
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: _schedualMatches.length == 0
                          ? Center(
                              child: Text(
                                "No Schedualed matches ..!",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView(
                              scrollDirection: Axis.vertical,
                              children: _schedualMatches.map((match) {
                                var team1Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['homeTeam']['id']);

                                var team2Image = _leagueTeams.firstWhere(
                                    (element) =>
                                        element['id'] ==
                                        match['awayTeam']['id']);

                                final DateTime date =
                                    DateTime.parse(match["utcDate"]);
                                final DateFormat formatter =
                                    DateFormat('yyyy-MM-dd hh:mm');
                                final String formatted = formatter.format(date);
                                print(formatted);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Center(
                                                  child: Text(
                                                    formatted.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              // color:
                                              //     Colors.grey.withOpacity(0.2),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team1Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                        Text(
                                                          'vs',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                          child: SvgPicture
                                                              .network(
                                                            team2Image[
                                                                'crestUrl'],
                                                            placeholderBuilder:
                                                                (BuildContext
                                                                        context) =>
                                                                    Image.asset(
                                                                        "assets/blanck.png"),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Container(
                                                          child: Center(
                                                              child: Text(
                                                            team1Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                        Expanded(
                                                            child: Center(
                                                          child: Container(
                                                              child: Text(
                                                            team2Image['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
