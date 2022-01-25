import "package:flutter/material.dart";
import 'package:guess_the_heart/components/game_card.dart';
import 'package:guess_the_heart/components/main_button.dart';

class GameMenu extends StatelessWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/game-menu-background.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 150,
              left: 50,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(320 / 360),
                child: GameCard("assets/picche.jpg", null),
              ),
            ),
            const Positioned(
              bottom: 150,
              left: 50,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(135 / 360),
                child: GameCard("assets/picche.jpg", null),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 100,
              right: 50,
              child: const RotationTransition(
                child: GameCard("assets/cuori.jpg", null),
                turns: AlwaysStoppedAnimation(40 / 360),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Text(
                        "Guess\nThe\nHeart",
                        style: TextStyle(
                          fontSize: 62,
                          fontFamily: "Ultra",
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Guess\nThe\nHeart",
                        style: TextStyle(
                          fontSize: 62,
                          fontFamily: "Ultra",
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MainButton(
                    text: "Play Now",
                    fontSize: 32,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 36,
                    ),
                    onClick: () => Navigator.of(context).pushNamed("/game"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
