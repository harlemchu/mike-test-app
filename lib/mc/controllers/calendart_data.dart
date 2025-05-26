import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventListWithService extends StatelessWidget {
  final Function(BuildContext, DocumentSnapshot?) showEventDialog;
  final bool isViewer;

  EventListWithService({required this.showEventDialog, this.isViewer = false});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getEventsStream() {
    return _firestore.collection('events').orderBy('date').snapshots();
  }

  Future<void> addEvent(String title, String description, DateTime date,
      String venue, String time) async {
    if (!isViewer) {
      await _firestore.collection('events').add({
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'venue': venue,
        'time': time,
      });
    }
  }

  Future<void> editEvent(String eventId, String title, String description,
      DateTime date, String venue, String time) async {
    if (!isViewer) {
      await _firestore.collection('events').doc(eventId).update({
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'venue': venue,
        'time': time,
      });
    }
  }

  Future<void> deleteEvent(String eventId) async {
    if (!isViewer) {
      await _firestore.collection('events').doc(eventId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading state
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Error state
        } else if (!snapshot.hasData) {
          return Text('No data'); // No data state
        }
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            print('=================; $event["id"]');
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.lightBlueAccent.shade100,
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  event['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "${event['description']}\nVenue: ${event['venue']}\nTime: ${event['time']}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                trailing: isViewer
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showEventDialog(context, event),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      child: Text(
                                          'Are you sure you want to delete ${event["title"]}?'),
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
                                          deleteEvent(event.id);
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          // Add your confirm action here
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    '${event["title"]} successfully deleted.')),
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
                        ],
                      ),
                onTap: () => showEventDialog(context, event),
              ),
            );
          },
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EventListWithService extends StatelessWidget {
//   final Function(BuildContext, DocumentSnapshot?) showEventDialog;
//   final bool isViewer; // New parameter to distinguish between Admin and Viewer

//   EventListWithService({required this.showEventDialog, this.isViewer = false});

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<QuerySnapshot> getEventsStream() {
//     return _firestore.collection('events').orderBy('date').snapshots();
//   }

//   // Add an event to Firestore (only for Admins)
//   Future<void> addEvent(String title, String description, DateTime date) async {
//     if (!isViewer) {
//       await _firestore.collection('events').add({
//         'title': title,
//         'description': description,
//         'date': Timestamp.fromDate(date),
//       });
//     }
//   }

//   // Edit an existing event (only for Admins)
//   Future<void> editEvent(
//       String eventId, String title, String description, DateTime date) async {
//     if (!isViewer) {
//       await _firestore.collection('events').doc(eventId).update({
//         'title': title,
//         'description': description,
//         'date': Timestamp.fromDate(date),
//       });
//     }
//   }

//   // Delete an event (only for Admins)
//   Future<void> deleteEvent(String eventId) async {
//     if (!isViewer) {
//       await _firestore.collection('events').doc(eventId).delete();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: getEventsStream(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }
//         final events = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: events.length,
//           itemBuilder: (context, index) {
//             final event = events[index];
//             return Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               elevation: 4,
//               margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               color: Colors.lightBlueAccent.shade100, // Background color
//               child: ListTile(
//                 contentPadding: EdgeInsets.all(15),
//                 title: Text(
//                   event['title'],
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 subtitle: Text(
//                   event['description'],
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 trailing: isViewer
//                     ? null // No buttons for viewers
//                     : Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () => showEventDialog(context, event),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => deleteEvent(event.id),
//                           ),
//                         ],
//                       ),
//                 onTap: () => showEventDialog(context, event),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
