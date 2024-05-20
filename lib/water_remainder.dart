import 'dart:async';
import 'package:flutter/material.dart';

class WaterReminder extends StatefulWidget {
  @override
  _WaterReminderState createState() => _WaterReminderState();
}

class _WaterReminderState extends State<WaterReminder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Reminder',
          style: TextStyle(color: Colors.white),
          
        ),
        backgroundColor: Color(0xFF1f0825),
         iconTheme: IconThemeData(color: Colors.white)
      ),
      backgroundColor: Color(0xFF1f0825),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0), // Add padding between app bar and image
        child: Stack(
          children: [
            Positioned(
              top: 0, // Position at the top of the screen
              left: 70, // Adjust the left padding
              right: 70, // Center horizontally
              child: Image.asset(
                "assets/glass2.jpg", // Check the path to your image
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 150, // Adjust the width of the image
                height: 300, // Adjust the height of the image
              ),
            ),
            Positioned(
              top: 310, // Position the container below the image
              left: 30, // Adjust the left padding
              right: 30, // Adjust the right padding
              child: Container(
                width: MediaQuery.of(context).size.width - 100, // Adjust the width of the container to fill the screen width with padding
                height: 500, // Adjust the height of the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 36.0),
                      child: Text(
                        '1.5ml',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f0825),
                        ),
                      ),
                    ),
                    Text(
                      'Daily Goal: 2500ml',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 20), // Add space between the texts and the rectangle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16), // Add padding to the left and right of the rectangle
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey), // Add border to the container
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Drink 180ml of water',
                                  style: TextStyle(
                                    fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1f0825),
                                  ),
                                ),
                                Text(
                                  'Upcoming',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '4:00 PM', // Time example, replace it with the actual time
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Add space between the rectangle and the bottom of the container
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
