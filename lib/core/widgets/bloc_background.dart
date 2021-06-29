import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutterproject1/core/services/spotify_search.dart';
import 'package:flutterproject1/widgets.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotify_sdk/models/track.dart';

final clientId = '459d947244ec4bf984990e36170dc964';
final clientSecret = 'd6b24db5f71340e386b0d7d6f327b9b9';
final redirect = 'https://musable.herokuapp.com/';

enum SpotifyAction { Connect, Authenticate, Play, Pause, Stop }

class BlocUri {
  Future<String> uri;
  // ignore: close_sinks
  final _stateStreamController = StreamController<SpotifyAction>();
  StreamSink<SpotifyAction> get uriSink => _stateStreamController.sink;
  Stream<SpotifyAction> get uriStream => _stateStreamController.stream;

  // ignore: close_sinks
  final _eventStreamController = StreamController<SpotifyAction>();
  StreamSink<SpotifyAction> get eventSink => _eventStreamController.sink;
  Stream<SpotifyAction> get eventStream => _eventStreamController.stream;

  BlocUri() {
    eventStream.listen((event) {
      if (event == SpotifyAction.Play) {
        play();
      }
    });
  }
}

enum MyEvent { eventA, eventB }

abstract class MyState {}

class StateA extends MyState {}

class StateB extends MyState {}

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(StateA());

  @override
  Stream<MyState> mapEventToState(MyEvent event) async* {
    switch (event) {
      case MyEvent.eventA:
        yield StateA();
        break;
      case MyEvent.eventB:
        yield StateB();
        break;
    }
  }
}

class SpotifySearchService {
  Future<SpotifySearchResult> request(String query) async {
    Map<String, dynamic> data = {
      'query': query,
      'type': 'track',
      'market': 'US',
      'limit': '5'
    };
    // var xd = Uri.parse('https://api.spotify.com/v1/search%27');
    print(data);
    var url =
        "https://api.spotify.com/v1/search?query=$query&type=track&market=US&offset=0&limit=5";
    // ignore: await_only_futures
    var uri = await Uri(path: url, queryParameters: data);
    print("\n\nthe uri is $uri\n\n");
    var response = await http.get(
        Uri.https('api.spotify.com', '/v1/search', data),
        headers: {HttpHeaders.authorizationHeader: '$authToken'});

    /*
uri, headers: {
      HttpHeaders.authorizationHeader: '$authToken',
    }

    ?query=$query&type=track&market=US&offset=0&limit=5
    */
    print("\n\nthe response is ${response.body}\n\n");
    var body = await jsonDecode(response.body) as Map;

    print("\n\nthe body is $body");
    if (body.containsKey('error')) {
      throw Exception('service returns error');
    }
    return SpotifySearchResult.fromJson(body['tracks']);
  }
}

class SpotifySearchResult {
  const SpotifySearchResult(this.uris);

  factory SpotifySearchResult.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    var uris = <String>[];

    for (var track in items) {
      var uri = track["uri"];
      uris.add(uri);
    }

    return SpotifySearchResult(uris);
  }

  final List<String> uris;
}

Future<String> songSearch(String songTitle) async {
  var searchString = '$songTitle';
  //var qString = searchString.replaceAll(' ', '+');

  var service = SpotifySearchService();
  var result = await service.request(searchString);

  final song = result.uris.first;
  return song;
}

final Logger _logger = Logger();

void setStatus(String code, {String message}) {
  var text = message ?? '';
  _logger.i('$code$text');
}

Future<void> play() async {
  print("currently playing");

  try {
    print('\n\n');
    print(await songSearch("kiss kiss"));
    print('\n\n');
    await SpotifySdk.play(spotifyUri: 'spotify:track:6mADjHs6FXdroPzEGW6KVJ');
    //user input
    print("should be playing song");
  } on PlatformException catch (e) {
    print(Text("platform exception"));
  } on MissingPluginException {
    print(Text("missing plugin"));
  }
}

Future<void> pause() async {
  print("currently paused");
  try {
    await SpotifySdk.pause();
  } on PlatformException catch (e) {
    print(Text("platform exception"));
  } on MissingPluginException {
    print(Text("missing plugin"));
  }
}

Future<void> resume() async {
  print("resuming song");
  try {
    await SpotifySdk.resume();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipNext() async {
  try {
    await SpotifySdk.skipNext();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> skipPrevious() async {
  try {
    await SpotifySdk.skipPrevious();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekTo() async {
  try {
    await SpotifySdk.seekTo(positionedMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> seekToRelative() async {
  try {
    await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

void connectToSpotify() async {
  await SpotifySdk.connectToSpotifyRemote(
      clientId: "$clientId", redirectUrl: "$redirect");
}
//////////////////////////////////////
///
///
///
/////////////////////////////////////

Future<String> getAuthenticationToken() async {
  try {
    var authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: clientId,
        redirectUrl: redirect,
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public,user-read-currently-playing');
    setStatus('Got a token: $authenticationToken');
    return authenticationToken;
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
    return Future.error('$e.code: $e.message');
  } on MissingPluginException {
    setStatus('not implemented');
    return Future.error('not implemented');
  }
}

Future<void> connectToSpotifyRemote() async {
  try {
    var result = await SpotifySdk.connectToSpotifyRemote(
        clientId: clientId, redirectUrl: redirect);
    setStatus(
        result ? 'connect to spotify successful' : 'connect to spotify failed');
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message + ' Please connect to the internet');
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

void connection() {
  //connectToSpotifyRemote();
  getAuthenticationToken();
}
