import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';

import 'decorator/decorator.dart';

/// Check if the text has hashTags
bool hasHashTags(String value) {
  final decoratedTextColor = Colors.blue;
  final decorator = Decorator(
      textStyle: TextStyle(),
      decoratedStyle: TextStyle(color: decoratedTextColor));
  final result = decorator.getDecorations(value);
  final taggedDecorations = result
      .where((decoration) => decoration.style.color == decoratedTextColor)
      .toList();
  return taggedDecorations.isNotEmpty;
}

/// Extract hashTags from the text
List<String> extractHashTags(String value) {
  final decoratedTextColor = Colors.blue;
  final decorator = Decorator(
      textStyle: TextStyle(),
      decoratedStyle: TextStyle(color: decoratedTextColor));
  final decorations = decorator.getDecorations(value);
  final taggedDecorations = decorations
      .where((decoration) => decoration.style.color == decoratedTextColor)
      .toList();
  final result = taggedDecorations.map((decoration) {
    final text = decoration.range.textInside(value);
    return text.trim();
  }).toList();
  return result;
}

/// Returns textSpan with decorated tagged text
///
/// Used in [HashTagText]
TextSpan getHashTagTextSpan(
    {@required TextStyle decoratedStyle,
    @required TextStyle basicStyle,
    @required String source,
    @required Function(String) onTap}) {
  final decorations =
      Decorator(decoratedStyle: decoratedStyle, textStyle: basicStyle)
          .getDecorations(source);
  if (decorations.isEmpty) {
    return TextSpan(text: source, style: basicStyle);
  } else {
    decorations.sort();
    final span = decorations
        .asMap()
        .map(
          (index, item) {
            return MapEntry(
              index,
              TextSpan(
                style: item.style,
                text: item.range.textInside(source),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final decoration = decorations[index];
                    if (decoration.style == decoratedStyle) {
                      onTap(decoration.range.textInside(source));
                    }
                  },
              ),
            );
          },
        )
        .values
        .toList();

    return TextSpan(children: span);
  }
}