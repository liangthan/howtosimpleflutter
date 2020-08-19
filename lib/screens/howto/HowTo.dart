//import 'dart:io';
import 'package:howtosimple/services/database.dart';
import 'package:howtosimple/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../models/howtoitem.dart';
import 'package:flutter/material.dart';
import '../../models/howtostep.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/user.dart';
import 'package:howtosimple/screens/howto/HowToEdit.dart';

class HowToStepWidget extends StatefulWidget {
  HowToStepWidget({Key key, this.id, this.stepNo, this.title, this.description}) : super(key: key);
  final String id;
  final int stepNo;
  final String title;
  final String description;
  @override
  _HowToStepState createState() => _HowToStepState();
}

class _HowToStepState extends State<HowToStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Step '+widget.stepNo.toString(), style: TextStyle(fontSize: 24, color: Colors.white), ),
            color: Color(0xff049372+widget.stepNo*15),
            width: double.infinity,
            padding: EdgeInsets.all(10),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Text(widget.title, style: TextStyle(fontSize: 24),),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Text(widget.description, style: TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }
}

class HowToWidget extends StatefulWidget {
  HowToWidget({Key key, this.howto}) : super(key: key);
  final HowToItem howto;
  @override
  _HowToState createState() => _HowToState();
}

class _HowToState extends State<HowToWidget> {
  bool darkMode;
  @override
  Widget build(BuildContext context) {
    List<HowToStep> steps = new List<HowToStep>();
    steps = Provider.of<List<HowToStep>>(context) ?? new List<HowToStep>();
    var stepCompare = [];
    var stepList = [];
    steps.forEach((step){
      stepCompare.add(new HowToStep(id: step.id, howtoid: step.howtoid, stepnumber: step.stepnumber, title: step.title, description: step.description));
    });
    stepCompare.sort((a,b)=>a.stepnumber.compareTo(b.stepnumber));
    for(var step in stepCompare) {
      stepList.add(new HowToStepWidget(id: step.id, stepNo: step.stepnumber, title: step.title, description: step.description,));
    }
    final user = Provider.of<User>(context);
    return StreamBuilder<DisplayUser>(
      stream: DataService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DisplayUser du = snapshot.data;
          darkMode = du.darkMode == "yes" ? true : false;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.howto.title),
              backgroundColor: Color(0xff019875),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: (val)async{
                    if(val == "Edit")
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StreamProvider<List<HowToStep>>.value(value: DataService(uid: widget.howto.id).displayHowToSteps,
                        child: HowToEditWidget(howto: widget.howto,))),
                      );
                    }
                    else if(val == "Delete")
                    {
                      createAlertDialog(context);
                    }
                    else
                    {
                      print("hmm");
                    }
                  },
                  itemBuilder: (_) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: darkMode?Colors.blueGrey[900]:Colors.black12,
              ),
              child: SingleChildScrollView(
                child:
                Column(
                  children: <Widget>[
                  for(var step in stepList)
                    step,
                ],
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
  createAlertDialog(BuildContext context) {
    //TextEditingController customController = new TextEditingController();
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Are you sure you want to delete this HowTo?'),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Yes'),
            onPressed: (){
              var result = deleteHowTo(widget.howto);
              Navigator.pop(context);
              Navigator.pop(context, result);
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('No'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }
  deleteHowTo(HowToItem howto) async {
    DataService().deleteHowTo(howto.id);
    DataService().deleteStepsWithHowTo(howto.id);
  }
}