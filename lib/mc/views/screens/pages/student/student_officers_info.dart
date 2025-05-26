import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mike_test_app/mc/Utils/reorderable_student_list_manager.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/add_officer_info.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';

class StudentOfficerInfo extends StatelessWidget {
  final String department;
  final String program;
  const StudentOfficerInfo(
      {super.key, required this.department, required this.program});

  String collegeLogo(String logo) {
    switch (logo) {
      case 'USG':
        return 'assets/usg.jpg';
      case 'CITE':
        return 'assets/citelogo.png';
      case 'CTE':
        return 'assets/ctelogo.png';
      case 'CAS':
        return 'assets/caslogo.png';
      case 'CBM':
        return 'assets/cbm.jpg';
      case 'CET':
        return 'assets/cetlogo.png';
      default:
        break;
    }
    return 'assets/images/main.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: '$department Student Leaders',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      backgroundColor: const Color.fromARGB(255, 178, 220, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: Column(children: [
              // Top section with logo and background image
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(
                            'assets/images/main.png'), // Image path
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), // Transparency
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    height: 200,
                    width: double.infinity,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20.0,
                              offset: Offset(0.0, 0.0),
                              spreadRadius: 15.0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            collegeLogo(
                                department), // University logo (replace with your logo)
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ])),
            // Faculty List with "CITE FACULTY" on top
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.64, // Adjust this value as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "$program Officers",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StudentListWidget(
                        department: department,
                        program: program), // Your Faculty List widget
                  ),
                ],
              ),
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
                  department: department,
                  program: program,
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
}

class StudentListWidget extends StatelessWidget {
  final String department;
  final String program;
  const StudentListWidget({
    super.key,
    required this.department,
    required this.program,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('StudentOfficers')
            .where('officerLevel', isEqualTo: program)
            .orderBy('id')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If the future completed with an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data');
          }
          final facultyDocs = snapshot.data?.docs ?? [];

          if (facultyDocs.isEmpty) {
            return const Center(
              child: Text('No faculty members found.'),
            );
          }
          return ListView.builder(
            itemCount: facultyDocs.length,
            itemBuilder: (context, index) {
              // final doc = facultyDocs[index];
              // final docId = doc.id; // Get the document ID
              // final data =
              //     doc.data() as Map<String, dynamic>; // Get the document data

              final data = facultyDocs[index].data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            data['position'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                    ListTile(
                        leading: Container(
                          width: 50.0, // Set width
                          height: 50.0, // Set height (same as width for square)

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50.0), // Set the radius here

                            child: data['imageUrl'].isEmpty
                                ? Image.asset('assets/icons/profile.png')
                                : //Image.network(data['imageUrl']),
                                Image.network(
                                    fit: BoxFit.cover,
                                    data[
                                        'imageUrl'], // Replace with your image URL
                                    width: 70, // Optional: specify width
                                    height: 70, // Optional: specify height
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child; // If the image is loaded, return the image
                                      }
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/profile.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Center(
                                          child: Text(
                                              'Error loading image')); // Display an error message if the image fails to load
                                    },
                                  ),
                          ),
                        ),
                        title: Text(data['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['yearSec']),
                        trailing: Visibility(
                          visible:
                              UserLog().getUserRole == 'admin' ? true : false,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              UserLog().getUserRole == 'admin'
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Action'),
                                          content: Text(
                                              'Are you sure you want to proceed?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                // Perform the action here
                                                _deleteDocument(
                                                    'StudentOfficers',
                                                    facultyDocs[index].id);

                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : '';
                            },
                          ),
                        ),
                        onTap: () {
                          UserLog().getUserRole == 'admin'
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditStudentInfoForm(
                                      id: facultyDocs[index].id,
                                      currentName: data['name'],
                                      currentPosition: data['position'],
                                      currentImageUrl: data['imageUrl'],
                                      currentYear: data['yearSec'],
                                      currentDepartment: data['department'],
                                      currentProgram: data['officerLevel'],
                                    ),
                                  ),
                                )
                              : '';
                        },
                        onLongPress: () {
                          UserLog().isAdmin
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReorderableStudentListManager(
                                            department: department,
                                            program: program,
                                          )),
                                )
                              : '';
                        }),
                  ],
                ),
              );
            },
          );
        });
  }

  void _deleteDocument(String collection, String documentId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
