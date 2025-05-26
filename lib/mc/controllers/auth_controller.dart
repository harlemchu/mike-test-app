import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerNewUser(
      String email, String name, String password) async {
    String result = 'something went wrong';
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'profileImage': "",
        'email': email,
        'uid': userCredential.user!.uid,
        'role': 'user', // Default role is 'user'
      });

      result = 'success';
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<String> loginUser(String email, String password) async {
    String result = 'something went wrong';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      result = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        result = 'Wrong password provided for that user.';
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  Future<void> createDefaultAdmin() async {
    try {
      // Check if admin already exists
      QuerySnapshot adminQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: 'admin@gmail.com')
          .get();

      if (adminQuery.docs.isEmpty) {
        // Create admin if not exists
        UserCredential adminCredential =
            await _auth.createUserWithEmailAndPassword(
                email: 'admin@gmail.com', password: 'nemsu2k24');

        await _firestore
            .collection('users')
            .doc(adminCredential.user!.uid)
            .set({
          'name': 'Administrator',
          'email': 'admin@gmail.com',
          'uid': adminCredential.user!.uid,
          'role': 'admin',
        });

        print("Default admin account created.");
      } else {
        print("Admin account already exists.");
      }
    } catch (e) {
      print("Error creating admin account: $e");
    }
  }
}
