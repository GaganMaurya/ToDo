// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: use_key_in_widget_constructors
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool islogin = false;

  startauth() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email , _password , _username);
    }
  }

  submitform(String email ,  String password , String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (islogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        String? uid = authResult.user?.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (e) {
      print(e);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 12),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!islogin)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Incorrect Username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: "Enter Username",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                    SizedBox(height: 10),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter Email",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(height: 10),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter Password",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(!islogin ? "Sign Up" : " Login",
                              style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                islogin = !islogin;
                              });
                            },
                            child: islogin
                                ? Text("Not a member ?")
                                : Text("Already a Member ?")))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
