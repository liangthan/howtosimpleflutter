import 'package:firebase_auth/firebase_auth.dart';
import 'package:howtosimple/models/user.dart';
import 'package:howtosimple/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null?User(uid: user.uid):user;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerEmPa(String emai, String pass) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: emai, password: pass);
      FirebaseUser user = result.user;
      await DataService(uid: user.uid).updateUserData("", "no", "yes");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmPa(String emai, String pass) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: emai, password: pass);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
