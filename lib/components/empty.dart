import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String tips;

  Empty(this.tips);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/empty.png',
            width: 60,
            height: 60,
          ),
          Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                tips,
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ))
        ],
      ),
    );
  }
}
