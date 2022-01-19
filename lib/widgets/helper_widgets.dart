import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget error(String error) {
  return Center(
    child: Text(
      error,
      style: TextStyle(color: Colors.red),
    ),
  );
}

Widget loading() {
  return Center(child: CupertinoActivityIndicator());
}
