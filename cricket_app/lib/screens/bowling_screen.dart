import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';  // Import for the chart

class BowlingScreen extends StatefulWidget {
  @override
  _BowlingScreenState createState() => _BowlingScreenState();
}

class _BowlingScreenState extends State<BowlingScreen> {
  List<Map<String, dynamic>> bowlingData = [];
  bool isLoading = true;
  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchBowlingData();
  }

  Future<void> fetchBowlingData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/matches/bowling_data/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> tempData = data.map((item) => {
        "name": item["bowler"],
        "wickets": item["total_wickets"].toString(),
      }).toList();

      // Sort descending by wickets
      tempData.sort((a, b) => int.parse(b["wickets"]).compareTo(int.parse(a["wickets"])));

      setState(() {
        bowlingData = tempData;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> getCurrentPageData() {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    return bowlingData.sublist(start, end > bowlingData.length ? bowlingData.length : end);
  }

  Color getTileColor(int index) {
    if (index == 0) return Colors.amber.shade200;
    if (index == 1) return Colors.grey.shade300;
    if (index == 2) return Colors.brown.shade200;
    return Colors.white;
  }

  List<BarChartGroupData> getBarChartData() {
    // Only show data for the current page
    List<Map<String, dynamic>> paginatedData = getCurrentPageData();
    return paginatedData.map((item) {
      return BarChartGroupData(
        x: paginatedData.indexOf(item),
        barRods: [
          BarChartRodData(
            toY: double.parse(item["wickets"]), // Use toY instead of y
            color: Colors.blue,
            width: 15,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    var topBowler = bowlingData.first;
    var paginatedData = getCurrentPageData();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "🏆 Top Bowler: ${topBowler["name"]}, Wickets: ${topBowler["wickets"]}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: paginatedData.length,
            itemBuilder: (context, index) {
              int globalIndex = currentPage * itemsPerPage + index;
              return Container(
                color: getTileColor(globalIndex),
                child: ListTile(
                  title: Text(paginatedData[index]["name"]),
                  subtitle: Text("Wickets: ${paginatedData[index]["wickets"]}"),
                  leading: Text("#${globalIndex + 1}"),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0
                    ? () {
                        setState(() {
                          currentPage--;
                        });
                      }
                    : null,
                child: Text("Prev"),
              ),
              SizedBox(width: 20),
              Text("Page ${currentPage + 1}"),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: (currentPage + 1) * itemsPerPage < bowlingData.length
                    ? () {
                        setState(() {
                          currentPage++;
                        });
                      }
                    : null,
                child: Text("Next"),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 250, // Set the height of the chart
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(show: true),
                barGroups: getBarChartData(), // Dynamically get the bar chart data for current page
              ),
            ),
          ),
        ),
      ],
    );
  }
}
