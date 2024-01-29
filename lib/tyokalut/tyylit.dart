import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var alertNapinTyyliVoitto = AlertStyle(
  descStyle: const TextStyle(fontSize: 55, color: Colors.lightBlue,),
  alertPadding: const EdgeInsets.only(top: 10),
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 500),
  backgroundColor: const Color(0xFF2C1E68),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  titleStyle: const TextStyle(
    color: Color(0xFF00e676),
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: 1.5,
  ),
);


var alertNapinTyyliHavio = AlertStyle(
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 450),
  backgroundColor: const Color(0xFF2C1E68),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  titleStyle: const TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: 1.5,
  ),
  descStyle: const TextStyle(
    color: Colors.lightBlue,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
    letterSpacing: 1.5,
  ),
);

var vaaraSanaAlertTyyli = AlertStyle(
  descStyle: const TextStyle(letterSpacing: 1.5, fontSize: 30,color: Colors.lightBlue,),
  animationType: AnimationType.grow,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  animationDuration: const Duration(milliseconds: 450),
  backgroundColor: const Color(0xFF2C1E68),
  alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
  titleStyle: const TextStyle(
    color: Color(0xFFFF2121),
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    letterSpacing: 1.5,
  ),
);


class TekstiAnimaatioInOut extends StatefulWidget {
  final String text;

  const TekstiAnimaatioInOut({super.key, required this.text});

  @override
  _TekstiAnimaatioInOutState createState() => _TekstiAnimaatioInOutState();
}

class _TekstiAnimaatioInOutState extends State<TekstiAnimaatioInOut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Total duration for two cycles
    );

    // Set up the scale animation with a curved interval for smooth scaling
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 1),
      ]).animate(_controller);

    // Start the animation
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Text(
              widget.text,
              style: const TextStyle(fontSize: 57),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}