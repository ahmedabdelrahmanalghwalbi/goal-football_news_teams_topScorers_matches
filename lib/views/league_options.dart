import 'package:flutter/material.dart';
import 'package:goolazo/utilites/constants.dart';
import 'package:goolazo/views/all_league_matchs.dart';
import 'package:goolazo/views/league_teams.dart';
import 'package:goolazo/views/table_screen.dart';
import 'package:goolazo/views/top_scrorers.dart';

class LeagueOptions extends StatefulWidget {
  final String code;
  LeagueOptions({this.code});
  @override
  _LeagueOptionsState createState() => _LeagueOptionsState();
}

class _LeagueOptionsState extends State<LeagueOptions> {
  Widget option(String title, Function onPressed, String image) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.teal[600],
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontFamily: "AbrilFatface",
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(image), fit: BoxFit.contain),
                        color: Colors.teal[600].withOpacity(0.2)),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      appBar: AppBar(
          backgroundColor: Colors.teal[600],
          elevation: 0,
          title: Text(
            "Options",
            style: TextStyle(color: Colors.white, fontFamily: 'AbrilFatface'),
          ),
          centerTitle: true),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.grey[100]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      //standings
                      option(
                        "Standings",
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TableScreen(code: widget.code),
                              ));
                        },
                        "assets/splash_screen/standings.png",
                      ),
                      //teams
                      option("Teams", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LeagueTeams(leagueCode: widget.code),
                            ));
                      }, "assets/splash_screen/players2.png"),
                      //top Scorers
                      option("Top Scorers", () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TopScorers(leagueCode: widget.code),
                            ));
                      }, "assets/splash_screen/toopscorersgold.png"),
                      //matches
                      option('Matches', () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllLeagueMatches(
                                leagueCode: widget.code,
                                matchesType: "competitions",
                              ),
                            ));
                      }, "assets/splash_screen/vs.png"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
