import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutterproject1/widgets.dart';

class BackgroundHomePage extends StatefulWidget {
  BackgroundHomePageState createState() => BackgroundHomePageState();
}

class BackgroundHomePageState extends State<BackgroundHomePage> {
    int numSongs = 0;
    List<Widget> songCards = []; 
    _addItem() {
      setState(() {
        numSongs = numSongs + 1;
        try {
          songCards.add(SongCard());
          print("added item to index $songCards[numSongs]");
        } catch (e) {
          print("\ndidnt work?\n\n");
        }
        
     });
  }
  
  _buildRow(int index) {
    return SongCard();
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () => _addItem(),
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.brush),
          backgroundColor: Colors.blue,
          label: 'Second',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice),
          backgroundColor: Colors.green,
          label: 'Third',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
      ],
    ),
      body: ListView.builder(
        itemCount: songCards.length,
        itemBuilder: (context, index){
          final item = songCards[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction){
              setState(() {
                songCards.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$item removed from playlist')
                )
              );
            },
            child: _buildRow(index),
            );

        }
      )      
    );
  }
}