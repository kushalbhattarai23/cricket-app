import 'package:flutter/material.dart';

class PlayersScreen extends StatelessWidget {
  final List<Map<String, String>> players = [
    {"name": "Player 1", "role": "Batsman"},
    {"name": "Player 2", "role": "Bowler"},
    {"name": "Player 3", "role": "All-rounder"},
    {"name": "Player 4", "role": "Wicketkeeper"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(players[index]["name"]!),
          subtitle: Text("Role: ${players[index]["role"]}"),
        );
      },
    );
  }
}