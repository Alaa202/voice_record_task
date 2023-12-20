import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';







voiceWidget({src, onPlaying}){

  return VoiceMessageView(
    controller: VoiceController(

      audioSrc: src??
          'https://dl.musichi.ir/1401/06/21/Ghors%202.mp3',
      maxDuration: const Duration(seconds: 120),
      isFile: false,
      onComplete: () {
        print('onComplete');
      },
      onPause: () {
        print('onPause');
      },
      onPlaying: onPlaying,
    ),
    innerPadding: 12,
    cornerRadius: 20,
  );
}





