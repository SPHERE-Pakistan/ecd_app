import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class SpeechService extends GetxController {
  static SpeechService get instance => Get.find();

  late FlutterTts flutterTts;

  final RxBool _isPlaying = false.obs;
  final RxString _currentText = ''.obs;

  bool get isPlaying => _isPlaying.value;
  String get currentText => _currentText.value;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);

    // Handlers
    flutterTts.setStartHandler(() {
      _isPlaying.value = true;
    });

    flutterTts.setCompletionHandler(() {
      _reset();
    });

    flutterTts.setCancelHandler(() {
      _reset();
    });

    flutterTts.setErrorHandler((msg) {
      _reset();
    });
  }

  Future<void> speak(String text) async {
    // Stop if same text is already playing
    if (_isPlaying.value && _currentText.value == text) {
      await stop();
      return;
    }

    // Stop current speech if different text
    if (_isPlaying.value && _currentText.value != text) {
      await stop();
    }

    _currentText.value = text;
    await flutterTts.speak(text);
    _isPlaying.value = true;
  }

  Future<void> stop() async {
    await flutterTts.stop();
    _reset();
  }

  void _reset() {
    _isPlaying.value = false;
    _currentText.value = '';
  }

  bool isCurrentTextPlaying(String text) =>
      _isPlaying.value && _currentText.value == text;
}
