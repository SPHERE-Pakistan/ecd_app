import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../services/auth_service.dart';
import '../../../services/article_service.dart';
import '../../../data/providers/api_client.dart';
import '../../../data/models/user_model.dart';

class GoogleLoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final ApiClient _apiClient = ApiClient.to;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // 👉👉 Guest Account Check – CUSTOM API VERSION
      final response = await _apiClient.get('/api/guest-account/check');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['guest_access_enabled'] == true) {
          // Create a guest user model
          final guestUser = UserModel(
            id: "guest_user",
            fullName: "Guest User",
            email: "guest@example.com",
            createdAt: DateTime.now(),
            isLoggedIn: true,
          );

          final authService = Get.find<AuthService>();
          await authService.saveCurrentUser(guestUser);

          // Navigate directly to next page
          await authService.navigateAfterLogin();

          isLoading.value = false;
          return; // 🚀 Google login SKIP here
        }
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // NOTE: Standard backend would have an endpoint for this.
      // For now, mirroring existing behavior with custom API.
      final authService = Get.find<AuthService>();
      final isSameAccount = await authService.isSameUser(googleUser.id);

      final userModel = UserModel(
        id: googleUser.id,
        fullName: googleUser.displayName ?? '',
        email: googleUser.email,
        createdAt: DateTime.now(),
        isLoggedIn: true,
      );

      await authService.saveCurrentUser(userModel);

      if (!isSameAccount) {
        try {
          final articleService = Get.find<ArticleService>();
          await articleService.downloadArticlesOnFirstLogin();
        } catch (e) {
          print('Error downloading articles: $e');
        }
      }

      Get.snackbar(
        'welcome'.tr,
        'welcome_back_user'
            .tr
            .replaceAll('{name}', googleUser.displayName ?? 'User'),
        snackPosition: SnackPosition.BOTTOM,
      );

      await Future.delayed(const Duration(milliseconds: 400));
      await authService.navigateAfterLogin();

    } catch (e) {
      print('Google Sign-In error: $e');
      Get.snackbar(
        'error'.tr,
        'google_signin_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _googleSignIn.disconnect();
    super.onClose();
  }
}
