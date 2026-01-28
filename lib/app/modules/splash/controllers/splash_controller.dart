import 'dart:async';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplash();
  }

  void _startSplash() {
    Timer(const Duration(seconds: 2), () async {
      await AuthService.to.navigateAfterLogin();
    });
  }
}
