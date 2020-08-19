//import 'dart:io';
import 'package:howtosimple/services/database.dart';
import 'package:howtosimple/shared/loading.dart';
import 'package:provider/provider.dart';

import '../../models/howtoitem.dart';
import 'package:flutter/material.dart';
import '../../models/howtostep.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/user.dart';

class HowToStepEditWidget extends StatefulWidget {
  HowToStepEditWidget({Key key, this.id, this.howtoId, this.stepNo, this.title, this.description}) : super(key: key);
  final String id;
  final String howtoId;
  final int stepNo;
  final String title;
  final String description;
  @override
  _HowToStepEditState createState() => _HowToStepEditState();
}

class _HowToStepEditState extends State<HowToStepEditWidget> {
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
            child: ListTile(
              title: Text('Step '+widget.stepNo.toString(), style: TextStyle(fontSize: 24, color: Colors.white), ),
              onTap: (){
                
              },
              onLongPress: (){
                
              },
            ),
            color: Color(0xff22a7f0),
            width: double.infinity,
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: ListTile(
              trailing: Icon(Icons.edit, color: Colors.black,),
              title: Text(widget.title.toString(), style: TextStyle(fontSize: 24, color: Colors.black), ),
              onTap: (){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Please tap longer to edit this title'),
                  duration: Duration(seconds: 1),
                ));
              },
              onLongPress: ()async{
                final DataService _ds = DataService(uid: "asdf");
                TextEditingController customController = new TextEditingController();
                customController.text = widget.title;
                return showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text('Edit step '+widget.stepNo.toString()+' title'),
                    content:TextField(
                      maxLines: 2,
                      controller: customController,
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        elevation: 5.0,
                        child: Text('SAVE'),
                        onPressed: ()async{
                          await _ds.updateStep(new HowToStep(id: widget.id, howtoid: widget.howtoId, stepnumber: widget.stepNo, title: customController.text.toString(), description: widget.description));
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: ListTile(
              trailing: Icon(Icons.edit, color: Colors.black,),
              title: Text(widget.description.toString(), style: TextStyle(fontSize: 18, color: Colors.black), ),
              onTap: (){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Please tap longer to edit this description'),
                  duration: Duration(seconds: 1),
                ));
              },
              onLongPress: ()async{
                final DataService _ds = DataService(uid: "asdf");
                TextEditingController customController = new TextEditingController();
                customController.text = widget.description;
                return showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Text('Edit step '+widget.stepNo.toString()+' description'),
                    content:TextField(
                      controller: customController,
                      maxLines: 4,
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        elevation: 5.0,
                        child: Text('SAVE'),
                        onPressed: ()async{
                          await _ds.updateStep(new HowToStep(id: widget.id, howtoid: widget.howtoId, stepnumber: widget.stepNo, title: widget.title, description: customController.text.toString()));
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HowToEditWidget extends StatefulWidget {
  HowToEditWidget({Key key, this.howto}) : super(key: key);
  final HowToItem howto;
  @override
  _HowToEditState createState() => _HowToEditState();
}

class _HowToEditState extends State<HowToEditWidget> {
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
      stepList.add(new HowToStepEditWidget(id: step.id, howtoId: step.howtoid, stepNo: step.stepnumber, title: step.title, description: step.description,));
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
              backgroundColor: Color(0xff22a7f0),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: (val)async{
                    if(val == "Add Step")
                    {
                      final DataService _ds = DataService(uid: "asdf");
                      TextEditingController customController = new TextEditingController();
                      return showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text('Add New Step with title'),
                          content:TextField(
                            maxLines: 2,
                            controller: customController,
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              elevation: 5.0,
                              child: Text('ADD NEW'),
                              onPressed: ()async{
                                await _ds.updateStep(new HowToStep(id: null, howtoid: widget.howto.id, stepnumber: stepList.length+1, title: customController.text.toString() != "" ? customController.text.toString():'New Step Title', description: 'New Step Description'));
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                    }
                    else if(val == "Delete Last Step") {
                      return showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text('Are you sure you want to delete the last step?'),
                          actions: <Widget>[
                            MaterialButton(
                              elevation: 5.0,
                              child: Text('Yes'),
                              onPressed: () async{
                                if(stepList.length==0) {
                                  return showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      title: Text('ERROR\nHowTo is already empty'),
                                      actions: <Widget>[
                                        MaterialButton(
                                          elevation: 5.0,
                                          child: Text('OK'),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                                } else {
                                  final DataService _ds = DataService(uid: "asdf");
                                  await _ds.deleteLastStep(stepCompare.last.id);
                                  Navigator.of(context).pop();
                                }
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
                    else
                    {
                      print("hmm");
                    }
                  },
                  itemBuilder: (_) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Add Step',
                      child: Text('Add Step'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Delete Last Step',
                      child: Text('Delete Last Step'),
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
                  Card(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Text('Add New Step'),
                        onPressed: ()async{
                          final DataService _ds = DataService(uid: "asdf");
                          TextEditingController customController = new TextEditingController();
                          return showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text('Add New Step with title'),
                              content:TextField(
                                maxLines: 2,
                                controller: customController,
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  elevation: 5.0,
                                  child: Text('ADD NEW'),
                                  onPressed: ()async{
                                    await _ds.updateStep(new HowToStep(id: null, howtoid: widget.howto.id, stepnumber: stepList.length+1, title: customController.text.toString() != "" ? customController.text.toString():'New Step Title', description: 'New Step Description'));
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Text('Delete Last Step'),
                        onPressed: ()async{
                          return showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text('Are you sure you want to delete the last step?'),
                              actions: <Widget>[
                                MaterialButton(
                                  elevation: 5.0,
                                  child: Text('Yes'),
                                  onPressed: () async{
                                    if(stepList.length==0) {
                                      return showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          title: Text('ERROR\nHowTo is already empty'),
                                          actions: <Widget>[
                                            MaterialButton(
                                              elevation: 5.0,
                                              child: Text('OK'),
                                              onPressed: (){
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    } else {
                                      final DataService _ds = DataService(uid: "asdf");
                                      await _ds.deleteLastStep(stepCompare.last.id);
                                      Navigator.of(context).pop();
                                    }
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
                        },
                      ),
                    ],),
                  ),
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
}