import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mike_test_app/mc/Utils/userlog.dart';

class AddFacultyForm extends StatefulWidget {
  final String department;

  const AddFacultyForm({super.key, required this.department});
  @override
  _AddFacultyFormState createState() => _AddFacultyFormState();
}

class _AddFacultyFormState extends State<AddFacultyForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _facultyManagerformKey = GlobalKey<FormState>();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    if (image == null || image == '') {
      return UserLog().getUserDefaultProfile;
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child('faculty_images')
        .child('${DateTime.now().toIso8601String()}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _saveFaculty() async {
    if (_facultyManagerformKey.currentState!.validate()) {
      try {
        late String imageUrl;
        if (_image == null) {
          imageUrl = UserLog().getUserDefaultProfile;
        } else {
          imageUrl = await _uploadImage(_image!);
        }
        QuerySnapshot querySnapshot =
            await _firestore.collection('faculty').get();
        await FirebaseFirestore.instance.collection('faculty').add({
          'id': querySnapshot.docs.length,
          'name': _nameController.text,
          'position': _positionController.text,
          'imageUrl': imageUrl,
          'department': _departmentController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Faculty added successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Faculty'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _facultyManagerformKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.add_a_photo, size: 50),
                        )
                      : Image.file(_image!, width: 150, height: 150),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _positionController,
                  decoration: InputDecoration(labelText: 'Position'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a position';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.department.isEmpty == true
                      ? _departmentController
                      : _departmentController
                    ..text = widget.department,
                  decoration: InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Department';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveFaculty,
                  child: Text('Add Faculty'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditFacultyForm extends StatefulWidget {
  final String id;
  final String currentName;
  final String currentPosition;
  final String currentImageUrl;

  EditFacultyForm({
    required this.id,
    required this.currentName,
    required this.currentPosition,
    required this.currentImageUrl,
  });

  @override
  _EditFacultyFormState createState() => _EditFacultyFormState();
}

class _EditFacultyFormState extends State<EditFacultyForm> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  File? _newImage;
  bool _isUpdating = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentName);
    _positionController = TextEditingController(text: widget.currentPosition);
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateFaculty() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      String imageUrl = widget.currentImageUrl;

      // If a new image is selected, upload it
      if (_newImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('faculty_images')
            .child('${DateTime.now().toIso8601String()}.jpg');
        await ref.putFile(_newImage!);
        imageUrl = await ref.getDownloadURL();
      }

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(widget.id)
          .update({
        'name': _nameController.text,
        'position': _positionController.text,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Faculty updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Faculty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _newImage == null
                  ? Image.network(
                      widget.currentImageUrl,
                      width: 150,
                      height: 150,
                    )
                  : Image.file(_newImage!, width: 150, height: 150),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _positionController,
              decoration: InputDecoration(labelText: 'Position'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUpdating ? null : _updateFaculty,
              child: _isUpdating
                  ? CircularProgressIndicator()
                  : Text('Update Faculty'),
            ),
          ],
        ),
      ),
    );
  }
}
