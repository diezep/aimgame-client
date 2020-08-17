import 'dart:math';

import 'package:aimgame/src/providers/room_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettings extends StatefulWidget {
  GameSettings({Key key}) : super(key: key);

  @override
  _GameSettingsState createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  ThemeData theme;
  TextEditingController textController = TextEditingController();
  bool inGame;

  @override
  void initState() {
    
    textController.selection = TextSelection(
    baseOffset: 0,
    extentOffset: textController.text.length,
);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    inGame = context.watch<RoomProvider>().inGame;

    return Container(
      // width: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            'Party code',
            style: theme.textTheme.headline2,
          )),
          Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              width: 150,
              height: 50,
              child: Consumer<RoomProvider>(builder: (context, room, child) {
                textController.text = room.code ?? '';

                return TextField(
                  autofocus: true,
                  readOnly: inGame,
                  controller: textController,
                  enableInteractiveSelection: true,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      enabled: !inGame,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Code room',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white.withOpacity(.17)),
                );
              })),
          RaisedButton(
              color: theme.buttonColor,
              child: Text(inGame ? 'Leave from party' : "Let's play"),
              onPressed: (inGame)
                  ? () => context.read<RoomProvider>().leave()
                  : () => context.read<RoomProvider>().join(textController.text)),
          RaisedButton(
              color: Colors.cyan,
              child: Text("Create party"),
              onPressed: inGame
                  ? null
                  : () => context
                      .read<RoomProvider>()
                      .create())
        ],
      ),
    );
  }
}
