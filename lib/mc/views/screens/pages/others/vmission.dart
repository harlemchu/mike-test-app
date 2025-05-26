import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mike_test_app/mc/views/widget/appbar_widget.dart';
import 'package:mike_test_app/mc/views/widget/drawer_widget.dart';
import 'package:mike_test_app/mc/views/widget/header_main_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:google_fonts/google_fonts.dart';

class VisionMissionHymnWidget extends StatefulWidget {
  const VisionMissionHymnWidget({super.key});

  @override
  State<VisionMissionHymnWidget> createState() =>
      _VisionMissionHymnWidgetState();
}

class _VisionMissionHymnWidgetState extends State<VisionMissionHymnWidget>
    with TickerProviderStateMixin {
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: 'Vision, Mission, and Hymn',
          onBackPressed: () {
            Navigator.pop(context);
          }),
      // appBar: AppBar(
      //   backgroundColor: Colors.blue.shade700,
      //   title: Text(
      //     'Vision, Mission, and Hymn',
      //     style: GoogleFonts.inter(
      //       fontWeight: FontWeight.w600,
      //       fontSize: 20,
      //     ),
      //   ),
      //   elevation: 0,
      // ),
      drawer: CustomDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // NEMSU Logo and Image Section
            const Expanded(
              flex: 2,
              child: MainWidget(),
            ),
            // PageView Section
            Expanded(
              flex: 5,
              child: PageView(
                controller: _pageViewController,
                scrollDirection: Axis.horizontal,
                children: [
                  _buildVisionSection(),
                  _buildMissionSection(),
                  _buildHymnSection(),
                ],
              ),
            ),
            // Page Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: smooth_page_indicator.SmoothPageIndicator(
                controller: _pageViewController,
                count: 3,
                effect: smooth_page_indicator.ExpandingDotsEffect(
                  dotColor: Colors.grey.shade400,
                  activeDotColor: Colors.blue,
                  dotHeight: 10,
                  dotWidth: 10,
                  expansionFactor: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionSection() {
    return _buildContent(
      image: 'assets/images/vission.png',
      title: 'VISION',
      description:
          'A Research University advancing technology and innovation for sustainable development.',
    );
  }

  Widget _buildMissionSection() {
    return _buildContent(
      image: 'assets/images/mission.jpg',
      title: 'MISSION',
      description:
          'We drive sustainable development through quality instruction, innovative research, community collaboration, and technological advancement.',
    );
  }

  Widget _buildHymnSection() {
    return _buildContent(
      image: 'assets/images/hym.jpg',
      title: 'NEMSU HYMN',
      description: '''
Onward with a noble mission
Unifying with a vision;
Glorious footprints of knowledge won
Breeding grounds of Glocal Champions

Emblem of Mindanaoan nobility
Radiates the name of a growing NEMSU;
North Eastern Mindanao State University
Flying flag above the pacific blue.

Refrain:
Live! Rise! Soar and Excel!
In the NEMSU education
Leading to a better world
By sculpting better lives,
The NEMSU vision, NEMSU touch

N.E.M.S.U
The laying portals of brilliant hatch
(Repeat Refrain)

Coda:
The NEMSU vision
NEMSU touch
NEMSU!
''',
    );
  }

  Widget _buildContent(
      {required String image,
      required String title,
      required String description}) {
    return SingleChildScrollView(
      child: Container(
        //height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                image,
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MainWidget extends StatelessWidget {
//   const MainWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Top section with logo and background image
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: const AssetImage('assets/images/main.png'),
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.5),
//                       BlendMode.darken,
//                     ),
//                   ),
//                 ),
//                 height: 200,
//                 width: double.infinity,
//               ),
//               Column(
//                 children: [
//                   ClipOval(
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       height: 80,
//                       width: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'NemsUnite',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     'North Eastern Mindanao State University Unite',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
