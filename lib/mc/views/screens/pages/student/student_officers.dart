import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/student_officers2.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/add_officer_info.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';

class NemsuStudentOfficer extends StatefulWidget {
  const NemsuStudentOfficer({super.key});

  @override
  State<NemsuStudentOfficer> createState() => _NemsuStudentOfficerState();
}

class _NemsuStudentOfficerState extends State<NemsuStudentOfficer> {
  // Pre-defined departments with names and logo URLs or assets
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, String> uniqueDataCount = {};
  final Map<String, String> StudentDepartmentsCount = {};
  final Map<String, String> StudentOfficersCount = {};
  List<String> _commonEmails = [];
  List<String> _std = [];
  List<String> _dep = [];
  List<String> StudentDepartments = [];
  List<String> StudentOfficers = [];
  String _errorMessage = '';
  bool _isLoading = true;
  int depId = 0;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _getData();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _getData() async {
    try {
      // Check for connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _errorMessage =
              "No internet connection. Please check your connection.";
          _isLoading = false;
        });
        return; // Exit the function if there is no connection
      }
      try {
        QuerySnapshot usersSnapshot = await _firestore
            .collection('StudentDepartments')
            .orderBy('id')
            .get();
        StudentDepartments = usersSnapshot.docs.map((doc) {
          //store data to StudentDepartmentsCount array list
          StudentDepartmentsCount[doc['department']] =
              "${doc['logo']}[+]${doc['dept_description']}";
          return doc['department'] as String;
        }).toList();
        _isLoading = false;
      } on Exception catch (e) {
        _errorMessage += "Error fetching data.";
        _isLoading = false;
      }
      QuerySnapshot snapshot = await _firestore
          .collection('StudentOfficers')
          .orderBy('department')
          .get();
      StudentOfficers = snapshot.docs.map((doc) {
        StudentOfficersCount[doc['department']] =
            (StudentOfficersCount[doc['department']] ?? 0).toString();
        return doc['department'] as String;
      }).toList();
      if (StudentDepartmentsCount.length != StudentOfficersCount.length) {
        for (var std in StudentOfficersCount.entries) {
          try {
            QuerySnapshot querySnapshot = await _firestore
                .collection('StudentDepartments')
                .where('department', isEqualTo: std.key)
                .get();
            if (querySnapshot.docs.isEmpty && std.key.isNotEmpty) {
              // Create a new document with an auto-generated ID in the 'fruitsCollection'
              await _firestore.collection('StudentDepartments').add({
                'id': StudentDepartmentsCount.length,
                'department': std.key,
                'dept_description': std.key,
                'logo': StudentDepartmentsCount[std.key] =
                    await assetExists('assets/${std.key.toLowerCase()}.jpg') ==
                            true
                        ? 'assets/${std.key.toLowerCase()}.jpg'
                        : 'assets/images/logo.jpg',
              }).then((docRef) {
                print('Document added with ID: ${docRef.id}');
              }).catchError((error) {
                print('Failed to add document: $error');
              });
              StudentDepartmentsCount[std.key] =
                  await assetExists('assets/${std.key.toLowerCase()}.jpg') ==
                          true
                      ? 'assets/${std.key.toLowerCase()}.jpg[+]${std.key}'
                      : 'assets/images/logo.jpg[+]${std.key}';
            } else {
              print('Document with the same array already exists.');
            }
          } catch (e) {}
        }
      }
      setState(() {});
      _isLoading = false;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      StudentDepartmentsCount[e.toString()] =
          (StudentDepartmentsCount[e.toString()] ?? 0).toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<bool> assetExists(String path) async {
    try {
      // Attempt to load the asset
      await rootBundle.load(path);
      return true; // Asset exists
    } catch (e) {
      return false; // Asset does not exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: 'Student Leaders',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      backgroundColor: const Color.fromARGB(255, 178, 220, 248),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MainWidget(),
              // Header widget
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Student Leaders",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),

              // Grid view for displaying the departments
              _isLoading
                  ? Center(
                      child: Center(
                          child:
                              CircularProgressIndicator())) // Show loading indicator
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: StudentDepartmentsCount.length,
                      itemBuilder: (context, index) {
                        List<String> splitVal = StudentDepartmentsCount.values
                            .elementAt(index)
                            .split('[+]');
                        String departmentName =
                            StudentDepartmentsCount.keys.elementAt(index);
                        final departmentLogo = splitVal[0];
                        final departmentDescription = splitVal[1];

                        return _buildFacultyCard(
                          departmentName,
                          departmentDescription,
                          departmentLogo,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentOfficers2(
                                    department: departmentName),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: UserLog().getUserRole == 'admin' ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddStudentOfficerInfo(
                  department: '',
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

  Widget _buildFacultyCard(
      String title, String description, String imageAsset, VoidCallback onTap) {
    return GestureDetector(
      onLongPress: () async {
        if (UserLog().getUserRole == 'admin') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Action'),
                content:
                    Text('Do you want to reload Student Department list ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      final instance = FirebaseFirestore.instance;
                      final batch = instance.batch();
                      var collection =
                          instance.collection('StudentDepartments');
                      var snapshots = await collection.get();
                      for (var doc in snapshots.docs) {
                        batch.delete(doc.reference);
                      }
                      await batch.commit();
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NemsuStudentOfficer(),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {});
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      // onLongPress: () async {
      //   if (UserLog().getUserRole == 'admin') {
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) {
      //           return StudentDepartmentManager(
      //               department: title,
      //               description: description,
      //               departmentImage: imageAsset);
      //         },
      //       ),
      //     );
      //     if (result == true) {
      //       setState(() {
      //         _getData();
      //       });
      //     }
      //   } else {
      //     print('you are not an admin.');
      //   }
      // },
      onTap: onTap, //onTap, // Action when the card is clicked
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.0),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 18,
          color: Colors.lightBlueAccent,
          child: Container(
            height: 110,
            width: 40,
            child: Container(
              padding: EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Logo Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: imageAsset.contains('assets/')
                        ? Image.asset(
                            imageAsset,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.network(imageAsset,
                            width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 230,
                          child: Text(
                            description,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildFacultyCard(
  //     String title, String description, String imageAsset, VoidCallback onTap) {
  //   return GestureDetector(
  //     onLongPress: () async {
  //       if (UserLog().getUserRole == 'admin') {
  //         final result = await Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) {
  //               return StudentDepartmentManager(
  //                   department: title,
  //                   description: description,
  //                   departmentImage: imageAsset);
  //             },
  //           ),
  //         );
  //         if (result == true) {
  //           setState(() {
  //             _getData();
  //           });
  //         }
  //       } else {
  //         print('you are not an admin.');
  //       }
  //     },
  //     onDoubleTap: () {
  //       UserLog().getUserRole == 'admin'
  //           ? Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => StudentOfficersCite2(department: title),
  //               ),
  //             )
  //           : print('you are not an admin.');
  //     },
  //     onTap: onTap, // Action when the card is clicked
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.2),
  //             offset: const Offset(4, 4),
  //             blurRadius: 8,
  //             spreadRadius: 1,
  //           ),
  //         ],
  //       ),
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(width: 1.0),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         elevation: 8,
  //         color: Colors.lightBlueAccent,
  //         child: Container(
  //           height: 110,
  //           width: 50,
  //           child: Container(
  //             padding: EdgeInsets.only(left: 12),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 // Logo Image
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(50),
  //                   child: Image.asset(
  //                     imageAsset,
  //                     width: 80,
  //                     height: 80,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(10),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         title,
  //                         textAlign: TextAlign.left,
  //                         style: const TextStyle(
  //                           fontSize: 28,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Text(
  //                           title,
  //                           textAlign: TextAlign.left,
  //                           style: const TextStyle(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildFacultyCard(
  //     String title, String imageAsset, VoidCallback onTap) {
  //   return GestureDetector(
  //     onDoubleTap: () {
  //       UserLog().getUserRole == 'admin'
  //           ? Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => StudentOfficersCite2(department: title),
  //               ),
  //             )
  //           : print('you are not an admin.');
  //     },
  //     onTap: onTap, // Action when the card is clicked
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.2),
  //             offset: const Offset(4, 4),
  //             blurRadius: 8,
  //             spreadRadius: 1,
  //           ),
  //         ],
  //       ),
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         elevation: 8,
  //         color: Colors.lightBlueAccent,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // Logo Image
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(50),
  //                 child: Image.asset(
  //                   imageAsset,
  //                   width: 80,
  //                   height: 80,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               // Title
  //               Text(
  //                 title,
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
