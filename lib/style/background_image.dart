import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background04.jpg"),
          colorFilter: ColorFilter.matrix([
            0.5, 0, 0, 0, 0,
            0, 0.5, 0, 0, 0,
            0, 0, 0.5, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}