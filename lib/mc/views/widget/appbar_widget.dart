import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/views/screens/auth_screen/login_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onMenuPressed;

  CustomAppBar(
      {required this.title,
      this.onMenuPressed,
      required Null Function() onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: onMenuPressed ??
                () {
                  Scaffold.of(context).openDrawer();
                },
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.exit_to_app), // Changed icon to exit/log out
          onPressed: () => _showLogoutConfirmationDialog(context),
        ),
      ],
    );
  }

  // Function to show the confirmation dialog for logging out
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Navigate to LoginPage
                );
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
