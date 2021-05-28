// import 'package:spotify/spotify.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// final clientId = '459d947244ec4bf984990e36170dc964';
// final clientSecret = 'd6b24db5f71340e386b0d7d6f327b9b9';

// final redirectUri = 'spotify:playlist:31ZU4IzLKbm7rsxmgoFG0I';
// final scopes = ['user-read-email', 'user-library-read'];

// final credentials = SpotifyApiCredentials(clientId, clientSecret);
// final grant = SpotifyApi.authorizationCodeGrant(credentials);

// final authUri = grant.getAuthorizationUrl(
//   Uri.parse(redirectUri),
//   scopes: scopes, // scopes are optional
// );
// var responseUri;
// // await redirect(authUri);
// Future listen(String redirectURI){

//   return 
// }

// void playSong() async {
//   final artist = await spotify.artists.get('0OdUWJ0sBjDrqHygGUXeCF');
//   responseUri = await listen(redirectUri);
// }


// class SpotifyPlaylist extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//    javascriptMode: JavascriptMode.unrestricted,
//    initialUrl: "%{authUri}",
//    navigationDelegate: (navReq) {
//      if (navReq.url.startsWith(redirectUri)) {
//        responseUri = navReq.url;
//        return NavigationDecision.prevent;
//      }

//      return NavigationDecision.navigate;
//    },
//  );
//   }
// }

// final spotify = SpotifyApi.fromAuthCodeGrant(grant, responseUri);


