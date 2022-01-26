import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../components/game_card.dart';
import '../components/status_bar.dart';
import "../components/end_game_dialog.dart";

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationAnimationController;
  late Animation<double> _rotationAnimation;

  final List<GameCard> _cards = [];
  final List<String> _seeds = [];
  final String spadesCard = "assets/picche.jpg";
  final String heartsCard = "assets/cuori.jpg";
  final String backCard = "assets/back.jpg";

  bool isGameOver = false;
  int lives = 0;
  int maxLives = 5;
  int score = 0;
  int maxRegisteredScore = 0;
  bool isUserInteractionEnabled = true;
  final int pointsForRound = 250;

  int lifeLostAlphaValue = 0;

  @override
  void initState() {
    super.initState();
    lives = maxLives;

    // setup base cards and seeds
    for (int i = 0; i < 3; i++) {
      _cards.add(GameCard(backCard, playRound, key: Key("card-$i")));
      _seeds.add(spadesCard);
    }

    // setup animations
    _rotationAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _rotationAnimationController, curve: Curves.linear));
    _rotationAnimation.addListener(
      () => setState(() => setSidesOfCards()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _rotationAnimationController.dispose();
  }

  void setSidesOfCards() {
    if (_rotationAnimation.value < 0.5) {
      setCardsAsCovered();
    } else {
      setCardsAsRevealed(_seeds);
    }
  }

  int selectHeartsCardIndex() {
    int randomIndex = Random().nextInt(3);

    return randomIndex;
  }

  // called when user clicks on a card
  void playRound(Key cardKey) async {
    if (!isUserInteractionEnabled || isGameOver) return;
    isUserInteractionEnabled = false;

    // select hearts card
    int heartsCardIndex = selectHeartsCardIndex();

    // update cards seeds
    setState(() {
      for (int i = 0; i < _cards.length; i++) {
        if (heartsCardIndex == i) {
          _seeds[i] = heartsCard;
        } else {
          _seeds[i] = spadesCard;
        }
      }
    });

    // reveal the cards
    await _rotationAnimationController.forward();

    // handle round won or lost
    handleRoundResult(cardKey, _cards[heartsCardIndex].key!);

    // cover cards after one seconds
    Timer(
      const Duration(seconds: 1),
      () => _rotationAnimationController
          .reverse()
          .whenComplete(() => isUserInteractionEnabled = true),
    );
  }

  void handleRoundResult(Key cardKey, Key heartsCardKey) {
    // if round is won increment the score
    setState(() {
      if (cardKey == heartsCardKey) {
        score += pointsForRound;
      } else {
        lives--;
        playLifeLostAnimation();

        if (lives <= 0) {
          handleGameOver();
        }
      }
    });
  }

  // update cards to their covered position
  void setCardsAsCovered() {
    setState(() {
      for (int i = 0; i < _cards.length; i++) {
        _cards[i] = GameCard(backCard, playRound,
            key: _cards[i].key, isBackShown: true);
      }
    });
  }

  // update cards to their revealed position
  void setCardsAsRevealed(List<String> seeds) {
    setState(() {
      for (int i = 0; i < _cards.length; i++) {
        _cards[i] = GameCard(seeds[i], playRound,
            key: _cards[i].key, isBackShown: false);
      }
    });
  }

  // if game is over show the end game dialog with the score
  void handleGameOver() {
    isGameOver = true;
    bool isNewRecord = score > maxRegisteredScore;
    if (isNewRecord) {
      maxRegisteredScore = score;
    }

    showDialog(
      context: context,
      builder: (ctx) => EndGameDialog(
        score: score,
        maxScore: maxRegisteredScore,
        isNewRecord: isNewRecord,
        onPlayAgain: restartGame,
      ),
      barrierDismissible: false,
    );
  }

  void restartGame() {
    // reset values to initial state
    setState(() {
      score = 0;
      lives = maxLives;
      isGameOver = false;
      isUserInteractionEnabled = true;
    });

    // remove end game dialog
    Navigator.of(context).pop();
  }

  void playLifeLostAnimation() {
    lifeLostAlphaValue = 255;
    Timer(const Duration(milliseconds: 1000), () => {lifeLostAlphaValue = 0});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GameStatusBar(
                  lives: lives,
                  score: score,
                  lifeLostAlphaValue: lifeLostAlphaValue,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _cards
                        .map(
                          (card) => Transform(
                            transform: Matrix4.identity()
                              ..setRotationY(_rotationAnimation.value * pi),
                            alignment: FractionalOffset.center,
                            child: card,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/game-screen-background.jpg"),
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
