import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:howtosimple/shared/constants.dart';
import 'package:howtosimple/shared/loading.dart';
import '../../services/auth.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String emai = "";
  String pass = "";
  String erro = "";
  double errosz = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.indigo[10],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody:false,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: ExactAssetImage('images/register.png'), fit: BoxFit.cover),
              ),
              padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back, color: Colors.white),
                                    tooltip: 'Back',
                                    onPressed: (){
                                      widget.toggleView();
                                    },
                                  ),
                                ),
                              ),
                              Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                          width: double.infinity,
                        ),
                      ),
                      ClipRRect(
                        child: Container(
                          child: Center(child: Text(erro, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: errosz),)),
                          decoration: BoxDecoration(
                            color: Colors.purple[800],
                          ),
                          width: double.infinity,
                        ),
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Align(alignment: Alignment.centerLeft, child: Text('Email', textAlign: TextAlign.left,)),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                                  autocorrect: false,
                                  validator: (val){
                                    return val.isEmpty ? "Enter an email" : null;
                                  },
                                  onChanged: (val){
                                    setState(() {
                                      emai = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Align(alignment: Alignment.centerLeft, child: Text('Password', textAlign: TextAlign.left,)),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                                  autocorrect: false,
                                  obscureText: true,
                                  validator: (val){
                                    return val.length < 6 ? "Enter a password 6+ chars long" : null;
                                  },
                                  onChanged: (val){
                                    setState(() {
                                      pass = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        child: Container(
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: RaisedButton(
                                color: Colors.white,
                                child: Text('Create Account'),
                                onPressed: ()async{
                                  if(_formKey.currentState.validate()){
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.registerEmPa(emai, pass);
                                    if(result == null) {
                                      setState(() {
                                        erro = "That email is invalid";
                                        errosz = 16.0;
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}