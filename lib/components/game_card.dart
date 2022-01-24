import 'package:flutter/material.dart';
import "dart:math";

class GameCard extends StatelessWidget {
  final Function(Key) onClick;
  final String image;
  final bool isBackShown;

  const GameCard(
    this.image,
    this.onClick, {
    this.isBackShown = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(key!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.width / 3.5 * 1.6,
          width: MediaQuery.of(context).size.width / 3.5,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
