import 'package:flutter/material.dart';

class TeamsScreen extends StatelessWidget {
  final List<String> teams = ["Team A", "Team B", "Team C", "Team D"];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(teams[index]),
        );
      },
    );
  }
}