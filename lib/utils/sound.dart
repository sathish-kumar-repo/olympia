import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:olympia/extension/list_extension.dart';

import '../data/success_sound_lst.dart';

enum AudioExperienceType {
  error,
  finish,
}

Future<void> audioExperience({
  required AudioExperienceType audioExperienceType,
}) async {
  try {
    final player = AudioPlayer();
    if (audioExperienceType == AudioExperienceType.finish) {
 
      await player.play(
        AssetSource('sound/${success.getRandomItem()}.mp3'),
      );
    } else if (audioExperienceType == AudioExperienceType.error) {
      await player.play(
        AssetSource('sound/error.wav'),
      );
    }
  } on Exception {
    debugPrint('Error occured in sound');
  }
}
