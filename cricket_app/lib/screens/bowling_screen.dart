import 'package:flutter/material.dart';

class BowlingScreen extends StatelessWidget {
  final List<Map<String, String>> bowlingData = [
    {"name": "Bowler 1", "wickets": "3", "overs": "4"},
    {"name": "Bowler 2", "wickets": "5", "overs": "10"},
    {"name": "Bowler 3", "wickets": "2", "overs": "8"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bowlingData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(bowlingData[index]["name"]!),
          subtitle: Text("Wickets: ${bowlingData[index]["wickets"]}, Overs: ${bowlingData[index]["overs"]}"),
        );
      },
    );
  }
}