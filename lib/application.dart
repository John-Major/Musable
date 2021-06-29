import 'package:flutter/material.dart';
import 'package:flutterproject1/features/network_finding_page/search.dart';
import 'package:flutterproject1/widgets.dart';

import 'features/chat_room_page/chat_room_page.dart';

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return BackgroundHomePage();
        break;
      case 1:
        return ChatRoom();
        break;
      case 2:
        return Search();
        break;
      case 3:
        return Center(
            child: Text("This will be the page for the settings room"));
        break;
      default:
        return Center(
          child: Text("Error 404. Page not found"),
        );
    }
  }

  Text _buildTitle(int index) {
    switch (index) {
      case 0:
        return Text("Home Page");
        break;
      case 1:
        return Text("Chat Page");
      case 2:
        return Text("Networking Page");
      case 3:
        return Text("Settings Page");
      default:
        return Text("Different Page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(_selectedIndex),
      ),
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Network',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
