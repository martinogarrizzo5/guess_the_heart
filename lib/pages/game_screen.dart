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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;

  List<GameCard> _cards = [];
  final String spadesCard = "assets/picche.jpg";
  final String heartsCard = "assets/cuori.jpg";

  int lives = 0;
  int maxLives = 10;
  int score = 0;
  int maxRegisteredScore = 0;

  @override
  void initState() {
    super.initState();
    lives = maxLives;

    // setup animation
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _cards = [
      GameCard(spadesCard,
          animationController: _animationController1,
          onClick: playRound,
          key: Key("card1")),
      GameCard(heartsCard,
          animationController: _animationController1,
          onClick: playRound,
          key: Key("card2")),
      GameCard(spadesCard,
          animationController: _animationController1,
          onClick: playRound,
          key: Key("card3"))
    ];
  }

  // called when user clicks on a card
  void playRound(GameCard selectedCard) {
    // TODO: don't allow user to click cards during the round
    print(selectedCard.image);

    // discover the cards
    for (var card in _cards) {
      card.discoverCard();
    }

    // handle round won or lost
    endRound();
  }

  void endRound() {
    // cover the cards after the user had the time to see the clicked card
    Timer(const Duration(seconds: 2), () {
      // play cover card animation
      for (var card in _cards) {
        card.coverCard();
      }

      // shuffle cards only at end of covering animation
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          _cards.shuffle();
        });
      });
    });
    // Timer(const Duration(milliseconds: 2), () {

    // });
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
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _cards,
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
