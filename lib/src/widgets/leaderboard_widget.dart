import 'package:aimgame/main.dart';
import 'package:aimgame/src/providers/room_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Leaderboard extends StatelessWidget {
  ThemeData theme;

  List<Map<String, dynamic>> players;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height / 2,
      color: ColorPalette.accent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Text(
                'Leaderboard',
                style: theme.textTheme.headline2,
              ),
            ),
          ),
          Consumer<RoomProvider>(builder: (context, room, child) {
            players = room.players;

            return ListView.builder(
                shrinkWrap: true,
                itemCount: room.players.length,
                itemBuilder: (context, int i) {
                  // return ListTile(
                  //   title:  Text("${room.players[i]['name']} - ${room.players[i]['score']}"),
                  // );

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room.players[i]['name'],
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                              fontSize: 16),
                        ),
                        Text(
                          room.players[i]['score'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  );
                });
          })
        ],
      ),
    );
  }
}
