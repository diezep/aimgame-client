import 'package:aimgame/src/pages/game_page.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key key}) : super(key: key);
  static final routeName = '/';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Aim-game'),
          RaisedButton(
              child: Text('Play'),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(GamePage.routeName))
        ],
      )),
    );
  }
}
