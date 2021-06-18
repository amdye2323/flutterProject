import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Align leftAlign(Function reFun, IconData icon, Alignment ali) {
  return Align(
    alignment: ali,
    child: FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: reFun,
      child: Icon(
        icon,
        color: Color(0xFF527DAA),
      ),
    ),
  );
}

ElevatedButton scanButton(Function reFun, String name) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Color(0xFF527DAA), onPrimary: Colors.white, elevation: 5),
      onPressed: reFun,
      child: Text(name));
}
