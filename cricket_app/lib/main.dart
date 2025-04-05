import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/batting_screen.dart';
import 'screens/bowling_screen.dart';
import 'screens/teams_screen.dart';
import 'screens/players_screen.dart';

import 'notifiers/theme_notifier.dart';
import 'widgets/settings_menu.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyAppWrapper(),
    ),
  );
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricket Stats',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.currentTheme,
      home: MyApp(),
    );
  }
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

  void _handleMenuSelection(String value) {
    if (value == 'theme') {
      Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
    } else if (value == 'language') {
      _showLanguageDialog();
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Select Language"),
        actions: [
          TextButton(
            onPressed: () {
              // Replace with your actual localization logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Language set to English")));
            },
            child: Text("English"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Language set to Nepali")));
            },
            child: Text("नेपाली"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Stats'),
        actions: [
          SettingsMenu(onOptionSelected: _handleMenuSelection),
        ],
      ),
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
