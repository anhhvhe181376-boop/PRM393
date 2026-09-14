import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// stateless la nhung cai khong thay doi tren giao dien
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home :Scaffold(
        body: Center(child: Text("Hello")),
      )
    );
    throw UnimplementedError();
  }
}
