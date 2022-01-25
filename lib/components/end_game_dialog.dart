import "package:flutter/material.dart";
import 'package:guess_the_heart/components/main_button.dart';

class EndGameDialog extends StatelessWidget {
  final int maxScore;
  final int score;
  final Function onPlayAgain;
  final bool isNewRecord;

  const EndGameDialog({
    Key? key,
    required this.score,
    required this.maxScore,
    required this.onPlayAgain,
    this.isNewRecord = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Game Over!",
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Ultra", fontSize: 28),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Score: $score",
          ),
          Text(
            isNewRecord ? "New Record!" : "Max Score: $maxScore",
          ),
          const SizedBox(height: 8),
          MainButton(
              text: "Play Again",
              fontSize: 24,
              onClick: onPlayAgain,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ))
        ],
      ),
    );
  }
}
