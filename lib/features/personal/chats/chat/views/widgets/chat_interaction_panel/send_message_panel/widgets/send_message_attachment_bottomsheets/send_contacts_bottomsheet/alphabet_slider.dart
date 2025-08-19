import 'package:flutter/material.dart';

class AlphabetSlider extends StatelessWidget {
  const AlphabetSlider({
    required this.onLetterTap,
    required this.availableLetters,
    required this.activeLetter,
    super.key,
  });

  final void Function(String letter) onLetterTap;
  final Set<String> availableLetters;
  final String activeLetter; // currently active/tapped letter

  final List<String> _alphabet = const <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _alphabet.map((String letter) {
          final bool enabled = availableLetters.contains(letter);
          final bool isActive = letter == activeLetter;

          return GestureDetector(
            onTap: enabled ? () => onLetterTap(letter) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: isActive ? 18 : 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.bold,
                  color: enabled
                      ? (isActive
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.outline)
                      : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
