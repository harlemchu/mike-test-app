import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReorderableStudentListManager extends StatefulWidget {
  final String department;
  final String program;

  const ReorderableStudentListManager(
      {super.key, required this.department, required this.program});
  @override
  _ReorderableStudentListManagerState createState() =>
      _ReorderableStudentListManagerState();
}

class _ReorderableStudentListManagerState
    extends State<ReorderableStudentListManager> {
  List<DocumentSnapshot> _docs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable List from Firestore'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('StudentOfficers')
            .where('department', isEqualTo: widget.department)
            .where('officerType', isEqualTo: widget.program)
            .orderBy('id')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found.'));
          }

          // Update the local list of documents
          _docs = snapshot.data!.docs;

          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final DocumentSnapshot movedItem = _docs.removeAt(oldIndex);
                _docs.insert(newIndex, movedItem);
              });

              // Optionally update Firestore with new order
              updateFirestoreOrder();
            },
            children: _docs.map((doc) {
              return ListTile(
                key: ValueKey(doc.id),
                leading: Container(
                  width: 50, // Set the width of the square
                  height: 50, // Set the height of the square
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
                      doc['imageUrl'], // Replace with your image URL
                      width: 70, // Optional: specify width
                      height: 70, // Optional: specify height
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // If the image is loaded, return the image
                        }
                        return Container(
                          width: 70, // Optional: specify width
                          height: 70, // Optional: specify height
                          child: Center(
                              child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
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
                title: Text(
                  doc['position'].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ), // Adjust based on your document structure
                subtitle: Text(doc['name'].toString()),
              );

              // ListTile(
              //   key: ValueKey(doc.id),
              //   title: Text(doc['name'] ??
              //       'No Name'), // Adjust based on your document structure
              //   subtitle: Text(
              //       '${doc['id'].toString()} ${doc['position'].toString()}'),
              // );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> updateFirestoreOrder() async {
    // Here you can implement logic to update the order in Firestore
    // For example, you might want to add an 'order' field to each document
    for (int index = 0; index < _docs.length; index++) {
      FirebaseFirestore.instance
          .collection('StudentOfficers')
          .doc(_docs[index].id)
          .update({'id': index}); // Update the order field
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MyReorderableList2 extends StatefulWidget {
//   final String department;
//   final String program;

//   const MyReorderableList2(
//       {super.key, required this.department, required this.program});
//   @override
//   _MyReorderableList2State createState() => _MyReorderableList2State();
// }

// class _MyReorderableList2State extends State<MyReorderableList2> {
//   List<DocumentSnapshot> _docs = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     if (mounted) {
//       _fetchItems();
//     }
//   }

//   Future<void> _fetchItems() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('StudentOfficers_backup') // Your collection name
//           .where('department', isEqualTo: widget.program)
//           .orderBy('name') // Order by the position field
//           .get();

//       setState(() {
//         _docs = snapshot.docs;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching items: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Reorderable List with Firebase'),
//         ),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reorderable List with Firebase'),
//       ),
//       body: ReorderableListView(
//         onReorder: _onReorder,
//         children: [
//           for (final doc in _docs)
//             ListTile(
//               key: ValueKey(doc.id),
//               title: Text(doc['name']),
//               subtitle:
//                   Text(doc['position']), // Change 'title' to your field name
//             ),
//         ],
//       ),
//     );
//   }

//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) newIndex--;
//       final item = _docs.removeAt(oldIndex);
//       _docs.insert(newIndex, item);
//     });
//     _updatePositions(); // Update Firestore after reordering
//   }

//   void _updatePositions() async {
//     for (int i = 0; i < _docs.length; i++) {
//       try {
//         await FirebaseFirestore.instance
//             .collection('NemsuInfo2')
//             .doc(_docs[i].id)
//             .update({'id': i}); // Update the position field
//       } catch (e) {
//         print('Error updating position: $e');
//       }
//     }
//   }
// }




// //   List<String> items = [
// //     'Item 1',
// //     'Item 2',
// //     'Item 3',
// //     'Item 4',
// //     'Item 5',
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Reorderable ListView'),
// //       ),
// //       body: ReorderableListView(
// //         onReorder: _onReorder,
// //         children: [
// //           for (final item in items)
// //             ListTile(
// //               key: ValueKey(item),
// //               title: Text(item),
// //               leading: Icon(Icons.drag_handle),
// //               trailing: Icon(Icons.arrow_forward),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _onReorder(int oldIndex, int newIndex) {
// //     setState(() {
// //       if (newIndex > oldIndex) newIndex--;
// //       final item = items.removeAt(oldIndex);
// //       items.insert(newIndex, item);
// //     });
// //   }
// // }