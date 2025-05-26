import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/controllers/calendart_data.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';

// Import the combined file
class AdminCalendarPage extends StatelessWidget {
  AdminCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendar of Activities',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          MainWidget(),
          Expanded(
            child: EventListWithService(
              showEventDialog: _showEventDialog,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(context, null),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEventDialog(BuildContext context, DocumentSnapshot? event) {
    final TextEditingController titleController =
        TextEditingController(text: event?.get('title') ?? '');
    final TextEditingController descController =
        TextEditingController(text: event?.get('description') ?? '');
    final TextEditingController venueController =
        TextEditingController(text: event?.get('venue') ?? '');
    final TextEditingController timeController =
        TextEditingController(text: event?.get('time') ?? '');
    DateTime selectedDate = event != null
        ? (event.get('date') as Timestamp).toDate()
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Event Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Event Description'),
                ),
                TextField(
                  controller: venueController,
                  decoration: InputDecoration(labelText: 'Event Venue'),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'Event Time'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate = picked;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final eventService = EventListWithService(
                  showEventDialog: _showEventDialog,
                );
                if (event == null) {
                  eventService.addEvent(
                      titleController.text,
                      descController.text,
                      selectedDate,
                      venueController.text,
                      timeController.text);
                } else {
                  eventService.editEvent(
                      event.id,
                      titleController.text,
                      descController.text,
                      selectedDate,
                      venueController.text,
                      timeController.text);
                }
                Navigator.pop(context);
              },
              child: Text(event == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mike_test_app/x_tanza/controllers/calendart_data.dart';
// import 'package:mike_test_app/x_tanza/views/widget/appbar_widget.dart';
// import 'package:mike_test_app/x_tanza/views/widget/drawer_widget.dart';
// import 'package:mike_test_app/x_tanza/views/widget/header_main_screen.dart';
// // Import the combined file

// class AdminCalendarPage extends StatelessWidget {
//   AdminCalendarPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Calendar of Activities',
//         onBackPressed: () {
//           Navigator.pop(context); // Navigate back
//         },
//       ),
//       drawer: CustomDrawer(),
//       backgroundColor: const Color.fromARGB(255, 178, 220, 248),
//       body: Column(
//         children: [
//           const MainWidget(),
//           Expanded(
//             child: EventListWithService(
//               showEventDialog: _showEventDialog,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showEventDialog(context, null),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   void _showEventDialog(BuildContext context, DocumentSnapshot? event) {
//     final TextEditingController titleController =
//         TextEditingController(text: event?.get('title') ?? '');
//     final TextEditingController descController =
//         TextEditingController(text: event?.get('description') ?? '');
//     DateTime selectedDate = event != null
//         ? (event.get('date') as Timestamp).toDate()
//         : DateTime.now();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(event == null ? 'Add Event' : 'Edit Event'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Event Title'),
//               ),
//               TextField(
//                 controller: descController,
//                 decoration:
//                     const InputDecoration(labelText: 'Event Description'),
//               ),
//               const SizedBox(height: 10),
//               ListTile(
//                 title: Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null && picked != selectedDate) {
//                     selectedDate = picked;
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final eventService = EventListWithService(
//                   showEventDialog: _showEventDialog,
//                 );
//                 if (event == null) {
//                   eventService.addEvent(
//                       titleController.text, descController.text, selectedDate);
//                 } else {
//                   eventService.editEvent(event.id, titleController.text,
//                       descController.text, selectedDate);
//                 }
//                 Navigator.pop(context);
//               },
//               child: Text(event == null ? 'Add' : 'Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
