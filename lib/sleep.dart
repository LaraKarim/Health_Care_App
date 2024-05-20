import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart package
import './firebaseAUTH/auth.dart';

class SleepPage extends StatefulWidget {
  final AuthService authService;

  SleepPage({required this.authService});

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  late User _user;
  List<DateTime> _sleepTimes = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = widget.authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _user = user;
      });
      await _fetchSleepTimes();
    }
  }

  Future<void> _fetchSleepTimes() async {
    List<DateTime> sleepTimes =
        await widget.authService.fetchTimesDataFromFirestore(_user.uid);
    setState(() {
      _sleepTimes = sleepTimes;
    });
  }

  Future<void> _addSleepTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime currentTime = DateTime.now();
      DateTime sleepTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Update Firestore
      await widget.authService.updateUserDocument(_user.uid, {
        'sleepTimes': FieldValue.arrayUnion([sleepTime])
      });

      // Update UI
      await _fetchSleepTimes();
    }
  }

  Widget _buildSleepChart() {
    List<FlSpot> spots = [];

    // Convert sleep times to FlSpot for chart
    for (int i = 0; i < _sleepTimes.length; i++) {
      spots.add(FlSpot(i.toDouble(), _sleepTimes[i].hour.toDouble()));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity, // Match parent width
        height: 200.0, // Adjust the height as needed
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
                // bottomTitles: SideTitles(showTitles: false),
                // leftTitles: SideTitles(showTitles: true),
                ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                // color: [Colors.blue],
                barWidth: 5,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sleep Analysis',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 45.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/sleepa.png', // Placeholder image path
                    height: 300.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _sleepTimes.isEmpty
                  ? Center(
                      child: Text('No sleep times recorded.'),
                    )
                  : _buildSleepChart(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSleepTime,
        tooltip: 'Add Sleep Time',
        child: Icon(Icons.add),
      ),
    );
  }
}
