import 'package:flutter/material.dart';
import 'package:hiwwoydelivery/utility/signout_process.dart';

class MainAdmin extends StatefulWidget {
  @override
  _MainAdminState createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Admin Control'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => signOutProcess(context))
        ],
      ),
    );
  }
}
