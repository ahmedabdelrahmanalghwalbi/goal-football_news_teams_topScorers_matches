import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goolazo/utilites/constants.dart';
import 'package:http/http.dart' as http;

class TeamPlayers extends StatefulWidget {
  final String teamId;
  TeamPlayers({this.teamId});
  @override
  _TeamPlayersState createState() => _TeamPlayersState();
}

class _TeamPlayersState extends State<TeamPlayers> {
  //http://api.football-data.org/v2/teams/57

  List _teamPlayers = [];

  getTeamPayers(String teamId) async {
    http.Response response = await http.get(
        Uri.parse('http://api.football-data.org/v2/teams/$teamId'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    String body = response.body;
    if (response.statusCode == 200) {
      Map data = jsonDecode(body);
      setState(() {
        _teamPlayers = data['squad'];
      });
      print("this is the data ==> $_teamPlayers");
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
      appBar: AppBar(
          backgroundColor: Colors.teal[600],
          elevation: 0,
          title: Text(
            "Teams Players",
            style: TextStyle(color: Colors.white, fontFamily: 'AbrilFatface'),
          ),
          centerTitle: true),
      backgroundColor: Colors.teal[600],
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: _teamPlayers.length == 0
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
                        children: _teamPlayers
                            .map(
                              (e) => Card(
                                child: ListTile(
                                  title: Text(
                                    '${e['name']}',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '${e['position']}',
                                    style: TextStyle(
                                        color: '${e['position']}' == 'Defender'
                                            ? Colors.green
                                            : '${e['position']}' == 'Attacker'
                                                ? Colors.red
                                                : '${e['position']}' ==
                                                        'Midfielder'
                                                    ? Colors.amber[700]
                                                    : secondaryColor,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    '${e['nationality']}',
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              //  Container(
                              //   padding: EdgeInsets.all(10),
                              //   decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(15)),
                              //   margin: EdgeInsets.only(bottom: 10),
                              //   child: Column(
                              //     children: [
                              //       Text('${e['name']}'),
                              //       SizedBox(
                              //         height: 5,
                              //       ),
                              //       Text('${e['position']}')
                              //     ],
                              //   ),
                              // ),
                            )
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
