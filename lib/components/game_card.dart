import 'package:flutter/material.dart';
import "dart:math";

class GameCard extends StatefulWidget {
  final bool isClickable;
  final String image;
  final AnimationController animationController;
  final Function(GameCard) onClick;

  void discoverCard() {
    animationController.forward();
  }

  void coverCard() {
    animationController.reverse();
  }

  void handleCardClick() {
    onClick(this);
  }

  const GameCard(
    this.image, {
    Key? key,
    required this.animationController,
    required this.onClick,
    this.isClickable = true,
  }) : super(key: key);

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late String _frontImage;
  final String _backImage = "assets/back.jpg";
  late String _shownImage;

  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _frontImage = widget.image;
    _shownImage = _backImage;

    _rotationAnimation =
        Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    ));
    _rotationAnimation.addListener(_handleAnimationValueChange);
  }

  @override
  void dispose() {
    super.dispose();
    _rotationAnimation.removeListener(() {});
  }

  void _handleAnimationValueChange() {
    setState(() {
      if (_rotationAnimation.value > 90 / 180 * pi) {
        _shownImage = _frontImage;
      } else {
        _shownImage = _backImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_rotationAnimation.value),
      alignment: FractionalOffset.center,
      child: InkWell(
        onTap: widget.handleCardClick,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.width / 3.5 * 1.6,
            width: MediaQuery.of(context).size.width / 3.5,
            child: Image.asset(
              _shownImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
