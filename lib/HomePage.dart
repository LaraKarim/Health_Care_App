import 'package:flutter/material.dart';
import 'package:healthapp/main.dart';
import 'package:provider/provider.dart';

class AndriodPrototype extends StatelessWidget {
  const AndriodPrototype({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = Provider.of<UsernameProvider>(context).username;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/homepage1.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello $userName ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome to HealthApp',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAdviceContainer(
                    context,
                    'Sleep Early',
                    'Get at least 7-9 hours of sleep for better health.',
                    Icons.nights_stay,
                  ),
                  SizedBox(width: 20), // Vertical space between the two squares
                  buildAdviceContainer(
                    context,
                    'Walk Daily',
                    'Take a walk for at least 30 minutes every day.',
                    Icons.directions_walk,
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildOptionButton(
                context,
                'Medication',
                Icons.medication,
                '/medication',
              ),
              SizedBox(height: 20),
              buildOptionButton(
                context,
                'Healthy Lifestyle',
                Icons.fitness_center,
                '/FitnessPage',
              ),
              SizedBox(height: 20),
              buildOptionButton(
                context,
                'Appointment',
                Icons.calendar_today,
                '/appointment',
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget buildOptionButton(
  BuildContext context,
  String label,
  IconData icon,
  String route,
) {
  return ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
    icon: Icon(icon, color: Colors.white,),
    label: Text(
      label,
      style: TextStyle(color: Colors.white), // Set text color to white
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF5e4e8f),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

  Widget buildAdviceContainer(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
