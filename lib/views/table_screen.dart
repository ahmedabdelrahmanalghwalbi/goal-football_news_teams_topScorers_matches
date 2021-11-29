import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goolazo/utilites/constants.dart';
import 'package:http/http.dart' as http;

class TableScreen extends StatefulWidget {
  final String code;
  TableScreen({this.code});
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  List _table;

  getTable() async {
    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/competitions/${widget.code}/standings'),
        headers: {'X-Auth-Token': '63abdf0bf7064f7499f9abeef3383746'});
    String body = response.body;
    if (response.statusCode == 200) {
      Map data = jsonDecode(body);
      List table = data['standings'][0]['table'];
      setState(() {
        _table = table;
      });
    }
  }

  Widget buildTable() {
    List<Widget> teams = [];
    for (var team in _table) {
      teams.add(
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        team['position'].toString().length > 1
                            ? Text(team['position'].toString() + ' - ')
                            : Text(" " + team['position'].toString() + ' - '),
                        Row(
                          children: [
                            team['team']['crestUrl'] != null
                                ? SvgPicture.network(
                                    team['team']['crestUrl'],
                                    height: 30,
                                    width: 30,
                                    placeholderBuilder:
                                        (BuildContext context) => Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/blanck.png"))),
                                    ),
                                  )
                                : Text('x'),
                            SizedBox(
                              width: 2,
                            ),
                            team['team']['name'].toString().length > 11
                                ? Text(team['team']['name']
                                        .toString()
                                        .substring(0, 11) +
                                    '...')
                                : Text(team['team']['name'].toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            color: Colors.blueGrey.withOpacity(0.3),
                            padding: EdgeInsets.all(3),
                            child: Text(team['playedGames'].toString())),
                        Container(
                            color: Colors.green.withOpacity(0.3),
                            padding: EdgeInsets.all(3),
                            child: Text(team['won'].toString())),
                        Container(
                            color: Colors.grey.withOpacity(0.3),
                            padding: EdgeInsets.all(3),
                            child: Text(team['draw'].toString())),
                        Container(
                            color: Colors.red.withOpacity(0.3),
                            padding: EdgeInsets.all(3),
                            child: Text(team['lost'].toString())),
                        Container(
                            color: Colors.amberAccent.withOpacity(0.3),
                            padding: EdgeInsets.all(3),
                            child: Text(team['goalDifference'].toString())),
                        Text(
                          team['points'].toString(),
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
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
    return Column(
      children: teams,
    );
  }

  Widget hint(String title) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: "AbrilFatface",
            fontWeight: FontWeight.bold,
            color: Colors.teal[600]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[600],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "League Standings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'AbrilFatface',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _table == null
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal[600],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Pos',
                                  style: TextStyle(
                                      fontFamily: "AbrilFatface",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[600]),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Club',
                                  style: TextStyle(
                                      fontFamily: "AbrilFatface",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[600]),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                hint('PL'),
                                hint('W'),
                                hint('D'),
                                hint('L'),
                                hint('GD'),
                                Text(
                                  'Pts',
                                  style: TextStyle(
                                      fontFamily: "AbrilFatface",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTable(),
                  ],
                ),
              ),
            ),
    );
  }
}
