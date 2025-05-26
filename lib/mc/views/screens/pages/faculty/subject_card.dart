// Custom Widget for Subject Card
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String subjectName;
  final String section;
  final String day;
  final String time;
  final String room;

  const SubjectCard({
    Key? key,
    required this.subjectName,
    required this.section,
    required this.day,
    required this.time,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      // elevation: 4,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(
          255, 58, 116, 214), // Subtle blue for card background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.lightBlue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Name
                Text(
                  subjectName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002855), // NEMSU blue
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                  height: 20,
                ),
                // Subject Details
                Row(
                  children: [
                    const Icon(Icons.class_,
                        color: Color.fromARGB(255, 1, 21, 32)),
                    const SizedBox(width: 8),
                    Text(
                      'Section: $section',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 3, 46, 67)),
                    const SizedBox(width: 8),
                    Text(
                      'Day: $day',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Color.fromARGB(255, 3, 52, 76)),
                    const SizedBox(width: 8),
                    Text(
                      'Time: $time',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color.fromARGB(255, 1, 45, 66)),
                    const SizedBox(width: 8),
                    Text(
                      'Room: $room',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
