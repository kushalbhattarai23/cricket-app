import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeamsScreen extends StatefulWidget {
  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<Map<String, dynamic>> teams = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Function to fetch team stats (name and matches played) from the API
  Future<void> fetchTeams() async {
    final response = await http.get(Uri.parse('https://cricket-app-4xbb.onrender.com/matches/teams/stats/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // Parse the response

      setState(() {
        // Convert the response to a list of maps
        teams = data.map((team) {
          return {
            'teamname': team['teamname'],
            'played': team['played'],
          };
        }).toList();

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
        title: Text('Teams Stats'),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : teams.isEmpty
              ? Center(child: Text('No teams found'))
              : ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    final teamName = team['teamname'];
                    final matchesPlayed = team['played'];

                    return ListTile(
                      title: Text('$teamName'),
                      subtitle: Text('Matches Played: $matchesPlayed'),
                    );
                  },
                ),
    );
  }
}
