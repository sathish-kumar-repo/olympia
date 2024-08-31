import 'package:flutter/material.dart';

class PlaceHolder extends StatelessWidget {
  const PlaceHolder(
    this.txt, {
    super.key,
  });
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        txt,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
      ),
    );
  }
}
