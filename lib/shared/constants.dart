import 'package:flutter/material.dart';

const textInputDecoration = 
InputDecoration(
  hintText: '',
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 2.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.indigoAccent, width: 2.0),
  ),
  errorBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.purpleAccent, width: 2.0),
  ),
);