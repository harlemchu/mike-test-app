import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/faculty_manager.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/subject_card.dart';

class UserFacultyDetailsScreen extends StatelessWidget {
  final String facultyId;
  final String imageUrl;
  final String name;
  final String position;

  UserFacultyDetailsScreen({
    required this.facultyId,
    required this.imageUrl,
    required this.name,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Details"),
        backgroundColor: const Color(0xFF002855), // NEMSU blue
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7FAFF), // Light background for body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Faculty Information Section
            Container(
              color: const Color(0xFF002855), // NEMSU blue
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    position,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Subjects Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subjects Assigned",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002855), // NEMSU blue
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Subjects Data in Card Format
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('faculty')
                  .doc(facultyId)
                  .collection('subjects')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  // If the future completed with an error
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No data');
                }
                final subjectDocs = snapshot.data?.docs ?? [];

                if (subjectDocs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "No subjects assigned.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: subjectDocs.map((doc) {
                      final subjectData = doc.data() as Map<String, dynamic>;
                      return SubjectCard(
                        subjectName: subjectData['subjectName'] ?? 'N/A',
                        section: subjectData['section'] ?? 'N/A',
                        day: subjectData['day'] ?? 'N/A',
                        time: subjectData['time'] ?? 'N/A',
                        room: subjectData['room'] ?? 'N/A',
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}
