import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutterproject1/core/services/spotify_search.dart';
import 'package:flutterproject1/widgets.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

final clientId = '459d947244ec4bf984990e36170dc964';
final clientSecret = 'd6b24db5f71340e386b0d7d6f327b9b9';
final redirect = 'https://musable.herokuapp.com/';

var showSong = false;
var displaySongBar = false;
var authCode = '';
String currentSong;
String tempSong;
int numSongs = 0;
Track track;

class Song {
  String uri;
  ImageUri uriImage;
  String title;
  String artist;
  Song(String _uri, ImageUri _uriImage, String _title, String _artist) {
    uri = _uri;
    uriImage = _uriImage;
    title = _title;
    artist = _artist;
  }
}

typedef void Action(Song song);

List<Song> songCards = [
  Song("https://images.dog.ceo/breeds/terrier-dandie/n02096437_4041.jpg",
      ImageUri("https://picsum.photos/250?image=9"), "_title", "_artist"),
  Song("https://picsum.photos/250?image=9",
      ImageUri("https://picsum.photos/250?image=9"), "_title2", "_artist2")
];
final Logger _logger = Logger();

class BackgroundHomePage extends StatefulWidget {
  BackgroundHomePageState createState() => BackgroundHomePageState();
}

class BackgroundHomePageState extends State<BackgroundHomePage> {
  var songPlaying = false;

  Song currentSong;
  bool _loading = false;
  bool _connected = false;

  void setStatus(String code, {String message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
        clientId: clientId,
        redirectUrl: redirect,
      );
      authCode = authenticationToken;
      print("THE AUTHCODE DURING FUNCTION IS $authCode");
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error(
          '\n\n\nTHIS IS THE AUTHENTICATION ERROR$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: clientId, redirectUrl: redirect);
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message + ' Please connect to the internet');
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  void connectToSpotify() async {
    await SpotifySdk.connectToSpotifyRemote(
        clientId: "$clientId", redirectUrl: "$redirect");
  }

  _goToSearchScreen() async {
    Song song = await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SearchSongPage()));
    if (song != null) {
      List<Song> song2 = songCards
          .where((element) =>
              element.title == song.title && element.artist == song.artist)
          .toList();
      if (song2.isEmpty) {
        songCards.add(song);
        setState(() {});
      }

      tempSong = song.uri;
      // setState(() {
      // to use the seekbar in build method, returned by playerStateWidget
      //       });
      playerStateWidget(onSongRetrived);
    }
  }

  // _buildRow(int index, var track) {
  //   return playerStateWidget();
  // }

  void connection() {
    getAuthenticationToken();
    print("THE AUTHCODE WHEN HIT CONNECTION IS $authCode");
    connectToSpotifyRemote();
  }

  onPlayClicked(Song song) {
//    print('playing ${song.artist}');
    currentSong = song;
    setState(() {});
  }

// song retrived from sportify sdk
  onSongRetrived(Song song) {
    print('playing ${song.artist}');
    currentSong = song;
    List<Song> song2 =
        songCards.where((element) => element.title == song.title).toList();
    if (song2.isEmpty) {
      songCards.add(song);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget playWidget;
    return Scaffold(
      floatingActionButton: SpeedDial(
        marginEnd: 18,
        marginBottom: 20,
        icon: Icons.add,
        activeIcon: Icons.remove,
        buttonSize: 56.0,
        visible: true,
        closeManually: false,
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        // orientation: SpeedDialOrientation.Up,
        // childMarginBottom: 2,
        // childMarginTop: 2,
        children: [
          SpeedDialChild(
            child: Icon(Icons.accessibility),
            backgroundColor: Colors.red,
            label: 'Add Spotify Song',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => _goToSearchScreen(),
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.blue,
            label: 'Connect to spotify',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => connection(),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: 'Refresh',
            labelStyle: TextStyle(fontSize: 18.0),
            // onTap: () => changeMain(),
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: songCards.length,
          itemBuilder: (context, index) {
            final item = songCards[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  songCards.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$item removed from playlist')));
              },
//              child: _buildRow(index, item),
              child: songCard2(item, onPlayClicked),
            );
          }),
      //displaySongBar ? playerStateWidget() : null,
      bottomNavigationBar: BottomAppBar(
          child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (currentSong != null)
                    ? Image.network(
                        currentSong.uri,
                        scale: 1.8,
                      )
                    : Text(""),
                GestureDetector(
                  child: Icon(
                    Icons.play_arrow,
                    size: 100,
                  ),
                  onTap: () {
                    //play(song);
                    songPlaying = true;
                    setState(() {
                      displaySongBar = true;
                    });
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.pause,
                    size: 100,
                  ),
                  onTap: () {
                    if (songPlaying) {
                      pause();
                      songPlaying = false;
                    } else {
                      resume();
                      songPlaying = true;
                    }
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.stop,
                    size: 100,
                  ),
                  onTap: () {
                    pause();
                    songPlaying = false;
                  },
                ),
              ],
            ),
            playerStateWidget(onSongRetrived)
          ],
        ),
      )),
    );
  }

  // changeMain() {
  //   setState(() {
  //     print("Changed state of main");
  //   });
  // }
}

class SearchSongPage extends StatefulWidget {
  @override
  _SearchSongPageState createState() => _SearchSongPageState();
}

class _SearchSongPageState extends State<SearchSongPage> {
  Widget songCard(BuildContext context, var track) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Text(track.artist.name),
            spotifyImageWidget(track.imageUri)
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.all(2),
      ),
      // onTap: () => _addItem(tempSong, track),
    );
  }

  _goBackHomePage() {
    Navigator.pop(context, tempSong);
  }

  _addItem(var uri, track) {
    setState(() {
      numSongs = numSongs + 1;
      try {
        songCards.add(Song(uri, track.imageUri, track.name, track.artist.name));
        print(songCards.length);
        print("added item to index $songCards[numSongs]");
      } catch (e) {
        print("\ndidnt work?\n\n");
      }
    });
  }

  void changeScreen(String text) async {
    print("user input is $text");
    showSong = true;
    //tempSong = await songSearch(text);
  }

  Widget clickableSongInfo() {
    print("wtf");
    print("wtf");
    if (showSong) {
      print("\n\n\nShould show song\n\n\n");
      return StreamBuilder<PlayerState>(
          stream: SpotifySdk.subscribePlayerState(),
          builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
            track = snapshot.data?.track;
            var playerState = snapshot.data;

            if (playerState == null || track == null) {
              return Center(
                child: Container(),
              );
            }
            return songCard(context, track);
          });
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String userInput;
    return Scaffold(
      appBar: AppBar(title: Text("Search a Song")),
      body: Column(
        children: [
          Container(
            child: TextField(
              style: TextStyle(fontSize: 30),
              //expands: true,
              // minLines: null,
              // maxLines: null,
              decoration:
                  InputDecoration(isCollapsed: true, hintText: "Search Song"),
              onSubmitted: (String text) async {
                tempSong = await songSearch(text);
//                playerState();

                //               Song song = new Song(tempSong, );
                //tempSong = await songSearch(text);
                // setState(() {
                //   changeScreen(text);
                // });
                //setState(() {});
              },
            ),
            height: 100,
          ),
          clickableSongInfo()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goBackHomePage(),
      ),
    );
  }
}

Widget playerStateWidget(Action action) {
  return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        track = snapshot.data?.track;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Text("no song being played"),
          );
        }
        // Song song =
        //     Song(tempSong, track.imageUri, track.name, track.artist.name);
        // action(song);
        return Container(
            child:
                Text("the number of songs in the list is ${songCards.length}"));
      });
}

Widget songCard2(Song track, Action f) {
  print('image data ${track.uri}');
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          //getImage(track.ImageUri)
          leading: Icon(Icons.album),
          title: Text('${track.artist}'),
          subtitle: Text('${track.artist}'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image.network(
              track.uri,
              scale: 1.8,
            ),
            const SizedBox(width: 8),
            TextButton(
              child: const Text('PLAY'),
              onPressed: () {
                f(track);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}

Widget spotifyImageWidget(ImageUri imageCode) {
  print("The temp song uri should be $tempSong");
  return FutureBuilder(
      future: SpotifySdk.getImage(
        imageUri: imageCode,
        dimension: ImageDimension.xSmall,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        print("The number of songs in class ${songCards.length}");
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else if (snapshot.hasError) {
          setStatus(snapshot.error.toString());
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Error getting image')),
          );
        } else {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Getting image...')),
          );
        }
      });
}

void setStatus(String code, {String message}) {
  var text = message ?? '';
  _logger.i('$code$text');
}

//FUTURES
Future<void> play(String songToPlay) async {
  print("currently playing");

  try {
    print('\n\n');
    //print(await songSearch("kiss kiss"));
    print('\n\n');
    await SpotifySdk.play(spotifyUri: '$songToPlay');

    //call playerstate

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

Future getPlayerState() async {
  try {
    return await SpotifySdk.getPlayerState();
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> setShuffle(bool shuffle) async {
  try {
    await SpotifySdk.setShuffle(
      shuffle: shuffle,
    );
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}

Future<void> setRepeatMode(RepeatMode repeatMode) async {
  try {
    await SpotifySdk.setRepeatMode(
      repeatMode: repeatMode,
    );
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
  } on MissingPluginException {
    setStatus('not implemented');
  }
}
