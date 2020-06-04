import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 10,
            ),
            Text("Welcome to Shopathy")
          ],
        ),
      ),
    );
  }
}
