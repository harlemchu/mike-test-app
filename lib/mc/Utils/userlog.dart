class UserLog {
  int _myVariable = 0;
  String _uname = '';
  String _email = '';
  String _urole = '';
  final String _defaultUserProfile =
      'https://firebasestorage.googleapis.com/v0/b/mike-test-app-2173f.appspot.com/o/profile.png?alt=media&token=d5f5e259-2737-4535-8ed6-a11d9a597039';

  static final UserLog _instance = UserLog._internal();
  // passes the instantiation to the _instance object
  factory UserLog() => _instance;
  //initialize variables in here
  UserLog._internal() {
    _myVariable = 0;
    _uname = '';
  }

  //short getter for my variable
  int get myVariable => _myVariable;

  //short setter for my variable
  set myVariable(int value) => myVariable = value;

  void incrementMyVariable() => _myVariable++;

  String get getName {
    return _uname;
  }

  String get getUserRole {
    return _urole;
  }

  String get getUserDefaultProfile {
    return _defaultUserProfile;
  }

  String get getEmail {
    return _email;
  }

  // Creating the setter method
  // to set the input in Field/Property
  set setName(String val) {
    _uname = val;
  }

  set setRole(String val) {
    _urole = val;
  }

  bool get isAdmin {
    if (getUserRole == 'admin') {
      return true;
    }
    return false;
  }

  set setEmail(String setEmail) {
    _email = setEmail;
  }
}








 // Does not compile! The constructor being called isn't a const constructor.
// class UserLogInfo {
  
//   final String _uname = 'UserInfo().name';

//   const UserLogInfo._(); // Override default constructor with a private one
//   factory UserLogInfo() => _instance; // Employ factory to redirect creation
//   static const UserLogInfo _instance = UserLogInfo._(); // Create single
//   String get name => _uname; // Define name getter

  
//   set setName(String value) => _uname = value;
// }

// abstract class GlobalVariablesToo {
//   GlobalVariablesToo._(); // Avoid doc generating default constructor
//   static const name = 'My Flutter App'; // Define name constant
// }

// // Works just fine. Very readable. Easy to implement. :)
// const nameToo = GlobalVariablesToo.name;
