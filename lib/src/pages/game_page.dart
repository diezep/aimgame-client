import 'package:aimgame/main.dart';
import 'package:aimgame/src/game/game.dart';
import 'package:aimgame/src/providers/room_provider.dart';
import 'package:aimgame/src/widgets/gamesettings_widget.dart';
import 'package:aimgame/src/widgets/leaderboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key}) : super(key: key);

  static final routeName = '/game';

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool inFullscreen = false;
  Future<bool> _onWillPop() {}
  TextEditingController textController = TextEditingController();
  bool buttonEnabled = false;
  var _formKey = GlobalKey<FormState>();

  bool nameSetted = false;

  GameCanvas gameCanvas = GameCanvas();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (context) {
        
        Map<String, String> env = Platform.environment;
        // String urlServer = 'https://aimgame-server.herokuapp.com';
        String urlServer = 'http://localhost:5000';
        
        RoomProvider room = RoomProvider(urlServer);
        room.gameCanvas = gameCanvas;
        room.initializeSockets();
        return room;
      },
      builder: (context, build) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: ColorPalette.background,
          body: LayoutBuilder(builder: (_, constraints) {
            if (!nameSetted)
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => WillPopScope(
                          onWillPop: _onWillPop,
                          child: Form(
                            key: _formKey,
                            child: new AlertDialog(
                              title: new Text(
                                "Who are you?",
                                style: TextStyle(color: Colors.white),
                              ),
                              // backgroundColor: Colors.white.withOpacity(0.8),
                              content: new TextFormField(
                                controller: textController,
                                enableInteractiveSelection: true,
                                validator: (value) => (value.trim() != null &&
                                        value.trim().length >= 1)
                                    ? null
                                    : 'You have to tell me your name.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelText: 'Code room',
                                    alignLabelWithHint: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fillColor: Colors.white.withOpacity(.17)),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('Ouuh yeah.'),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        context
                                            .read<RoomProvider>()
                                            .setName(textController.text);
                                        Navigator.pop(context);
                                      } else {
                                        print("Can't pop");
                                      }
                                    })
                              ],
                            ),
                          ),
                        ));
                setState(() => nameSetted = true);
              });

            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              // color: Colors.white.withOpacity(0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(children: [
                      gameCanvas.widget,
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Text(
                              'AIM GAME',
                              style: theme.textTheme.headline2
                                  .apply(color: Colors.white),
                            )),
                      ),
                    ]),
                  ),
                  SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Leaderboard(),
                        Expanded(child: Center(child: GameSettings()))
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
