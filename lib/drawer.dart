import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/howtoitem.dart';
import 'package:howtosimple/models/user.dart';
import 'package:howtosimple/services/auth.dart';
import 'package:howtosimple/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/HowTo/HowTos.dart';
import 'screens/Settings/Settings.dart';
import 'services/auth.dart';
import 'package:howtosimple/services/database.dart';
import 'package:provider/provider.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HowToSimple',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
    );
  }
}

enum DrawerSelection {howto, settings}

StatefulWidget switchBody(DrawerSelection _drawerSelection, User user) {
  StatefulWidget newBody = HowTosPage();
  switch(_drawerSelection)
  {
    case(DrawerSelection.howto) :
      newBody = HowTosPage(user: user);
      break;
    case(DrawerSelection.settings) :
      newBody = SettingsWidget();
      break;
    default:
      newBody = HowTosPage(user: user);
      break;
  }
  return newBody;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.user}) : super(key: key);
  final User user;
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
var _appbartitle = "HowToSimple";

SharedPreferences localStorage;

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  bool darkMode = false;
  DrawerSelection _drawerSelection = DrawerSelection.howto;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<HowToItem>>.value(
      //initialData: List(),
      value: DataService(uid: widget.user.uid).displayHowTos,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_appbartitle),
          backgroundColor: Colors.indigo,
        ),
        body: switchBody(_drawerSelection, widget.user),
        drawer: StreamBuilder<DisplayUser>(
          stream: DataService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              DisplayUser du = snapshot.data;
              darkMode = du.darkMode == "yes" ? true : false;
              return Drawer(
                child: Container(
                  decoration: BoxDecoration(
                    color: darkMode?Colors.blueGrey[900]:Colors.white,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage('images/howtosimple1.png'),
                            ),
                            Container(
                              child: 
                                Text(du.name,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                        ),
                      ),
                      Container(
                        child: 
                        ListTile(
                          selected: _drawerSelection == DrawerSelection.howto,
                          leading: Icon(Icons.book, color: _drawerSelection == DrawerSelection.howto ? Colors.white : Colors.black87),
                          title: Text('HowTo', style: TextStyle(color: _drawerSelection == DrawerSelection.howto ? Colors.white : Colors.black87),),
                          onTap: () {
                            setState(() {
                              _drawerSelection = DrawerSelection.howto;
                              _appbartitle = "HowToSimple";
                              Navigator.pop(context);
                            });
                          },
                        ),
                        color: _drawerSelection == DrawerSelection.howto ? Colors.indigo : Colors.white,
                      ),
                      Container(
                        child: ListTile(
                          selected: _drawerSelection == DrawerSelection.settings,
                          leading: Icon(Icons.settings, color: _drawerSelection == DrawerSelection.settings ? Colors.white : Colors.black87),
                          title: Text('Settings', style: TextStyle(color: _drawerSelection == DrawerSelection.settings ? Colors.white : Colors.black87),),
                          onTap: () {
                            setState(() {
                              _drawerSelection = DrawerSelection.settings;
                              _appbartitle = "Settings";
                              Navigator.pop(context);
                            });
                          },
                        ),
                        color: _drawerSelection == DrawerSelection.settings ? Colors.indigo : Colors.white,
                      ),
                      ListTile(
                        title: Text('Account', style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                      ),
                      Container(
                        child: ListTile(
                          leading: Icon(Icons.backspace, color: Colors.black87,),
                          title: Text('Logout'),
                          onTap: ()async{
                            Navigator.pop(context);
                            await _auth.signOut();
                          },
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Loading();
            }
          }
        )
      ),
    );
  }
}
