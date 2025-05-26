import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/add_faculty_form.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/faculty_manager.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';

class FacultyPage extends StatefulWidget {
  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';
  bool _isLoading = true;

  final Map<String, String> uniqueDataCount = {};
  final Map<String, String> FacultyDepartmentsCount = {};
  final Map<String, String> FacultyCount = {};
  List<String> _std = [];
  List<String> _dep = [];
  List<String> StudentDepartments = [];
  List<String> StudentOfficers = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getData();
    }
  }

  Future<void> _getData() async {
    // Check for connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _errorMessage = "No internet connection. Please check your connection.";
        print(_errorMessage);
        _isLoading = false;
      });
      return; // Exit the function if there is no connection
    }
    try {
      QuerySnapshot usersSnapshot =
          await _firestore.collection('FacultyDepartments').orderBy('id').get();
      StudentDepartments = usersSnapshot.docs.map((doc) {
        FacultyDepartmentsCount[doc['department']] =
            "${doc['logo']}[+]${doc['dept_description']}";
        return doc['department'] as String;
      }).toList();
      _isLoading = false;

      QuerySnapshot snapshot =
          await _firestore.collection('faculty').orderBy('department').get();
      StudentOfficers = snapshot.docs.map((doc) {
        FacultyCount[doc['department']] =
            (FacultyCount[doc['department']] ?? 0).toString();
        return doc['department'] as String;
      }).toList();
      if (FacultyDepartmentsCount.length != FacultyCount.length) {
        for (var std in FacultyCount.entries) {
          try {
            QuerySnapshot querySnapshot = await _firestore
                .collection('FacultyDepartments')
                .where('department', isEqualTo: std.key)
                .get();
            if (querySnapshot.docs.isEmpty) {
              // Create a new document with an auto-generated ID in the 'fruitsCollection'
              await _firestore.collection('FacultyDepartments').add({
                'id': FacultyDepartmentsCount.length,
                'department': std.key,
                'dept_description': std.key,
                'logo': FacultyDepartmentsCount[std.key] =
                    await assetExists('assets/${std.key.toLowerCase()}.jpg') ==
                            true
                        ? 'assets/${std.key.toLowerCase()}.jpg'
                        : 'assets/images/logo.jpg',
              }).then((docRef) {
                print('Document added with ID: ${docRef.id}');
              }).catchError((error) {
                print('Failed to add document: $error');
              });
              FacultyDepartmentsCount[std.key] =
                  await assetExists('assets/${std.key.toLowerCase()}.jpg') ==
                          true
                      ? 'assets/${std.key.toLowerCase()}.jpg[+]${std.key}'
                      : 'assets/images/logo.jpg[+]${std.key}';
            } else {
              print('Document with the same array already exists.');
            }
          } catch (e) {}
          _isLoading = false;
        }
      }
      setState(() {});
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      FacultyDepartmentsCount[e.toString()] =
          (FacultyDepartmentsCount[e.toString()] ?? 0).toString();
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
      appBar: CustomAppBar(
          title: 'Department List',
          onBackPressed: () {
            Navigator.pop(context);
          }),
      drawer: CustomDrawer(),
      body:
          // _isLoading
          //     ? Center(child: CircularProgressIndicator())
          //     : _errorMessage.isNotEmpty
          //         ? Center(child: Text(_errorMessage))
          //         :
          SingleChildScrollView(
        child: Column(
          children: [
            const MainWidget(),
            // Header widget
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Faculty Departments",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: Center(
                        child:
                            CircularProgressIndicator())) // Show loading indicator
                :
                // Grid view for displaying the departments
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: FacultyDepartmentsCount.length,
                    itemBuilder: (context, index) {
                      print(FacultyDepartmentsCount);
                      List<String> splitVal = FacultyDepartmentsCount.values
                          .elementAt(index)
                          .split('[+]');
                      String departmentName =
                          FacultyDepartmentsCount.keys.elementAt(index);
                      final departmentLogo = splitVal[0];
                      final String departmentDescription = splitVal[1];

                      return _buildFacultyCard(
                        departmentName,
                        departmentDescription,
                        departmentLogo,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FacultyManager(
                                department: departmentName,
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
            final res = Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddFacultyForm(
                  department: '',
                ),
              ),
            );
            if (res == true) {
              setState(() {
                _getData();
              });
            }
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
                    Text('Do you want to reload Faculty Department list ?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () async {
                      final instance = FirebaseFirestore.instance;
                      final batch = instance.batch();
                      var collection =
                          instance.collection('FacultyDepartments');
                      var snapshots = await collection.get();
                      for (var doc in snapshots.docs) {
                        batch.delete(doc.reference);
                      }
                      await batch.commit();
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FacultyPage(),
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
          elevation: 8,
          color: Colors.lightBlueAccent,
          child: Container(
            height: 110,
            width: 50,
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
                    padding: EdgeInsets.all(10),
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
                          width: 220,
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
}
