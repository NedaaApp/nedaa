import 'package:flutter/material.dart';

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: child,
          ),
        ]),
      ),
    );
  }
}
