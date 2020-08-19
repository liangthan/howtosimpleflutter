import 'package:flutter/material.dart';
import 'package:howtosimple/drawer.dart';
import 'package:howtosimple/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user != null){
      return MyHomePage(user: user,);
    } else {
      return Authenticate();
    }
  }
}