import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Welcome to Piggytech, Admin Roniel!",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryBox("Total Users", "3"),
                _buildSummaryBox("Total Product", "3"),
                _buildSummaryBox("Total Sales", "11,300"),
              ],
            ),
            SizedBox(height: 20.0),
            _buildBarChart(),
            SizedBox(height: 20.0),
            _buildPieChartWithLabels(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10000, color: Colors.blue)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15000, color: Colors.blue)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 20000, color: Colors.blue)]),
            BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 25000, color: Colors.blue)]),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: Colors.black, fontSize: 10);
                  switch (value.toInt()) {
                    case 1:
                      return Text('Feb', style: style);
                    case 2:
                      return Text('Mar', style: style);
                    case 3:
                      return Text('Apr', style: style);
                    case 4:
                      return Text('May', style: style);
                    default:
                      return Container();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartWithLabels() {
    return Container(
      height: 250,
      child: Stack(
        children: [
          Center(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 25, color: Colors.pink, title: ''),
                  PieChartSectionData(value: 25, color: Colors.lightBlue, title: ''),
                  PieChartSectionData(value: 50, color: Colors.yellowAccent, title: ''),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 50,
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: Colors.black),
                SizedBox(width: 4),
                Text('Starter 25%', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: 50,
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: Colors.black),
                SizedBox(width: 4),
                Text('Grower 25%', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
          Positioned(
            top: 140,
            left: 20,
            child: Row(
              children: [
                Icon(Icons.arrow_left, color: Colors.black),
                SizedBox(width: 4),
                Text('Booster 50%', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminDashboardPage(),
  ));
}