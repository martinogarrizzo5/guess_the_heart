import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guess_the_heart/components/game_card.dart';
import '../components/status_bar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  final List<GameCard> _cards = [];
  final List<String> _seeds = [];
  final String spadesCard = "assets/picche.jpg";
  final String heartsCard = "assets/cuori.jpg";
  final String backCard = "assets/back.jpg";

  int lives = 0;
  int maxLives = 10;
  int score = 0;
  int maxRegisteredScore = 0;
  bool isUserInteractionEnabled = true;

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
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _rotationAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _rotationAnimation.addListener(
      () => setState(() => setSidesOfCards()),
    );
  }

  void setSidesOfCards() {
    if (_rotationAnimation.value < 0.5) {
      setCardsAsCovered();
    } else {
      setCardsAsRevealed(_seeds);
    }
  }

  // called when user clicks on a card
  void playRound(Key cardKey) async {
    if (!isUserInteractionEnabled) return;
    isUserInteractionEnabled = false;

    // select hearts card
    int heartsCardIndex = Random().nextInt(3);

    // update seeds
    setState(() {
      for (int i = 0; i < _cards.length; i++) {
        if (heartsCardIndex == i) {
          _seeds[i] = heartsCard;
        } else {
          _seeds[i] = spadesCard;
        }
      }
    });

    await _controller.forward();
    handleRoundResult(cardKey, _cards[heartsCardIndex].key!);

    Timer(
      const Duration(seconds: 1),
      () => _controller
          .reverse()
          .whenComplete(() => isUserInteractionEnabled = true),
    );
  }

  void handleRoundResult(Key cardKey, Key heartsCardKey) {
    // if round is won increment the score
    setState(() {
      if (cardKey == heartsCardKey) {
        score += 250;
      } else {
        lives--;
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
