import 'package:chitchat/helper/helperfunctions.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null ? User(userId: firebaseUser.uid) : null;
  }

  Future signinWithEmailAndPassword(
      final String email, final String password, final String username) async {
    try {
      AuthResult _authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = _authResult.user;
      User signedUser = _userFromFirebaseUser(firebaseUser);
      if (signedUser != null) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(username);
        print('username $username');
        HelperFunctions.saveUserEmailSharedPreference(email);
      }
      return signedUser;
    } catch (e) {
      print('signinWithEmailAndPassword ${e}');
    }
  }

  Future signupWithEmailAndPassword(
      final String email, final String password, final String username) async {
    try {
      AuthResult _authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = _authResult.user;
      User signedupUser = _userFromFirebaseUser(firebaseUser);
      if (signedupUser != null) {
        DatabaseMethods databaseMethods = DatabaseMethods();
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(username);
        HelperFunctions.saveUserEmailSharedPreference(email);
        databaseMethods.uploadUserInfo({'username': username, 'email': email});
      }
      return signedupUser;
    } catch (e) {
      print('singupWithEmailAndPassword ${e}');
    }
  }

  Future resetPassword(final String email) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('resetPassword ${e}');
    }
  }

  Future signout() async {
    try {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      return _firebaseAuth.signOut();
    } catch (e) {
      print('signout: ${e}');
    }
  }
}
