import 'dart:convert';
import 'dart:io';
import 'package:flutterproject1/core/widgets/bloc_background.dart';
import 'package:flutterproject1/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:spotify_sdk/models/track.dart';

import '../../widgets.dart';

//var authToken =
//'Bearer BQCqoRh5V4Eqoxwf88PIvTAAEOZP79aJyy_L9L_uORmMa15n99aa0xc8hzSIH6CzKn0AYfhLOXJ8nkadzyWNWreUXFg';

var authToken = "Bearer $authCode";

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
    print("\n\n\n\nThe auth token is $authToken");
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
