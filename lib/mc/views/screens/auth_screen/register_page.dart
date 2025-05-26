import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mike_test_app/mc/controllers/auth_controller.dart';
import 'package:mike_test_app/mc/views/screens/auth_screen/login_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  bool _isPasswordVisible = false; // Password visibility flag
  bool isLoading = false; // Loading state flag

  late String email;
  late String name;
  late String password;

  registerUser() async {
    if (_formKey.currentState!.validate()) {
      BuildContext localContext = context;

      setState(() {
        isLoading = true; // Set loading to true
      });

      String res = await _authController.registerNewUser(email, name, password);
      if (res == "success") {
        await _authController.loginUser(email, password); // Auto-login

        Future.delayed(Duration.zero, () {
          Navigator.push(localContext, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
          ScaffoldMessenger.of(localContext).showSnackBar(
            const SnackBar(
                content: Text('Account successfully created and logged in.')),
          );
        });
      } else {
        setState(() {
          isLoading = false; // Set loading to false if registration fails
        });

        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(res)));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (matching the login screen)
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
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80), // Adjust to center the logo

                      // Logo (same as login screen)
                      ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg', // Update with your logo image path
                          width: 150,
                          height: 150,
                          fit:
                              BoxFit.cover, // Ensures it fills the circle shape
                        ),
                      ),
                      const SizedBox(height: 40),

                      Text(
                        "Register Your Account",
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        "Welcome to NemsUnite",
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: const Color.fromARGB(255, 255, 255, 255),
                          letterSpacing: 0.2,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email field
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email',
                          style: GoogleFonts.getFont('Nunito Sans',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 217, 231, 235),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          labelText: 'Enter your email',
                          labelStyle: GoogleFonts.getFont(
                            "Nunito Sans",
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey, // Set icon color to gray
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Name',
                          style: GoogleFonts.getFont('Nunito Sans',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your full name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 217, 231, 235),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          labelText: 'Enter your full name',
                          labelStyle: GoogleFonts.getFont(
                            "Nunito Sans",
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.grey, // Set icon color to gray
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Password',
                          style: GoogleFonts.getFont('Nunito Sans',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                              color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: !_isPasswordVisible, // Password toggle
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter your password';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 217, 231, 235),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          labelText: 'Enter your password',
                          labelStyle: GoogleFonts.getFont(
                            "Nunito Sans",
                            fontSize: 14,
                            letterSpacing: 0.1,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.grey, // Set icon color to gray
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey, // Set icon color to gray
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          errorStyle: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign Up Button with Loading Indicator
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        },
                        child: Container(
                          width: 319,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff102de1),
                                Color(0xcc0d93e6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Sign Up",
                                    style: GoogleFonts.getFont(
                                      'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      letterSpacing: 0.2,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already Have an Account?',
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
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login Now',
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
          ),
        ],
      ),
    );
  }
}
