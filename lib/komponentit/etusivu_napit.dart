import 'package:flutter/material.dart';

class ToimenpideNappi extends StatelessWidget {
  const ToimenpideNappi({super.key, required this.napinTeksti, this.onPress});

  final VoidCallback? onPress;
  final String napinTeksti;
  //ulkonäkö etusivun napeille
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        backgroundColor: Colors.green[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPress,
      child: Text(
        napinTeksti,
        style: const TextStyle(
          fontSize: 45,
          color: Colors.white,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
