import 'package:flutter/material.dart';

class KirjainNappi extends StatelessWidget {
  const KirjainNappi({
    super.key,
    required this.buttonTitle,
    this.onPress,
  });

  final VoidCallback? onPress;
  final String buttonTitle;
  //kirjannappien ulkonäkö

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        backgroundColor: Colors.lightBlueAccent[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4.0),
      ),
      onPressed: onPress,
      child: Text(
        buttonTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 29,
          color: Colors.grey[850],
        ),
      ),
    );
  }
}
