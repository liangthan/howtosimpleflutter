import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:howtosimple/services/auth.dart';
import 'dart:ui';

import 'package:howtosimple/shared/constants.dart';
import 'package:howtosimple/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
                image: DecorationImage(image: ExactAssetImage('images/signin.png'), fit: BoxFit.cover),
              ),
              padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Image.asset('images/howtosimple1.png', height: 120,)
                      ),
                      ClipRRect(
                        child: Container(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Sign in to HowToSimple', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: Icon(Icons.person_add, color: Colors.white),
                                    tooltip: 'Create New Account',
                                    onPressed: (){
                                      widget.toggleView();
                                    },
                                  ),
                                ),
                              ),
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
                                Align(alignment: Alignment.centerLeft, child: Text('Username', textAlign: TextAlign.left,)),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                                  validator: (val){
                                    return val.isEmpty ? "Enter an email" : null;
                                  },
                                  autocorrect: false,
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
                                    return val.isEmpty ? "Enter a password" : null;
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
                                child: Text('Sign In'),
                                onPressed: ()async{
                                  if(_formKey.currentState.validate()){
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.signInEmPa(emai, pass);
                                    if(result == null) {
                                      setState(() {
                                        loading = false;
                                        erro = "Wrong Email or Password";
                                        errosz = 16.0;
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