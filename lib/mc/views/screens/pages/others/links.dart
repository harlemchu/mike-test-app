import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UniversityLinks extends StatefulWidget {
  const UniversityLinks({super.key});

  @override
  State<UniversityLinks> createState() => _UniversityLinksState();
}

class _UniversityLinksState extends State<UniversityLinks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: 'University Links',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      backgroundColor: const Color.fromARGB(255, 48, 148, 185),
      body: UniversityLinksStateData(),
      floatingActionButton: Visibility(
        visible: UserLog().isAdmin == true ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => EditableDialog(
                          docId: '',
                          eventName: '',
                          eventLink: '',
                          action: 'Add',
                        )));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add), // Plus icon
        ),
      ),
    );
  }
}

class UniversityLinksStateData extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UniversityLinksStateData({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('university_links').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data found'));
        }

        final documents = snapshot.data!.docs;
        // Display the data
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            String eventName = doc['name'];
            String eventLink = doc['link'];
            String id = doc.id;
            final Uri uri = Uri.parse(eventLink);

            return Container(
              padding: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(3.0),
                margin: EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon((Icons.link)),
                  title: Text(
                    eventName,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: eventLink.length > 28
                      ? Text(
                          eventLink.substring(0, 28) + '...',
                          style: TextStyle(color: Colors.blue),
                        )
                      : Text(eventLink, style: TextStyle(color: Colors.blue)),
                  trailing: Visibility(
                    visible: UserLog().isAdmin ?? false,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm'),
                              content: Container(
                                child: Text(
                                    'Are you sure you want to dele $eventName?'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Handle the cancel action
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Handle the confirm action

                                    await FirebaseFirestore.instance
                                        .collection('university_links')
                                        .doc(id)
                                        .delete();
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    // Add your confirm action here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Link deleted successfully')),
                                    );
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  //Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () async {
                    print(eventLink);
                    try {
                      nemsuniteLaunchURL(eventLink.toString(), context);
                      // if (!await canLaunchUrl(uri)) {
                      //   await launchUrl(uri);
                      // mode:
                      // LaunchMode.externalApplication;
                      // } else {
                      //   throw 'Could not launch $uri';
                      // }
                    } catch (e) {
                      print('Could not launch $e');
                    }
                  },
                  onLongPress: () {
                    print(eventName);
                    UserLog().isAdmin
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EditableDialog(
                                    docId: id,
                                    eventName: eventName,
                                    eventLink: eventLink,
                                    action: 'Update')))
                        : '';
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Future<void> launchURL(String url) async {
  //   try {
  //     if (await canLaunch(url)) {
  //       await launch(url);
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   } on Exception catch (e) {
  //     // TODO
  //   }
  // }
  Future<void> nemsuniteLaunchURL(String url, cntxt) async {
    // Regular expression to validate the URL
    final Uri? uri = Uri.tryParse(url);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      // If the URL is valid, launch it
      try {
        await launch(uri.toString());
      } catch (e) {
        print('Error launching URL: $e');
      }
    } else {
      // Show an error message if the URL is invalid
      print('Invalid URL: $url');
      showDialog(
        context: cntxt,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('Invalid URL: $url'),
            actions: <Widget>[
              TextButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showDialog(BuildContext context) {}
}

class EditableDialog extends StatefulWidget {
  final String docId;
  final String eventName;
  final String eventLink;
  final String action;
  const EditableDialog(
      {super.key,
      required this.docId,
      required this.eventName,
      required this.eventLink,
      required this.action});

  @override
  _EditableDialogState createState() => _EditableDialogState();
}

class _EditableDialogState extends State<EditableDialog> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _linkcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.all(1),
          child: AlertDialog(
            title: Text('Enter Link'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _namecontroller..text = widget.eventName,
                  decoration:
                      InputDecoration(hintText: "Enter your Website name"),
                ),
                TextField(
                  controller: _linkcontroller..text = widget.eventLink,
                  decoration:
                      InputDecoration(hintText: "Enter your Website link"),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text(widget.action),
                onPressed: () {
                  //_saveData();
                  widget.action == 'Add'
                      ? _saveData()
                      : updateUser(widget.docId, _namecontroller.text,
                          _linkcontroller.text);
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveData() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('university_links');
    if (_namecontroller.text.isEmpty) {
      print("Link  saved not successfully");
    } else {
      // Adding a new user
      await users.add({
        'name': _namecontroller.text,
        'link': _linkcontroller.text,
      });
      print("Link  saved successfully");
    }
  }

  Future<void> updateUser(String linkId, String newName, String newLink) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('university_links');

    try {
      await users.doc(linkId).update({
        'name': newName,
        'link': newLink,
      });
      print("Link  updated successfully");
    } catch (e) {
      print("Error updating Link: $e");
    }
  }

  void readData() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('university_links');

    // Fetching data once
    QuerySnapshot querySnapshot = await users.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(querySnapshot.docs);
    // Listening for real-time updates
    users.snapshots().listen((snapshot) {
      snapshot.docs.forEach((doc) {
        // print(doc.data());
      });
    });
  }
}
