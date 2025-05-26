import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StudentDepartmentManager extends StatefulWidget {
  final String department;
  final String description;
  final String departmentImage;
  StudentDepartmentManager(
      {super.key,
      required this.department,
      required this.description,
      required this.departmentImage});

  @override
  State<StudentDepartmentManager> createState() =>
      _StudentDepartmentManagerState();
}

class _StudentDepartmentManagerState extends State<StudentDepartmentManager> {
  var _nameController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _imageController;
  final _studentDepartmentManagerformKey = GlobalKey<FormState>();
  File? _image;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.department);
    _descriptionController = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
  }

  Future<String> _uploadImage(File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('Student_Officers')
        .child('${DateTime.now().toIso8601String()}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _updateStudentDepartmentData(
      String logo, String description) async {
    // Query the Firestore collection
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await _firestore
        .collection('StudentDepartments')
        .where('department', isEqualTo: widget.department)
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Loop through the documents and print their IDs
      for (var doc in querySnapshot.docs) {
        CollectionReference users =
            FirebaseFirestore.instance.collection('StudentDepartments');

        try {
          await users.doc(doc.id).update({
            'dept_description': description,
            'logo': logo,
          });
          print("Link  updated successfully");
        } catch (e) {
          print("Error updating Link: $e");
        }
      }
    } else {
      print("No documents found for department: ${widget.department}");
    }
  }

  Future<void> _saveFaculty() async {
    if (_studentDepartmentManagerformKey.currentState!.validate()) {
      try {
        String? imageUrl;
        if (_image == null) {
          imageUrl = widget.departmentImage;
        } else {
          imageUrl = await _uploadImage(_image!);
        }

        _updateStudentDepartmentData(imageUrl, _descriptionController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${widget.department} Faculty added successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.department} Department'),
      ),
      backgroundColor: Color.fromARGB(255, 203, 207, 245),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _studentDepartmentManagerformKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? widget.departmentImage == '' ||
                              widget.departmentImage.isEmpty
                          ? Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[300],
                              child: const Icon(Icons.add_a_photo, size: 50),
                            )
                          : widget.departmentImage.contains('http')
                              ? Image.network(
                                  widget.departmentImage,
                                  width: 150,
                                  height: 150,
                                )
                              : Image.asset(
                                  widget
                                      .departmentImage, // University logo (replace with your logo)
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                )
                      : Image.file(_image!, width: 150, height: 150),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Department(Acronym)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Acronym of Department name.)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Defination...'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Acronym's defination";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveFaculty,
                  child: const Text('Update Faculty'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class EditFacultyForm extends StatefulWidget {
//   final String id;
//   final String currentName;
//   final String currentPosition;
//   final String currentImageUrl;

//   EditFacultyForm({
//     required this.id,
//     required this.currentName,
//     required this.currentPosition,
//     required this.currentImageUrl,
//   });

//   @override
//   _EditFacultyFormState createState() => _EditFacultyFormState();
// }

// class _EditFacultyFormState extends State<EditFacultyForm> {
//   late TextEditingController _nameController;
//   late TextEditingController _positionController;
//   File? _newImage;
//   bool _isUpdating = false;

//   @override
//   void initState() {
//     _nameController = TextEditingController(text: widget.currentName);
//     _positionController = TextEditingController(text: widget.currentPosition);
//     super.initState();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _newImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _updateFaculty() async {
//     setState(() {
//       _isUpdating = true;
//     });

//     try {
//       String imageUrl = widget.currentImageUrl;

//       // If a new image is selected, upload it
//       if (_newImage != null) {
//         final ref = FirebaseStorage.instance
//             .ref()
//             .child('faculty_images')
//             .child('${DateTime.now().toIso8601String()}.jpg');
//         await ref.putFile(_newImage!);
//         imageUrl = await ref.getDownloadURL();
//       }

//       // Update Firestore document
//       await FirebaseFirestore.instance
//           .collection('faculty')
//           .doc(widget.id)
//           .update({
//         'name': _nameController.text,
//         'position': _positionController.text,
//         'imageUrl': imageUrl,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Faculty updated successfully!')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() {
//         _isUpdating = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Faculty'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: _newImage == null
//                   ? Image.network(
//                       widget.currentImageUrl,
//                       width: 150,
//                       height: 150,
//                     )
//                   : Image.file(_newImage!, width: 150, height: 150),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _positionController,
//               decoration: const InputDecoration(labelText: 'Position'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isUpdating ? null : _updateFaculty,
//               child: _isUpdating
//                   ? const CircularProgressIndicator()
//                   : const Text('Update Faculty'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
