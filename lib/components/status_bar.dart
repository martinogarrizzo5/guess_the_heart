import "package:flutter/material.dart";

class GameStatusBar extends StatelessWidget {
  final int lives;
  final int score;
  final int lifeLostAlphaValue;

  const GameStatusBar({
    Key? key,
    required this.lives,
    required this.score,
    required this.lifeLostAlphaValue,
  }) : super(key: key);

  final TextStyle gameInfoStyle =
      const TextStyle(color: Colors.white, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              lives.toString(),
              style: gameInfoStyle,
            ),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: Colors.red.withAlpha(lifeLostAlphaValue),
                fontSize: 20,
              ),
              child: const Text(
                "-1",
              ),
            ),
          ],
        ),
        Text("Score: $score", style: gameInfoStyle)
      ],
    );
  }
}
