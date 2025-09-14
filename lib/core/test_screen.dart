import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
        ),
        body: AppointmentList(),
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final List<Map<String, String>> appointments = [
    {
      'name': 'John Doe',
      'time': '34m ago',
      'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
      'avatar': 'https://www.w3schools.com/w3images/avatar2.png'
    },
    {
      'name': 'Sarah Lee',
      'time': '40m ago',
      'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
      'avatar': 'https://www.w3schools.com/w3images/avatar3.png'
    },
    {
      'name': 'John Doe',
      'time': '50m ago',
      'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
      'avatar': 'https://www.w3schools.com/w3images/avatar1.png'
    },
    {
      'name': 'John Doe',
      'time': '55m ago',
      'appointment': 'Sep 10, 2025 - 11:30 AM with John Doe (Cleaning)',
      'avatar': 'https://www.w3schools.com/w3images/avatar4.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          name: appointments[index]['name']!,
          time: appointments[index]['time']!,
          appointment: appointments[index]['appointment']!,
          avatarUrl: appointments[index]['avatar']!,
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String name;
  final String time;
  final String appointment;
  final String avatarUrl;

  AppointmentCard({
    required this.name,
    required this.time,
    required this.appointment,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      appointment,
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
