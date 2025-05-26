import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/controllers/calendart_data.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';

class ViewerCalendarPage extends StatelessWidget {
  const ViewerCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendar of Activities',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          // Background color or gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.shade100,
                  Colors.lightBlue.shade300,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Content on top of the background
          Column(
            children: [
              MainWidget(),
              Expanded(
                child: EventListWithService(
                  showEventDialog: _showEventDialog,
                  isViewer: true, // Viewer mode
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // View-only event dialog for viewers
  void _showEventDialog(BuildContext context, DocumentSnapshot? event) {
    if (event == null) return;

    final eventDate = (event.get('date') as Timestamp).toDate();
    final eventTime = event.get('time');
    final eventVenue = event.get('venue');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${event.get('title')}'),
                SizedBox(height: 10),
                Text('Description: ${event.get('description')}'),
                SizedBox(height: 10),
                Text('Venue: $eventVenue'),
                SizedBox(height: 10),
                Text('Date: ${eventDate.toLocal().toString().split(' ')[0]}'),
                SizedBox(height: 10),
                Text('Time: $eventTime'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
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
// import 'package:mike_test_app/x_tanza/views/widget/header_main_screen.dart';
// import 'package:mike_test_app/x_tanza/views/widget/user_drawer.dart'; // Import the event list widget

// class ViewerCalendarPage extends StatelessWidget {
//   const ViewerCalendarPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Calendar of Activities',
//         onBackPressed: () {
//           Navigator.pop(context); // Navigate back
//         },
//       ),
//       drawer: UserCustomDrawer(),
//       backgroundColor: const Color.fromARGB(255, 178, 220, 248),
//       body: Stack(
//         children: [
//           // Background color or gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.lightBlue.shade100,
//                   Colors.lightBlue.shade300,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           // Content on top of the background
//           Column(
//             children: [
//               MainWidget(),
//               Expanded(
//                 child: EventListWithService(
//                   showEventDialog: _showEventDialog,
//                   isViewer: true, // Set to viewer mode
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Modify showEventDialog for viewer mode (no edit functionality)
//   void _showEventDialog(BuildContext context, DocumentSnapshot? event) {
//     // Show event details in a dialog (view-only mode)
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Event Details'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Title: ${event?.get('title')}'),
//               Text('Description: ${event?.get('description')}'),
//               Text('Date: ${event?.get('date').toDate()}'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
