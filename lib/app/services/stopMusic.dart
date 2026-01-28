import 'package:babysafe/app/apiEndPoint/global_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/speech_service.dart';

mixin StopSpeechOnRouteChange<T extends StatefulWidget> on State<T> implements RouteAware {
  final speechService = Get.find<SpeechService>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Called when this route is no longer visible because another route has been pushed on top
  @override
  void didPushNext() {
    speechService.stop(); // stop TTS when navigating away
  }

  /// Called when a popped route reveals this route
  @override
  void didPopNext() {}

  /// Optional: Called when this route is popped
  @override
  void didPop() {}

  /// Optional: Called when this route is pushed
  @override
  void didPush() {}
}
