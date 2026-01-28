import 'dart:io';
import 'package:babysafe/app/apiEndPoint/global_key.dart';
import 'package:babysafe/app/services/SharedPreferenceService/sharePreferenceService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthWithGoogle {
  static Future<bool> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return false;
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return false;

      /// ✅ SAVE LOCALLY
      await SharedPreferencesService().setString(
        KeyConstants.userId,
        user.uid,
      );

      await SharedPreferencesService().setString(
        KeyConstants.accessToken,
        googleAuth.idToken ?? '',
      );

      return true;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }
  static Future<void> googleLogout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    await SharedPreferencesService().clearLocalData();
  }
}
