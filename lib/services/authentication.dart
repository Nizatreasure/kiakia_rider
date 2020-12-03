import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:kiakia_rider/login_signup/enter_otp.dart';
import 'package:kiakia_rider/profile/bank_details.dart';
import 'package:kiakia_rider/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final secureStorage = new FlutterSecureStorage();
  String error = '';

  //signs in a user with email and password
  Future signInWIthEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await secureStorage.write(key: 'password', value: password);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password')
        error = 'Password is incorrect';
      else if (e.code == 'user-not-found')
        error = 'User does not exist';
      else if (e.code == 'network-request-failed')
        error = 'Network request failed';
      else if (e.code == 'user-disabled')
        error = 'User has been disabled';
      else if (e.code == 'too-many-requests')
        error = 'Too many attempts';
      else
        error = 'Unknown error';
      print(e.code);
      return null;
    }
  }

  Future createAccount(
      {@required String name,
      @required String email,
      @required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(user.uid).createUser(
          name: name, email: email, isNumberVerified: false, provider: 'email');
      await secureStorage.write(key: 'password', value: password);
      await _auth.currentUser.updateProfile(displayName: name);
      return user.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use')
        error = 'Email already in use';
      else if (e.code == 'invalid-email')
        error = 'Email is not valid';
      else if (e.code == 'network-request-failed')
        error = 'Network request failed';
      else if (e.code == 'weak-password')
        error = 'Password is too weak';
      else
        error = 'Unknown Error';

      return null;
    }
  }

  //the function responsible for initiating the process of  number verification
  // when the user clicks on the 'verify now' button on the pop up
  Future verifyNumber({number, BuildContext context, bool reload}) async {
    int _resendToken;
    try {
      Response response = await get('https://www.google.com');
      if (response.statusCode == 200) {
        try {
          await _auth.verifyPhoneNumber(
              phoneNumber: number,
              forceResendingToken: _resendToken,
              verificationCompleted: (phoneAuthCredentials) async {
                await _auth.currentUser
                    .linkWithCredential(phoneAuthCredentials);
                await FirebaseDatabase.instance
                    .reference()
                    .child('riders')
                    .child(_auth.currentUser.uid)
                    .update({'isNumberVerified': true});
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BankDetails()));
              },
              verificationFailed: (FirebaseAuthException e) {
                if (e.code == 'too-many-requests') {
                  error = 'Too many attempts, try again later';
                } else if (e.code == 'network-request-failed') {
                  error = 'Network request failed, try again later';
                } else {
                  error = 'Request failed, try again later';
                }
                return null;
              },
              codeSent: (verId, int resendToken) async {
                error = '';
                _resendToken = resendToken;
                if (reload)
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterOTP(number: number, verId: verId)));
              },
              timeout: Duration(seconds: 60),
              codeAutoRetrievalTimeout: (verificationID) {});
        } on FirebaseAuthException catch (e) {
          if (e.code == 'network-request-failed')
            error = 'Network request failed';
          else
            error = 'Unknown Error';

          return null;
        }
      }
      return true;
    } catch (e) {
      print(e);
      error = 'Network error';
      return null;
    }
  }

  //signs the user out of the application
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  //sends a password reset mail to registered users who have forgotten their password
  Future resetUserPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found')
        error = 'User does not exist';
      else if (e.code == 'invalid-email')
        error = 'Email is not valid';
      else
        error = 'An error occurred. Try again later';
      return null;
    }
  }
}
