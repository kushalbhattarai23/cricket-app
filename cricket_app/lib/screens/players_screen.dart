import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayersScreen extends StatefulWidget {
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<dynamic> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/players/stats/'));

    if (response.statusCode == 200) {
      setState(() {
        players = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(player['player'][0]), // First letter of name
                  ),
                  title: Text(player['player']),
                  subtitle: Text("Teams: ${player['teams'].join(', ')}"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Matches: ${player['matches_played']}"),
                      Text("Wickets: ${player['total_wickets']}"),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(player['player']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Strike Rate: ${player['strike_rate']}"),
                            Text("Catches: ${player['catches']}"),
                            Text("Runouts: ${player['runouts']}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
