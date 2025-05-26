import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/add_officer_info.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/student_officers_info.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';

class StudentOfficers2 extends StatefulWidget {
  final String department;
  StudentOfficers2({required this.department});

  @override
  State<StudentOfficers2> createState() => _StudentOfficers2State();
}

class _StudentOfficers2State extends State<StudentOfficers2> {
  // Pre-defined departments with names and logo URLs or assets
  final List<Map<String, String>> departments = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, int> uniqueDataCount = {};

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getData();
    }
  }

  Future<void> _getData() async {
    QuerySnapshot snapshot = await _firestore
        .collection('StudentOfficers')
        .where('department', isEqualTo: widget.department)
        .get();
    for (var doc in snapshot.docs) {
      String value =
          doc['officerType'].toString(); // Replace with your field name
      uniqueDataCount[value] = (uniqueDataCount[value] ?? 0); // Increment count
      print(value);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose(); // Clean up any resources
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: '${widget.department} Student Leaders',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      backgroundColor: const Color.fromARGB(255, 178, 220, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MainWidget(),
            // Header widget

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "${widget.department} Officers",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            // Grid view for displaying the departments
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: uniqueDataCount.length,
              itemBuilder: (context, index) {
                final pdepartment = uniqueDataCount.keys.elementAt(index);
                return _buildCITECard(
                  pdepartment,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentOfficerInfo(
                          department: widget.department,
                          program: pdepartment,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: UserLog().getUserRole == 'admin' ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddStudentOfficerInfo(
                  department: widget.department,
                  program: '',
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add), // Plus icon
        ),
      ),
    );
  }

  Widget _buildCITECard(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Action when the card is clicked
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          color: Colors.lightBlueAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width),
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
