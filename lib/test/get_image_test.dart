// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:flutterproject1/core/services/spotify_search.dart';
// import 'package:flutterproject1/core/widgets/bloc_background.dart';
// import 'package:flutterproject1/widgets.dart';
// import 'package:flutter/services.dart';
// import 'package:spotify_sdk/models/image_uri.dart';
// import 'package:spotify_sdk/models/player_state.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';
// import 'package:logger/logger.dart';
// import 'package:flutter_test/flutter_test.dart';

// var tempSong = 'spotify:track:69LvvkHnFFnX3d5eNObtMo';

// final clientId = '459d947244ec4bf984990e36170dc964';
// final clientSecret = 'd6b24db5f71340e386b0d7d6f327b9b9';
// final redirect = 'https://musable.herokuapp.com/';

// main() {
//   test('getImage', () async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await SpotifySdk.connectToSpotifyRemote(
//         clientId: clientId, redirectUrl: redirect);
//     var image = await SpotifySdk.getImage(
//       imageUri: ImageUri(tempSong),
//       dimension: ImageDimension.small,
//     );
//   });
// }
