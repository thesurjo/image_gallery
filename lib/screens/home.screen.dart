import 'package:flutter/material.dart';

import '../export/screen.export.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  _selectedBody(value) {
    switch (value) {
      case 0:
        return Dashboard(
          dashboardKey: _scaffoldkey,
        );
      case 1:
        return Album(
          albumKey: _scaffoldkey,
        );
      default:
        return Dashboard(
          dashboardKey: _scaffoldkey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (value) => {
            setState(() {
              _selectedIndex = value;
            })
          },
          selectedIndex: _selectedIndex,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.photo),
              icon: Icon(Icons.photo_outlined),
              label: 'Photos',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.photo_album),
              icon: Icon(Icons.photo_album_outlined),
              label: 'Albums',
            ),
          ],
        ),
        body: _selectedBody(_selectedIndex));
  }
}
