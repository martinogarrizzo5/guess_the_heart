import "package:flutter/material.dart";

class MainButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const MainButton({
    Key? key,
    required this.text,
    required this.onClick,
    required this.fontSize,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onClick(),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: "TitanOne",
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange[700],
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
