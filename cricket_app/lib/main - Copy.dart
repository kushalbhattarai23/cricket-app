import 'package:flutter/material.dart';
import 'screens/batting_screen.dart';
import 'screens/bowling_screen.dart';
import 'screens/teams_screen.dart';
import 'screens/players_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    BattingScreen(),
    BowlingScreen(),
    TeamsScreen(),
    PlayersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Cricket Stats')),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.sports_cricket), label: 'Batting'),
    BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Bowling'),
    BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Players'),
  ],
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  selectedItemColor: Colors.white, // Active item color
  unselectedItemColor: Colors.white70, // Slightly faded inactive color
  backgroundColor: Colors.blue, // Whole navbar in blue
  type: BottomNavigationBarType.fixed, // Ensures full background color
),

      ),
    );
  }
}