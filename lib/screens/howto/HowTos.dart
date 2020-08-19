import 'package:flutter/material.dart';
import 'package:howtosimple/models/user.dart';
import 'package:howtosimple/services/database.dart';
import 'package:howtosimple/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:howtosimple/screens/HowTo/HowTo.dart';
import 'package:howtosimple/models/howtoitem.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/howtostep.dart';

class HowToPreviewWidget extends StatefulWidget {
  HowToPreviewWidget({Key key, this.howto}) : super(key: key);
  final HowToItem howto;
  @override
  _HowToPreviewState createState() => _HowToPreviewState();
}

class _HowToPreviewState extends State<HowToPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.collections),
        title: Text(widget.howto.title),
        onTap: ()async{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StreamProvider<List<HowToStep>>.value(value: DataService(uid: widget.howto.id).displayHowToSteps,
      child: HowToWidget(howto: widget.howto,))),
          );
        },
      ),
    );
  }
}


class HowTosPage extends StatefulWidget {
  HowTosPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _HowTosState createState() => _HowTosState();
}

class _HowTosState extends State<HowTosPage> {
  bool darkMode = false;
  @override
  Widget build(BuildContext context) {
    List<HowToItem> howtos = new List<HowToItem>();
    howtos = Provider.of<List<HowToItem>>(context) ?? new List<HowToItem>();
    var howtoList = [];
    
    howtos.forEach((howto){
      howtoList.insert(0, new HowToPreviewWidget(howto: howto,));
    });
    final user = Provider.of<User>(context);
    return StreamBuilder<DisplayUser>(
      stream: DataService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DisplayUser du = snapshot.data;
          darkMode = du.darkMode == "yes" ? true : false;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: darkMode ? Colors.blueGrey[900] : Colors.black12,
            ),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                for(var howto in howtoList) 
                  howto,
                Card(
                  child:
                  ListTile(
                    title: Icon(Icons.add),
                    onTap: (){
                      createAlertDialog(context, widget.user);
                    },
                  ),
                  
                )
              ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
  createAlertDialog(BuildContext context, User user) {
    final DataService _ds = DataService(uid: user.uid);
    TextEditingController customController = new TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('New HowTo'),
        content:TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('OK'),
            onPressed: ()async{
              await _ds.updateHowTo(customController.text.toString());
              Navigator.of(context).pop();
            },
          )
        ],
      );
    });
  }
}
