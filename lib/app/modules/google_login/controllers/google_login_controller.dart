import 'dart:io';
import 'package:babysafe/app/apiEndPoint/global_key.dart';
import 'package:babysafe/app/services/SharedPreferenceService/sharePreferenceService.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

      /// 🔹 Check if user already exists locally
      final savedUserId =
      await SharedPreferencesService().getString(KeyConstants.userId);

      /// 🔹 Show different messages
      if (savedUserId == null || savedUserId != user.uid) {
        // New user
        Get.snackbar('success'.tr,
            'account_created'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: NeoSafeColors.success
                .withOpacity(0.1),
            colorText: NeoSafeColors.success,
            borderRadius: 12,
            margin: EdgeInsets.all(
                8.0));
      } else {
        // Returning user
        Get.snackbar('success'.tr,
            "${'welcome_back'.tr}${user.displayName}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: NeoSafeColors.success
                .withOpacity(0.1),
            colorText: NeoSafeColors.success,
            borderRadius: 12,
            margin: EdgeInsets.all(
                8.0));
      }

      /// ✅ SAVE LOCALLY
      await SharedPreferencesService().setString(KeyConstants.userId, user.uid);
      await SharedPreferencesService()
          .setString(KeyConstants.accessToken, googleAuth.idToken ?? '');

      return true;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return false;
    }
  }

}
