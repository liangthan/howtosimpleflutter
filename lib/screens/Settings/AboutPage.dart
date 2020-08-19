import 'package:flutter/material.dart';
//import 'drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HowToSimple',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AboutPagePage(),
    );
  }
}

class AboutPagePage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}
var _appbartitle = "About";



class _AboutPageState extends State<AboutPagePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_appbartitle),
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          color: Colors.indigo,
          child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
              Container(
                child: Image(image: ExactAssetImage('images/howtosimple1.png'),)
              ),
              Container(
                child: Text('HowToSimple', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('This application was created by Than Liang of the KOTIXSols company. This company is made up of indie developers', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                child: Text('Contact', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('You can contact our company at: contactus@kotixsols.com\nor contact our developer directly at their github page:\nhttps://github.com/liangthan', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                child: Text('Credits', style: TextStyle(fontSize: 24, color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('All images and assets have been created by the developer, except for your own HowTos', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
              ),
              Container(
                child: Image(image: ExactAssetImage('images/signin.png'),)
              ),
              Container(
                child: Image(image: ExactAssetImage('images/register.png'),)
              ),
            ],
        ),
          ),
        ), 
      ),
    );
  }
}
