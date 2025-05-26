import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/views/main_home_page.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/faculty_homepage.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/pages/others/links.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/student_officers.dart';
import 'package:mike_test_app/mc/views/screens/pages/Calendar/usercalendar.dart';
import 'package:mike_test_app/mc/views/screens/pages/Calendar/calendar.dart';
import 'package:mike_test_app/mc/views/screens/pages/others/vmission.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom header without white space
          Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background image with transparency
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/main.png'), // Image path
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), // Transparency
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  height: 200,
                  width: double.infinity,
                ),
                // Content inside the Stack
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/logo.png', // Logo path
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'NEMSUnite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // List of items with the same background color
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cetbg.jpg'), // Image path
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(128, 0, 0, 0),
                    // Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: ListView(
                children: [
                  Container(
                    color: Color.fromARGB(99, 9, 9, 230),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white, child: Icon(Icons.home)),
                      title: Text('HOME',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainHomePage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    color: Color.fromARGB(96, 74, 74, 135),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white,
                          child: Icon(Icons.calendar_month_outlined)),
                      title: Text('Calendar of Activities',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserLog().getUserRole == 'admin'
                                    ? AdminCalendarPage()
                                    : ViewerCalendarPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    color: Color.fromARGB(96, 74, 74, 135),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white, child: Icon(Icons.people)),
                      title: Text('Student Department Officers',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NemsuStudentOfficer()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    color: Color.fromARGB(96, 74, 74, 135),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white, child: Icon(Icons.school)),
                      title: Text('College Faculty',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FacultyPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    color: Color.fromARGB(96, 74, 74, 135),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white, child: Icon(Icons.visibility)),
                      title: Text('Vision Mission',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisionMissionHymnWidget()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    color: Color.fromARGB(96, 74, 74, 135),
                    child: ListTile(
                      leading: Container(
                          color: Colors.white, child: Icon(Icons.link)),
                      title: Text('Nemsu Links',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UniversityLinks()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
