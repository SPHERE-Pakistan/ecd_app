import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/speech_service.dart';

class SpeechButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final EdgeInsets? padding;

  const SpeechButton({
    Key? key,
    required this.text,
    this.color,
    this.size = 24,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final speechService = Get.find<SpeechService>();

    return Obx(() {
      bool isPlaying = speechService.isCurrentTextPlaying(text);

      return GestureDetector(
        onTap: () => speechService.speak(text),
        child: Container(
          padding: padding ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isPlaying ? Icons.volume_up : Icons.volume_off,
            color: color ?? Colors.blue,
            size: size,
          ),
        ),
      );
    });
  }
}
