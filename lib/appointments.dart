import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TextEditingController _doctorNameController = TextEditingController();
  late Map<DateTime, List<Appointment>> _events;
  late List<Appointment> _selectedAppointments;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {};
    _selectedAppointments = [];
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      print(userId);

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('appointments')) {
          var appointmentsData = userData['appointments'];

          if (appointmentsData != null && appointmentsData is Map<String, dynamic>) {
            Map<DateTime, List<Appointment>> events = {};

            appointmentsData.forEach((dateKey, appointmentsList) {
              try {
                List<Appointment> appointments = [];
                // Parse dateKey as DateTime
                DateTime dateTime;
                if (dateKey.endsWith("Z")) {
                  // Date with time and UTC indicator
                  dateTime = DateTime.parse(dateKey);
                } else if (dateKey.contains("T")) {
                  // Date with time but without UTC indicator
                  dateTime = DateTime.parse(dateKey + "Z");
                } else {
                  // Date without time
                  dateTime = DateTime.parse(dateKey + "T00:00:00.000Z");
                }
                if (appointmentsList is List) {
                  (appointmentsList as List<dynamic>).forEach((appointment) {
                    appointments.add(Appointment.fromJson(appointment));
                  });
                }
                events[dateTime] = appointments;
              } catch (error) {
                print('Error parsing appointments for date: $dateKey. Error: $error');
              }
            });

            setState(() {
              _events = events;
              _selectedAppointments = _events[_selectedDay] ?? [];
            });
          }
        }
      }
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }

  Future<void> _addAppointment(DateTime selectedDate, String doctorName) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Format the selectedDate as a string using a specific format
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Retrieve the current appointments data
      DocumentSnapshot userDoc = await userDocRef.get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      // Create a new appointments map if it doesn't exist
      Map<String, dynamic> appointmentsData = userData?['appointments'] ?? {};

      // Check if appointments already exist for the selected date
      if (appointmentsData.containsKey(formattedDate)) {
        // Appointments already exist for the selected date, inform the user and return
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An appointment already exists for ${DateFormat('MMMM d, y').format(selectedDate)}.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Exit the method
      }

      // Update the appointments data with the new appointment
      Appointment newAppointment = Appointment(dateTime: selectedDate, doctorName: doctorName);
      Map<String, dynamic> newAppointmentData = newAppointment.toJson();
      appointmentsData[formattedDate] = [newAppointmentData];

      // Save the updated data to Firestore
      await userDocRef.set({'appointments': appointmentsData}, SetOptions(merge: true));

      // Refresh appointments after adding
      await _fetchAppointments();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Appointment Confirmed'),
            content: Text('Your appointment with $doctorName on ${DateFormat('MMMM d, y').format(selectedDate)} has been confirmed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      print('Appointment added successfully');
    } catch (error) {
      print('Error adding appointment: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Color(0xFF5e4e8f),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5e4e8f),
                Color.fromARGB(255, 211, 202, 239),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Appointments for ${DateFormat('MMMM d, y').format(_selectedDay)}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:  Color.fromARGB(255, 211, 202, 239)),
                  ),
                ),
                _selectedAppointments.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No appointments for this day', style: TextStyle(color:  Color.fromARGB(255, 211, 202, 239))),
                      )
                    : Column(
                        children: _selectedAppointments
                            .map((appointment) => ListTile(
                                  title: Text('Doctor\'s Name: ${appointment.doctorName}', style: TextStyle(color: Color.fromARGB(255, 211, 202, 239))),
                                ))
                            .toList(),
                      ),
                  Container(
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:Container(
                  decoration: BoxDecoration(
                  
                    
                  ),
                  child: Container( 
                    margin: EdgeInsets.all(20),
                    child:
                    TableCalendar(
                    
                    calendarFormat: _calendarFormat,
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2050),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _selectedAppointments = _events[selectedDay] ?? [];
                      });
                    },
                    eventLoader: (day) {
                      return _events[day] ?? [];
                    },
                    calendarStyle: CalendarStyle(
                      
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(color: Color.fromARGB(255, 211, 202, 239), shape: BoxShape.circle),
                      todayTextStyle: TextStyle(color: Colors.black),
                    ),
                  ),),),

                ),),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showAddAppointmentDialog();
                  },
                  child: Text('Add Appointment', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5e4e8f),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddAppointmentDialog() async {
    DateTime? selectedDate = _selectedDay;
    String doctorName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add a New Appointment', style: TextStyle(color: Color(0xFF5e4e8f))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Date:', style: TextStyle(color: Color(0xFF5e4e8f))),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF5e4e8f)),
                        SizedBox(width: 10),
                        Text(
                          selectedDate != null ? DateFormat('MMMM d, y').format(selectedDate!) : 'Select Date',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Enter Doctor\'s Name:', style: TextStyle(color: Color(0xFF5e4e8f))),
                  SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      doctorName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Doctor\'s Name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Cancel', style: TextStyle(color: Color(0xFF5e4e8f))),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDate != null && doctorName.isNotEmpty) {
                      _addAppointment(selectedDate!, doctorName);
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                  child: Text('Add', style: TextStyle(color: Color(0xFF5e4e8f))),
                ),
              ],
              backgroundColor: Color.fromARGB(255, 211, 202, 239),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    super.dispose();
  }
}

class Appointment {
  final DateTime dateTime;
  final String doctorName;

  Appointment({
    required this.dateTime,
    required this.doctorName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      dateTime: DateTime.parse(json['dateTime']),
      doctorName: json['doctorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'doctorName': doctorName,
    };
  }
}
