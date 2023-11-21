// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:todolist/auth/authform.dart';

// ignore: use_key_in_widget_constructors
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
        ),
        body: AuthForm(),
    );
  }
}
