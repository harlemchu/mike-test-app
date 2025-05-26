import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddStudentOfficerInfo extends StatefulWidget {
  final String department;
  final String program;
  AddStudentOfficerInfo(
      {super.key, required this.department, required this.program});

  @override
  State<AddStudentOfficerInfo> createState() => _AddStudentOfficerInfoState();
}

class _AddStudentOfficerInfoState extends State<AddStudentOfficerInfo> {
  final _nameController = TextEditingController();
  final _programController = TextEditingController();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _yearSecController = TextEditingController();
  final _studentManagerformKey = GlobalKey<FormState>();
  File? _image;
  bool isLoading = false;
  bool isOthers = false;
  String? selectedPosition;
  String? selectedYear;
  List<String> countries = [
    'Governor',
    'Vice Governor',
    'Secretary',
    'Assistant Secretary',
    'Treasurer',
    'Assistant Treasurer',
    'Auditor',
    'P.I.O.’s',
    'Business Managers',
    'Sergeant at Arms',
    'Event Planning Officer',
    'Multimedia Officers',
    'Marshals',
    'Mayor',
    'Vice Mayor',
    'Others'
  ];
  List<String> year = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
  ];

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
    final ref = FirebaseStorage.instance
        .ref()
        .child('Student_Officers')
        .child('${DateTime.now().toIso8601String()}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _saveOfficer() async {
    // if (_formKey.currentState!.validate() && _image != null) {
    if (_studentManagerformKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });
      late String imageUrl;
      try {
        if (_image == null) {
          imageUrl = '';
        } else {
          imageUrl = await _uploadImage(_image!);
        }
        QuerySnapshot StudentOfficersCount = await FirebaseFirestore.instance
            .collection('StudentOfficers')
            .get();
        await FirebaseFirestore.instance.collection('StudentOfficers').add({
          'id': StudentOfficersCount.docs.length + 1,
          'department': _departmentController.text,
          'officerLevel': _programController.text,
          'officerType': _programController.text,
          'yearSec': selectedYear,
          'name': _nameController.text,
          'position': selectedPosition.toString() == 'Others'
              ? _positionController.text
              : selectedPosition.toString(),
          'imageUrl': imageUrl,
        });
        print(StudentOfficersCount.docs.length + 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${widget.department} Officer added successfully!')),
        );
        setState(() {
          isLoading = false; // Stop loading after response
        });
        Navigator.pop(context);
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
        title: Text(
            'Add ${widget.program.isEmpty ? 'New' : widget.program} Officer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _studentManagerformKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Container(
                          width: 150,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.add_a_photo, size: 50),
                        )
                      : Image.file(_image!, width: 150, height: 150),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  hint: Text('Select year'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: year.map((String y) {
                    return DropdownMenuItem<String>(
                      value: y,
                      child: Text(y),
                    );
                  }).toList(),
                ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   controller: _yearSecController,
                //   decoration: const InputDecoration(labelText: 'Year'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter a name';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: widget.program.isEmpty ? true : false,
                  controller: _programController,
                  decoration: const InputDecoration(labelText: 'Program'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Program';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedPosition,
                  hint: Text('Select position'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPosition = newValue;
                      if (selectedPosition == 'Others') {
                        isOthers = true;
                      } else {
                        isOthers = false;
                      }
                    });
                  },
                  items: countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: isOthers == true ? true : false,
                  child: TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(labelText: 'Position'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Position';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: widget.department.isEmpty ? true : false,
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveOfficer,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Add ${widget.program.isEmpty ? 'New' : widget.program} Officer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditStudentInfoForm extends StatefulWidget {
  final String id;
  final String currentName;
  final String currentYear;
  final String currentDepartment;
  final String currentProgram;
  final String currentPosition;
  final String currentImageUrl;

  EditStudentInfoForm({
    required this.id,
    required this.currentName,
    required this.currentPosition,
    required this.currentImageUrl,
    required this.currentYear,
    required this.currentDepartment,
    required this.currentProgram,
  });

  @override
  _EditStudentInfoFormState createState() => _EditStudentInfoFormState();
}

class _EditStudentInfoFormState extends State<EditStudentInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _programController;
  late TextEditingController _yearSecController;
  late TextEditingController _departmentController;
  File? _newImage;
  bool _isUpdating = false;
  String? widgetcurrentName;
  String? widgetcurrentProgram;
  String? widgetcurrentDepartment;
  bool isOthers = false;
  String? selectedYear;

  List<String> year = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
  ];

  List<String> countries = [
    'Governor',
    'Vice Governor',
    'Secretary',
    'Assistant Secretary',
    'Treasurer',
    'Assistant Treasurer',
    'Auditor',
    'P.I.O.’s',
    'Business Managers',
    'Sergeant at Arms',
    'Event Planning Officer',
    'Multimedia Officers',
    'Marshals',
    'Mayor',
    'Vice Mayor',
    'Others'
  ];
  String? selectedPosition;
  @override
  void initState() {
    selectedPosition = countries.contains(widget.currentPosition)
        ? widget.currentPosition
        : null;
    // selectedPosition = widget.currentPosition;
    _nameController = TextEditingController(text: widget.currentName);
    _positionController = TextEditingController(text: widget.currentPosition);
    _programController = TextEditingController(text: widget.currentProgram);
    _yearSecController = TextEditingController(text: widget.currentYear);
    _departmentController =
        TextEditingController(text: widget.currentDepartment);
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      print(pickedFile.toString());
      if (pickedFile != null) {
        setState(() {
          _newImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e.toString());
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
            .child('Student_Officers')
            .child('${DateTime.now().toIso8601String()}.jpg');
        await ref.putFile(_newImage!);
        imageUrl = await ref.getDownloadURL();
      }

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('StudentOfficers')
          .doc(widget.id)
          .update({
        'name': _nameController.text,
        'position': selectedPosition,
        'imageUrl': imageUrl,
        'department': _departmentController.text,
        'officerLevel': _programController.text,
        'officerType': _programController.text,
        'yearSec': _yearSecController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faculty updated successfully!')),
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
        title: const Text('Edit Officer info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _newImage == null
                    ? widget.currentImageUrl == ''
                        ? Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo, size: 50),
                          )
                        : widget.currentImageUrl.contains('http')
                            ? Image.network(
                                widget.currentImageUrl,
                                width: 150,
                                height: 150,
                              )
                            : Image.asset(
                                widget
                                    .currentImageUrl, // University logo (replace with your logo)
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )
                    : Image.file(_newImage!, width: 150, height: 150),
                //Image.file(_newImage!, width: 150, height: 150),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (String? newValue) {
                  setState(() {
                    widgetcurrentName = newValue;
                  });
                },
                controller: _nameController
                  ..text = widgetcurrentName ?? widget.currentName,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: year.contains(widget.currentYear) == false
                    ? 'First Year'
                    : selectedYear,
                hint: Text('Select year'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                items: year.map((String y) {
                  return DropdownMenuItem<String>(
                    value: y,
                    child: Text(y),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (String? newValue) {
                  setState(() {
                    widgetcurrentProgram = newValue;
                  });
                },
                controller: _programController
                  ..text = widgetcurrentProgram ?? widget.currentProgram,
                decoration: const InputDecoration(labelText: 'Program'),
              ),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: countries.contains(widget.currentPosition) == false
                    ? 'Others'
                    : selectedPosition,
                hint: Text('Select position'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPosition = newValue;
                    if (selectedPosition == 'Others') {
                      isOthers = true;
                    } else {
                      isOthers = false;
                    }
                  });
                },
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: isOthers == true ? true : false,
                child: TextFormField(
                  controller: _positionController,
                  decoration: const InputDecoration(labelText: 'Position'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Position';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Visibility(
              //   visible: isOthers == true ? true : false,
              //   child: TextFormField(
              //     controller: _positionController
              //       ..text = widget.currentPosition,
              //     decoration: const InputDecoration(labelText: 'Position'),
              //   ),
              // ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (String? newValue) {
                  setState(() {
                    widgetcurrentDepartment = newValue;
                  });
                },
                controller: _departmentController
                  ..text = widgetcurrentDepartment ?? widget.currentDepartment,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUpdating ? null : _updateFaculty,
                child: _isUpdating
                    ? const CircularProgressIndicator()
                    : const Text('Update Officer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
