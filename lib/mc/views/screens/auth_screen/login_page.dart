// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mike_test_app/x_tanza/Utils/userlog.dart';
// import 'package:mike_test_app/x_tanza/controllers/auth_controller.dart';
// import 'package:mike_test_app/x_tanza/views/main_home_page.dart';
// import 'package:mike_test_app/x_tanza/views/screens/auth_screen/register_page.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final AuthController _authController = AuthController();
//   bool _isPassword = false;
//   bool _autoValidate = false;
//   bool isLoading = false;
//   String email = '';
//   String password = '';
//   // final String email = 'nemsunite@gmail.com';
//   // final String password = 'nemsu2k24';

//   @override
//   void initState() {
//     super.initState();
//     UserLog().setRole = 'user';
//   }

//   // Method to handle user login and navigate to homepage
//   Future<void> loginUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true; // Start loading
//       });

//       String result = await _authController.loginUser(
//           email.isEmpty ? 'nemsunite@gmail.com' : 'edison@gmail.com',
//           email.isEmpty ? 'nemsu2k24' : '123456');

//       if (result == 'success') {
//         User? user = FirebaseAuth.instance.currentUser;
//         if (user != null) {
//           navigateToHomepage(user); // Navigate based on user role
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('You are now logged in')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result)), // Show error message
//         );
//       }

//       setState(() {
//         isLoading = false; // Stop loading after response
//       });
//     } else {
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }

//   // Method to navigate based on user role
//   void navigateToHomepage(User user) async {
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (userDoc.exists) {
//       String role = userDoc['role'];
//       UserLog().setRole = role;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MainHomePage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User role not found')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image with a transparent overlay
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/main.png', // Update with your background image path
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5), // Slightly darker overlay
//             ),
//           ),
//           // Content in the center
//           Center(
//             child: Form(
//               key: _formKey,
//               autovalidateMode: _autoValidate
//                   ? AutovalidateMode.always
//                   : AutovalidateMode.disabled,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Circular Logo at the top
//                     ClipOval(
//                       child: Image.asset(
//                         'assets/images/logo.jpg', // Update with your logo image path
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover, // Ensures it fills the circle shape
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "NEMSUnite",
//                       style: GoogleFonts.getFont(
//                         'Nunito Sans',
//                         color: Colors.white
//                             .withOpacity(0.9), // Brighter white text
//                         fontWeight: FontWeight.bold,
//                         fontSize: 26, // Slightly larger font
//                       ),
//                     ),
//                     Text(
//                       "North Eastern Mindanao State University Unite",
//                       style: GoogleFonts.getFont(
//                         'Nunito Sans',
//                         color: Colors.white
//                             .withOpacity(0.8), // Brighter and more visible
//                         fontSize: 15,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Email',
//                         style: GoogleFonts.getFont(
//                           'Nunito Sans',
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white
//                               .withOpacity(0.9), // Make this text brighter
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       onChanged: (value) {
//                         email = value;
//                       },
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter your Email';
//                         } else {
//                           return null;
//                         }
//                       },
//                       decoration: InputDecoration(
//                         fillColor: Colors.white
//                             .withOpacity(0.9), // Brighter text field
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(9),
//                         ),
//                         labelText: 'Enter your email',
//                         prefixIcon: Icon(Icons.email),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Password',
//                         style: GoogleFonts.getFont(
//                           'Nunito Sans',
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white
//                               .withOpacity(0.9), // Make this text brighter
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       onChanged: (value) {
//                         password = value;
//                       },
//                       obscureText: !_isPassword,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter your password';
//                         } else {
//                           return null;
//                         }
//                       },
//                       decoration: InputDecoration(
//                         fillColor: Colors.white
//                             .withOpacity(0.9), // Brighter text field
//                         filled: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(9),
//                         ),
//                         labelText: 'Enter your password',
//                         prefixIcon: Icon(Icons.lock),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPassword = !_isPassword;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     isLoading
//                         ? CircularProgressIndicator()
//                         : InkWell(
//                             onTap: () {
//                               loginUser();
//                             },
//                             child: Container(
//                               width: 319,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: Color(0xff102de1)),
//                               child: Center(
//                                 child: Text(
//                                   'Sign in',
//                                   style: GoogleFonts.getFont(
//                                     'Nunito Sans',
//                                     fontSize: 17,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Need an account?',
//                           style: GoogleFonts.getFont('Nunito Sans',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                               letterSpacing: 0.2,
//                               color: Colors.white),
//                         ),
//                         const SizedBox(width: 5),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => RegisterScreen()),
//                             );
//                           },
//                           child: Text(
//                             'Register Now',
//                             style: GoogleFonts.getFont(
//                               'Nunito Sans',
//                               fontWeight: FontWeight.w800,
//                               fontSize: 14,
//                               letterSpacing: 0.3,
//                               color: const Color.fromARGB(255, 2, 32, 146),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mike_test_app/mc/controllers/auth_controller.dart';
import 'package:mike_test_app/mc/views/main_home_page.dart';
import 'package:mike_test_app/mc/Utils/userlog.dart';
import 'package:mike_test_app/mc/views/screens/auth_screen/register_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  String _email = 'nemsunite@gmail.com';
  String _pass = 'nemsu2k24';
  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool _isPassword = false;
  bool _autoValidate = false;
  bool isLoading = false;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    UserLog().setRole = 'user';
  }

  // Method to handle user login and navigate to homepage
  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start loading
      });

      String result = await _authController.loginUser(email, password);

      if (result == 'success') {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          navigateToHomepage(user); // Navigate based on user role
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are now logged in')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)), // Show error message
        );
      }

      setState(() {
        isLoading = false; // Stop loading after response
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  // Method to navigate based on user role
  void navigateToHomepage(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      String role = userDoc['role'];
      UserLog().setRole = role;
      UserLog().setEmail = role;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHomePage()),
      );
      // if (role == 'admin') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => AdminHomePage()),
      //   );
      // } else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => UserHomePage()),
      //   );
      // }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User role not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with a transparent overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/main.png', // Update with your background image path
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // Slightly darker overlay
            ),
          ),
          // Content in the center
          Center(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular Logo at the top
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpg', // Update with your logo image path
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover, // Ensures it fills the circle shape
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "NEMSUnite",
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        color: Colors.white
                            .withOpacity(0.9), // Brighter white text
                        fontWeight: FontWeight.bold,
                        fontSize: 26, // Slightly larger font
                      ),
                    ),
                    Text(
                      "North Eastern Mindanao State University Unite",
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        color: Colors.white
                            .withOpacity(0.8), // Brighter and more visible
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                              .withOpacity(0.9), // Make this text brighter
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                        _email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Email';
                        } else {
                          return null;
                        }
                      },
                      controller: _emailController..text = _email,
                      decoration: InputDecoration(
                        fillColor: Colors.white
                            .withOpacity(0.9), // Brighter text field
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        labelText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Password',
                        style: GoogleFonts.getFont(
                          'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                              .withOpacity(0.9), // Make this text brighter
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        password = value;
                        _pass = value;
                      },
                      obscureText: !_isPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        } else {
                          return null;
                        }
                      },
                      controller: _passController..text = _pass,
                      decoration: InputDecoration(
                        fillColor: Colors.white
                            .withOpacity(0.9), // Brighter text field
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        labelText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPassword = !_isPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : InkWell(
                            onTap: () {
                              email = _email;
                              password = _pass;
                              loginUser();
                            },
                            child: Container(
                              width: 319,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xff102de1)),
                              child: Center(
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.getFont(
                                    'Nunito Sans',
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Need an account?',
                          style: GoogleFonts.getFont('Nunito Sans',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.2,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Register Now',
                            style: GoogleFonts.getFont(
                              'Nunito Sans',
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: 0.3,
                              color: const Color.fromARGB(255, 2, 32, 146),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
