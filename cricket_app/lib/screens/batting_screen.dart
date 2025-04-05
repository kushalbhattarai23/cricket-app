import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BattingScreen extends StatefulWidget {
  @override
  _BattingScreenState createState() => _BattingScreenState();
}

class _BattingScreenState extends State<BattingScreen> {
  List<Map<String, dynamic>> battingData = [];
  bool isLoading = true;
  bool hasError = false;
  int currentPage = 0;
  int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchBattingData();
  }

  Future<void> fetchBattingData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/matches/batting_data/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> tempData = data.map((item) => {
              "name": item["batter"],
              "runs": item["total_runs"].toString(),
              "balls": item["total_balls"].toString()
            }).toList();

        // Sort by runs descending
        tempData.sort((a, b) => int.parse(b["runs"]).compareTo(int.parse(a["runs"])));

        setState(() {
          battingData = tempData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  List<Map<String, dynamic>> getCurrentPageData() {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;
    return battingData.sublist(start, end > battingData.length ? battingData.length : end);
  }

  Color getTileColor(int index) {
    if (index == 0) return Colors.amber.shade200;
    if (index == 1) return Colors.grey.shade300;
    if (index == 2) return Colors.brown.shade200;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(child: Text("❌ Failed to load data. Please try again."));
    }

    if (battingData.isEmpty) {
      return Center(child: Text("📭 No batting data available."));
    }

    var topBatter = battingData.first;
    var paginatedData = getCurrentPageData();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FittedBox(
              child: Text(
                "🏆 Top Batter: ${topBatter["name"]}, Runs: ${topBatter["runs"]}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paginatedData.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                int globalIndex = currentPage * itemsPerPage + index;
                return Container(
                  color: getTileColor(globalIndex),
                  child: ListTile(
                    title: Text(paginatedData[index]["name"]),
                    subtitle: Text(
                        "Runs: ${paginatedData[index]["runs"]}, Balls: ${paginatedData[index]["balls"]}"),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage > 0 ? Colors.blue : Colors.grey,
                  ),
                  child: Text("Prev"),
                ),
                SizedBox(width: 20),
                Text("Page ${currentPage + 1} of ${(battingData.length / itemsPerPage).ceil()}"),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (currentPage + 1) * itemsPerPage < battingData.length
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (currentPage + 1) * itemsPerPage < battingData.length ? Colors.blue : Colors.grey,
                  ),
                  child: Text("Next"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
