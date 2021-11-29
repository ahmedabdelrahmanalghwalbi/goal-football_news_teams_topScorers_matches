import 'package:flutter/material.dart';
import 'package:goolazo/views/league_options.dart';
import 'package:goolazo/views/LeagueContainer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<String>> leagues = [
    ['assets/pl.png', 'PL'],
    ['assets/laliga.png', 'PD'],
    ['assets/bundesliga.png', 'BL1'],
    ['assets/seria.png', 'SA'],
    ['assets/ligue1.png', 'FL1'],
    ['assets/nos.png', 'PPL']
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal[600],
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                'assets/appbar2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            floating: true,
            pinned: true,
            backgroundColor: Colors.teal[600],
            expandedHeight: MediaQuery.of(context).size.height / 4,
            title: Text(
              "Leagues",
              style: TextStyle(color: Colors.white, fontFamily: "AbrilFatface"),
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              shrinkWrap: true,
              itemCount: 6,
              primary: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: LeagueContainer(image: leagues[index][0]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LeagueOptions(code: leagues[index][1]),
                          ));
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
