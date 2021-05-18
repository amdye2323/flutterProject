import 'package:flutter/material.dart';

class pickListView extends StatefulWidget {
  const pickListView({Key key}) : super(key: key);

  @override
  _pickListViewState createState() => _pickListViewState();
}

class _pickListViewState extends State<pickListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("dd")],
      ),
    );
  }
}
