import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Player {
  final String name;
  final String role;
  final int matches;
  final int runs;
  final int wickets;
  final String color;

  Player({
    required this.name,
    required this.role,
    required this.matches,
    required this.runs,
    required this.wickets,
    required this.color,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['player'],
      role: json['role'],
      matches: json['matches_played'],
      runs: json['total_runs'],
      wickets: json['total_wickets'],
      color: json['color'],
    );
  }
}

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({Key? key}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Player> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    try {
      final response = await http.get(Uri.parse('https://cricket-app-4xbb.onrender.com/matches/players/stats/'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          players = jsonData.map((data) => Player.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      print("Error fetching players: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players Stats')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                final cardColor = Color(int.parse(player.color.replaceFirst('#', '0xff')));

                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      player.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${player.role} | Matches: ${player.matches} | Runs: ${player.runs} | Wickets: ${player.wickets}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
