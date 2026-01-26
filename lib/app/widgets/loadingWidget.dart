import 'package:babysafe/app/services/InternetService/internetService.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String? msg;
  const LoadingDialog({super.key, this.msg});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff303a47),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      content: Row(
        children: [
          const CircularProgressIndicator(
            backgroundColor: Color(0xff50dcd4),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              msg ?? "Loading",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class LoaderWidget {
  static final LoaderWidget instance = LoaderWidget._internal();

  factory LoaderWidget() {
    return instance;
  }

  LoaderWidget._internal();
  /// Show Loading
  void showLoading({String? message}) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(msg: message),
    );
  }

  /// Hide Loading
  void hideLoading() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }
}

