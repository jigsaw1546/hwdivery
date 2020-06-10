import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/signout_process.dart';

class MainRider extends StatefulWidget {
  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Rider'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      drawer: showDrawer(),
    );
  }
}

Drawer showDrawer() => Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Name User',
              style: TextStyle(fontFamily: 'Prompt', fontSize: 14.0),
            ),
            accountEmail: Text('Login',
          style: TextStyle(fontFamily: 'Prompt', fontSize: 15.0),),
          ),
        ],
      ),
    );

