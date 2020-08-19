import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:howtosimple/models/displayuser.dart';
import 'package:howtosimple/models/howtoitem.dart';
import 'package:howtosimple/models/howtostep.dart';
//import 'package:firebase/firebase.dart';
//import 'package:flutter/material.dart';

class DataService {

  final String uid;
  DataService({this.uid});

  final CollectionReference howtouserCollection = Firestore.instance.collection('howtouser');
  final CollectionReference howtoCollection = Firestore.instance.collection('howtos');
  final CollectionReference howtostepCollection = Firestore.instance.collection('howtosteps');
  
  Future updateUserData(String name, String darkMode, String greeting) async {
    return await howtouserCollection.document(uid).setData({
      'name': name,
      'darkMode': darkMode,
      'greeting': greeting,
    });
  }

  List<DisplayUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return DisplayUser(
        name: doc.data['name'] ?? '',
        darkMode: doc.data['darkMode'] ?? 'no',
        greeting: doc.data['greeting'] ?? 'yes',
      );
    }).toList();
  }

  Stream<List<DisplayUser>> get displayusers {
    return howtouserCollection.snapshots()
    .map(_userListFromSnapshot);
  }

  Future updateHowTo(String title) async {
    title = title.isEmpty ? "New HowTo" : title;
    howtoCollection.add({
      'user': uid,
      'title': title,
      'timestamp': Timestamp.now(), 
    });
  }

  List<HowToItem> _howtoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return HowToItem(
        id: doc.documentID ?? '',
        title: doc.data['title'] ?? '',
        creator: doc.data['user'] ?? '',
      );
    }).toList();
  }

  Stream<List<HowToItem>> get displayHowTos {
    return howtoCollection.where('user', isEqualTo: uid).snapshots()
    .map(_howtoListFromSnapshot);
  }

  List<HowToStep> _howtostepListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return HowToStep(
        id: doc.documentID ?? '',
        howtoid: doc.data['howtoId'] ?? '',
        stepnumber: doc.data['stepnumber'] ?? 999,
        title: doc.data['title'] ?? '',
        description: doc.data['description'] ?? '',
      );
    }).toList();
  }

  Stream<List<HowToStep>> get displayHowToSteps {
    return howtostepCollection.where('howtoId', isEqualTo: uid).snapshots()
    .map(_howtostepListFromSnapshot);
  }

  Future deleteStep(String id) async {
    return await howtostepCollection.document(id).delete();
  }

  Future deleteLastStep(String id) async {
    return await howtostepCollection.document(id).delete();
  }

  Future deleteHowTo(String howtoId) async {
    return await howtoCollection.document(howtoId).delete();
  }

  Future deleteStepsWithHowTo(String howtoId) async {
    var query = howtostepCollection.where('howtoId', isEqualTo: howtoId);
    query.getDocuments().then((querySnapshot){
      for(DocumentSnapshot st in querySnapshot.documents) {
        st.reference.delete();
      }
    });
  }

  DisplayUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return DisplayUser(
      uid: uid,
      name: snapshot.data['name'],
      darkMode: snapshot.data['darkMode'],
      greeting: snapshot.data['greeting'],
    );
  }

  Stream<DisplayUser> get userData {
    return howtouserCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }

  Future updateStep(HowToStep step) async {
    return await howtostepCollection.document(step.id).setData({
      'howtoId': step.howtoid,
      'stepnumber': step.stepnumber,
      'title': step.title,
      'description': step.description,
    });
  }

}
