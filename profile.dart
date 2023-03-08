import 'package:flutter/material.dart';


class profileScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'MG Health',

                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,

                        ),

                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )

    );
  }
}

