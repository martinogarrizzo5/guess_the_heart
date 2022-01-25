import 'package:flutter/material.dart';
import "dart:math";

class GameCard extends StatelessWidget {
  final Function(Key)? onClick;
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
      onTap: () {
        if (onClick != null) onClick!(key!);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          height: min(MediaQuery.of(context).size.width / 3.5 * 1.6, 240 * 1.6),
          width: min(MediaQuery.of(context).size.width / 3.5, 240),
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
