
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nexus_app/core/utils/logger.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      logger.i("TTS Started");
    });

    _flutterTts.setCompletionHandler(() {
      logger.i("TTS Completed");
    });

    _flutterTts.setErrorHandler((msg) {
      logger.e("TTS Error: $msg");
    });
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
