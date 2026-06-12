
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:nexus_app/core/utils/logger.dart';
import 'package:nexus_app/core/constants/app_strings.dart';

final sttServiceProvider = Provider<SttService>((ref) => SttService());

class SttService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize(onStatus: (status) {
      logger.i('Speech recognition status: $status');
    }, onError: (errorNotification) {
      logger.e('Speech recognition error: ${errorNotification.errorMsg}');
    });
    if (_speechEnabled) {
      logger.i('Speech recognition initialized successfully.');
    } else {
      logger.e('Speech recognition initialization failed.');
    }
  }

  Future<String?> startListening() async {
    if (!_speechEnabled) {
      logger.w(AppStrings.speechNotAvailable);
      return null;
    }
    if (_speechToText.isListening) {
      logger.w('Already listening.');
      return null;
    }

    final completer = Completer<String?>();

    _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
          logger.i('Speech recognized: ${result.recognizedWords}');
        }
      },
      listenFor: const Duration(seconds: 5), // Listen for 5 seconds
      pauseFor: const Duration(seconds: 3), // Pause for 3 seconds of silence
      localeId: 'en_US', // Specify locale if needed
      onSoundLevelChange: (level) => logger.d('Sound level: $level'),
    );
    logger.i(AppStrings.listening);
    return completer.future;
  }

  void stopListening() {
    _speechToText.stop();
    logger.i('Stopped listening.');
  }

  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _speechToText.isAvailable;
}
