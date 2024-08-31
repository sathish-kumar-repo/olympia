import 'dart:math';

import 'package:olympia/extension/string_extension.dart';

extension RandomListItemExtension<T> on List<T> {
  T getRandomItem() {
    if (isEmpty) {
      throw ArgumentError("The list is empty");
    }

    Random random = Random();
    int randomIndex = random.nextInt(length);
    return this[randomIndex];
  }
}

extension StringListExtension on List<String> {
  String toCommaSeparatedSentence() {
    if (isEmpty) {
      return '';
    }

    String result = this[0].toCapitalized();

    for (int i = 1; i < length; i++) {
      result += ', ${this[i]}';
    }

    return result;
  }
}
