import 'package:flutter/material.dart';
import 'package:howtosimple/shared/loading.dart';
import 'AboutPage.dart';
import 'package:howtosimple/services/database.dart';
import 'package:provider/provider.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/user.dart';

class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  bool darkMode = false;
  bool greeting = true;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(!loading)
    return StreamBuilder<DisplayUser>(
      stream: DataService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DisplayUser du = snapshot.data;
          du.darkMode == "yes" ? darkMode = true : darkMode = false;
          du.greeting == "yes" ? greeting = true : greeting = false;
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: darkMode?Colors.blueGrey[900]:Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                ListTile(
                  leading: Text('Name: ', style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                  title: Text(du.name.isNotEmpty ? du.name : '<empty name, click to edit>', style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                  onTap: (){
                    createAlertDialog(context, du);
                  },
                ),
                SwitchListTile(
                  onChanged: (val)async{
                    setState((){
                      darkMode = !darkMode;
                    });
                    await DataService(uid: user.uid).updateUserData(du.name, darkMode?"yes":"no", greeting?"yes":"no");
                  },
                  value: darkMode,
                  title: Text('Dark Mode', style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                ),
                SwitchListTile(
                  onChanged: (val)async{
                    setState(() {
                      greeting = !greeting;
                    });
                    await DataService(uid: user.uid).updateUserData(du.name, darkMode?"yes":"no", greeting?"yes":"no");
                  },
                  value: greeting,
                  title: Text('Greet on open?', style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                ),
                ListTile(
                  title: Text("About", style: TextStyle(color: darkMode?Colors.white:Colors.black),),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPagePage()),
                  );
                  },
                ),
              ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      }
    );
    else
    return Loading();
  }
  createAlertDialog(BuildContext context, DisplayUser user) {
    final DataService _ds = DataService(uid: user.uid);
    TextEditingController customController = new TextEditingController();
    customController.text = user.name;
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Edit Greeting Name'),
        content:TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('OK'),
            onPressed: ()async{
              await _ds.updateUserData(customController.text.toString(), user.darkMode, user.greeting);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }
}