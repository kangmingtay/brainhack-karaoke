import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AnimatedText extends StatefulWidget {
  @override
  AnimatedTextState createState() => AnimatedTextState();
}

class AnimatedTextState extends State<AnimatedText> with TickerProviderStateMixin {
  AnimationController motionController;
  Animation motionAnimation;
  double size = 150;

  @override
  void initState() {
    super.initState();

    motionController = AnimationController(
       duration: Duration(milliseconds: 800),
       vsync: this,
       lowerBound: 0.8,
     );
 
     motionAnimation = CurvedAnimation(
       parent: motionController,
       curve: Curves.ease,
     );
 
     motionController.forward();
     motionController.addStatusListener((status) {
       setState(() {
         if (status == AnimationStatus.completed) {
           motionController.reverse();
         } else if (status == AnimationStatus.dismissed) {
           motionController.forward();
         }
       });
     });
 
     motionController.addListener(() {
       setState(() {
         size = motionController.value * 50;
       });
     });
   }

  @override
  void dispose() {
    motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Text(
        'WeOKE!',
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = LinearGradient(
              colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))
        ),
      )
    );
  }
}