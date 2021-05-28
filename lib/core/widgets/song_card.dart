//import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

final clientId = '459d947244ec4bf984990e36170dc964';
final clientSecret = 'd6b24db5f71340e386b0d7d6f327b9b9';
final redirect = 'https://musable.herokuapp.com/';

// ignore: must_be_immutable
class SongCard extends StatelessWidget {
  //var audioManagerInstance = AudioManager.instance;

  final Logger _logger = Logger();

  void setStatus(String code, {String message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  Future<void> play() async {
    print("currently playing");
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Text("song :)"),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(2),
      ),
    );
  }
}
