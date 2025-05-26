import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/views/screens/pages/others/vmission.dart';
import 'package:mike_test_app/mc/views/screens/pages/faculty/faculty_homepage.dart';
import 'package:mike_test_app/mc/views/screens/pages/others/links.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/pages/student/student_officers.dart';
import 'package:mike_test_app/mc/views/screens/pages/Calendar/usercalendar.dart';
import 'package:mike_test_app/mc/views/screens/pages/Calendar/calendar.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late bool isAdminRol = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (UserLog().getUserRole == 'admin') {
      isAdminRol = true;
    } else {
      isAdminRol = false;
    }
    print(UserLog().getUserRole);
  }

  @override
  void dispose() {
    isAdminRol = false;
    // TODO: implement dispose
    super.dispose();
  }

  // Variables to control hover state
  bool _isHoveredCalendar = false;
  bool _isHoveredOfficers = false;
  bool _isHoveredFaculty = false;
  bool _isHoveredMission = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Reusable app bar with logout or back functionality
      appBar: CustomAppBar(
        title: isAdminRol ? ' Admin Homepage' : 'Homepage',
        onBackPressed: () {
          // Handle log-out or back functionality
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Log Out"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Handle log-out logic here
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context)
                        .pushReplacementNamed('/login'); // Navigate to login
                  },
                  child: const Text("Log Out"),
                ),
              ],
            ),
          );
        },
      ),
      // Reusable drawer for navigation
      drawer: CustomDrawer(),

      backgroundColor: const Color.fromARGB(255, 178, 220, 248),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top image section with the MainWidget
          const MainWidget(),
          // GridView section for admin navigation buttons
          Expanded(
            child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: <Widget>[
                  _buildAnimatedButton(
                    'Calendar of Activities',
                    'assets/images/main.png',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isAdminRol
                            ? AdminCalendarPage()
                            : ViewerCalendarPage(),
                      ),
                    ),
                    _isHoveredCalendar,
                    (isHovered) =>
                        setState(() => _isHoveredCalendar = isHovered),
                  ),
                  _buildAnimatedButton(
                    'University Student Leaders',
                    'assets/images/main.png',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NemsuStudentOfficer(),
                      ),
                    ),
                    _isHoveredOfficers,
                    (isHovered) =>
                        setState(() => _isHoveredOfficers = isHovered),
                  ),
                  _buildAnimatedButton(
                    'College Faculty',
                    'assets/images/main.png',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacultyPage(),
                      ),
                    ),
                    _isHoveredFaculty,
                    (isHovered) =>
                        setState(() => _isHoveredFaculty = isHovered),
                  ),
                  _buildAnimatedButton(
                    'Vision Mission',
                    'assets/images/main.png',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VisionMissionHymnWidget(),
                        // builder: (context) => const VissionMission(),
                      ),
                    ),
                    _isHoveredMission,
                    (isHovered) =>
                        setState(() => _isHoveredMission = isHovered),
                  ),
                  _buildAnimatedButton(
                    'University Links',
                    'assets/images/main.png',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UniversityLinks(),
                        // builder: (context) => const VissionMission(),
                      ),
                    ),
                    _isHoveredMission,
                    (isHovered) =>
                        setState(() => _isHoveredMission = isHovered),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to create animated card box with background image and hover effect
  Widget _buildAnimatedButton(String text, String imagePath,
      VoidCallback onPressed, bool isHovered, Function(bool) setHovered) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => setHovered(true),
        onExit: (_) => setHovered(false),
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(isHovered ? 0.3 : 0.5),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  backgroundColor: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
