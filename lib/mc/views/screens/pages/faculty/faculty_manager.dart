import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/add_faculty_form.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/admin_faculty_details_screen.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/subject_card.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/user_faculty_details_screen.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';
import 'package:mike_test_app/mc/Utils/reorderable_faculty_list_manager.dart';

class FacultyManager extends StatefulWidget {
  final String department;
  FacultyManager({required this.department});

  @override
  State<FacultyManager> createState() => _FacultyManagerState();
}

class _FacultyManagerState extends State<FacultyManager> {
  late final isAdminRol;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdminRol = UserLog().getUserRole;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: '${widget.department} FACULTY MANAGEMENT',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      backgroundColor: const Color.fromARGB(255, 185, 223, 237),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  0.2, // Adjust this value as needed
              child: const MainWidget(),
            ),
            // Faculty List with "CITE FACULTY" on top
            Container(
              height: MediaQuery.of(context).size.height *
                  0.6, // Adjust this value as needed
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0), // Padding for the title
                    child: Text(
                      "${widget.department} FACULTY",
                      //"${widget.department} FACULTY", // Title at the top of the Faculty List
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FacultyListWidgetx(
                      department: widget.department,
                    ), // Your Faculty List widget
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isAdminRol == 'admin' ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddFacultyForm(department: widget.department),
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

class FacultyListWidgetx extends StatelessWidget {
  final String department;
  const FacultyListWidgetx({required this.department});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('faculty')
          .where('department', isEqualTo: department.toString())
          .orderBy('id')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final facultyDocs = snapshot.data?.docs ?? [];

        if (facultyDocs.isEmpty) {
          return const Center(
            child: Text('No faculty members found.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(3.0),
          itemCount: facultyDocs.length,
          itemBuilder: (context, index) {
            final data = facultyDocs[index].data() as Map<String, dynamic>;
            return FacultyCard(
              id: facultyDocs[index].id, // Pass document ID
              imageUrl: data['imageUrl'],
              name: data['name'],
              position: data['position'],
              department: department,
            );
          },
        );
      },
    );
  }
}

class FacultyCard extends StatelessWidget {
  final String id; // Document ID
  final String imageUrl;
  final String name;
  final String position;
  final String department;

  FacultyCard({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onLongPress: () {
                    UserLog().isAdmin
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReorderableFacultyListManager(
                                      department: department,
                                    )),
                          )
                        : '';
                    // showDialog(
                    //   context: context,
                    //   builder: (BuildContext context) {
                    //     return AlertDialog(
                    //       title: Text('Confirm Action'),
                    //       content: Text('Alert Message'),
                    //       actions: <Widget>[
                    //         TextButton(
                    //           child: Text('ok'),
                    //           onPressed: () {
                    //             Navigator.of(context).pop(); // Close the dialog
                    //           },
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                  },
                  onTap: () {
                    UserLog().getUserRole == 'admin'
                        ?
                        // Navigate to the details screen when the image is tapped
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AdminFacultyDetailsScreen(
                                imageUrl: imageUrl,
                                name: name,
                                position: position,
                                facultyId: id,
                              ),
                            ),
                          )
                        : Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserFacultyDetailsScreen(
                                imageUrl: imageUrl,
                                name: name,
                                position: position,
                                facultyId: id,
                              ),
                            ),
                          );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                10), // Match the ClipRRect border radius
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              imageUrl, // Replace with your image URL
                              width: 70, // Optional: specify width
                              height: 70, // Optional: specify height
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child; // If the image is loaded, return the image
                                }
                                return Container(
                                  width: 70, // Optional: specify width
                                  height: 70, // Optional: specify height
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  )),
                                );
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Center(
                                    child: Text(
                                        'Error loading image')); // Display an error message if the image fails to load
                              },
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          height: 80,
                          width: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.length > 20
                                    ? '${name.toUpperCase().substring(0, 20)}...'
                                    : name.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                position.length > 40
                                    ? '${position.toUpperCase().substring(0, 20)}...'
                                    : position.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Visibility(
                visible: UserLog().getUserRole == 'admin' ? true : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditFacultyForm(
                              id: id,
                              currentName: name,
                              currentPosition: position,
                              currentImageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
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
                                          _deleteDocument('faculty', id);
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

/////////////////////////////////////////////////////////
///

class FacultyCardBackUp extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  final String position;

  FacultyCardBackUp({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the details screen when the image is tapped
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FacultyDetailsScreen(
                    facultyId: id,
                    imageUrl: imageUrl,
                    name: name,
                    position: position,
                  ),
                ),
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            position,
            style: const TextStyle(
              fontSize: 8,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FacultyDetailsScreen extends StatelessWidget {
  final String facultyId;
  final String imageUrl;
  final String name;
  final String position;

  FacultyDetailsScreen({
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

                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: subjectDocs.map((doc) {
                              final subjectData =
                                  doc.data() as Map<String, dynamic>;
                              return SubjectCard(
                                subjectName:
                                    subjectData['subjectName'] ?? 'N/A',
                                section: subjectData['section'] ?? 'N/A',
                                day: subjectData['day'] ?? 'N/A',
                                time: subjectData['time'] ?? 'N/A',
                                room: subjectData['room'] ?? 'N/A',
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
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
