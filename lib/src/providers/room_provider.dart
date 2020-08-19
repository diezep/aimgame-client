import 'dart:async';
import 'dart:convert';

import 'package:aimgame/src/game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomProvider with ChangeNotifier {
  // Keep room
  static final RoomProvider _instancia = RoomProvider._internal();

  String _urlServer;
  factory RoomProvider([String __urlServer]) {
    _instancia._urlServer = __urlServer ?? null;
    _instancia._socket = IO.io(__urlServer + namespace) ?? null;
    return _instancia;
  }
  RoomProvider._internal();

  static String namespace = "/game";

  IO.Socket _socket;
  IO.Socket get socket => _socket;

  String _name;
  String get name => _name;
  set name(String n) => _name = n;

  bool _inGame = false;
  bool get inGame => _inGame;

  String _code;
  String get code => _code;

  void Function(String, Offset) pointSocketCallback;
  GameCanvas gameCanvas;

  List<Map<String, dynamic>> _players = [];
  List<Map<String, dynamic>> get players {
    _players.sort((a, b) => int.tryParse(a['score'].toString())
        .compareTo(int.tryParse(b['score'].toString())));
    return _players;
  }

  void initializeSockets() {
    _socket.on('connect', (data) => print('Connected to server.'));
    _socket.on('disconnect', (data) => print('Disconnected to server.'));
    _socket.on('join', onJoinPlayer);
    _socket.on('leave', onLeavePlayer);
    _socket.on('hit', onHitPoint);
    _socket.on('point', onGeneratePoint);
    _socket.on("leave", onLeavePlayer);
  }

  Future<void> create() async {
    if (inGame) throw Future.error('You are currently in game. Leave.');

    String endpoint = '/create';
    Map<String, dynamic> body = {'name': _name};

    var res = await http.post(_urlServer + endpoint, body: body);
    var jsonRes = json.decode(res.body);

    _code = jsonRes['code'];
    this.join(_code);
  }

  Future<void> join(String code) async {
    print('Entering to the room: $name @ $code');

    _inGame = true;
    _code = code;

    _socket.emit(
      'join',
      {'code': code, 'name': _name},
    );

    notifyListeners();
  }

  void leave() async {
    print('Leaving of the room: $_code @ $_name ');
    socket.emit('leave', {'code': _code, 'name': _name});

    _code = '';
    _inGame = false;
    _players = [];

    gameCanvas.leaveRoom();

    notifyListeners();
  }

  void onHitPoint(data) {
    print('onHitPoint called. ' + data.toString());

    Map<String, dynamic> jsonData = jsonDecode(data) as Map;

    String _sidHits = jsonData['sid'];
    int index = _players.indexWhere((p) => p['sid'] == _sidHits);
    String hitCode = jsonData['hitCode'];

    gameCanvas.removePoint(hitCode);
    _players[index]['score'] += 1;

    notifyListeners();
  }

  void onGeneratePoint(data) {
    print('onGeneratedPoint called.' + data.toString());

    Map<String, dynamic> jsonData = jsonDecode(data) as Map;
    gameCanvas.generatePoint(
        jsonData['hitCode'],
        Offset(jsonData['cords']['x'], jsonData['cords']['y']),
        (String code) => onPlayerHitPoint(code));

    notifyListeners();
  }

  void setName(String __name) {
    _name = __name;
    notifyListeners();
  }

  void onJoinPlayer(data) {
    print('onJoinPlayer called.' + data.toString());

    Map<String, dynamic> jsonData = jsonDecode(data) as Map;

    if (jsonData['name'] != null) {
      Map<String, dynamic> newPlayer = Map<String, dynamic>.from(jsonData);
      _players.add(newPlayer);
    } else {
      List<Map<String, dynamic>> __players =
          List<Map<String, dynamic>>.from(jsonData['players']);
      _players = __players;
    }

    notifyListeners();
  }

  void onLeavePlayer(data) {
    print('onLeavePlayer called.' + data.toString());

    Map<String, dynamic> jsonData = jsonDecode(data) as Map;

    String _sid = jsonData['sid'];
    _players.removeWhere((p) => p['sid'] == _sid);
    notifyListeners();
  }

  void onPlayerHitPoint(String hitCode) {
    print('Hit point called. #' + hitCode);
    socket.emit('point', {'code': hitCode, 'room': _code});
  }
}
