import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFacultyDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String facultyId; // Pass faculty document ID

  AdminFacultyDetailsScreen({
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.facultyId,
  });

  @override
  _AdminFacultyDetailsScreenState createState() =>
      _AdminFacultyDetailsScreenState();
}

class _AdminFacultyDetailsScreenState extends State<AdminFacultyDetailsScreen> {
  final _subjectNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();
  final _roomController = TextEditingController();
  final GlobalKey<FormState> _editsubjectformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addsubjectformKey = GlobalKey<FormState>();

  Future<void> _addSubject() async {
    if (_addsubjectformKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('faculty')
            .doc(widget.facultyId)
            .collection('subjects')
            .add({
          'subjectName': _subjectNameController.text,
          'section': _sectionController.text,
          'day': _dayController.text,
          'time': _timeController.text,
          'room': _roomController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subject added successfully!')),
        );
        _subjectNameController.clear();
        _sectionController.clear();
        _dayController.clear();
        _timeController.clear();
        _roomController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _editSubject(
      BuildContext context, String subjectId, Map<String, dynamic> data) {
    _subjectNameController.text = data['subjectName'];
    _sectionController.text = data['section'];
    _dayController.text = data['day'];
    _timeController.text = data['time'];
    _roomController.text = data['room'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Subject'),
        content: Form(
          key: _editsubjectformKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectNameController,
                  decoration: InputDecoration(labelText: 'Subject Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subject name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _sectionController,
                  decoration: InputDecoration(labelText: 'Section'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the section';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _dayController,
                  decoration: InputDecoration(labelText: 'Day'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the day';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _roomController,
                  decoration: InputDecoration(labelText: 'Room'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the room';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_editsubjectformKey.currentState!.validate()) {
                try {
                  await FirebaseFirestore.instance
                      .collection('faculty')
                      .doc(widget.facultyId)
                      .collection('subjects')
                      .doc(subjectId)
                      .update({
                    'subjectName': _subjectNameController.text,
                    'section': _sectionController.text,
                    'day': _dayController.text,
                    'time': _timeController.text,
                    'room': _roomController.text,
                  });
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Subject updated successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.name}\'s Details'),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFF0078D7), // NEMSU blue background color
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.position,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _editsubjectformKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _subjectNameController,
                          decoration: InputDecoration(
                            labelText: 'Subject Name',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the subject name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addSubject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF0078D7),
                          ),
                          child: Text('Add Subject'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Subjects',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('faculty')
                        .doc(widget.facultyId)
                        .collection('subjects')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final subjectDocs = snapshot.data?.docs ?? [];

                      if (subjectDocs.isEmpty) {
                        return Text('No subjects found.');
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: subjectDocs.length,
                        itemBuilder: (context, index) {
                          final doc = subjectDocs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          return Card(
                            color: Colors.white,
                            elevation: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Subject: ${data['subjectName']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Section: ${data['section']}'),
                                  Text('Day: ${data['day']}'),
                                  Text('Time: ${data['time']}'),
                                  Text('Room: ${data['room']}'),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () =>
                                            _editSubject(context, doc.id, data),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('faculty')
                                              .doc(widget.facultyId)
                                              .collection('subjects')
                                              .doc(doc.id)
                                              .delete();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
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
          ),
        ));
  }
}
