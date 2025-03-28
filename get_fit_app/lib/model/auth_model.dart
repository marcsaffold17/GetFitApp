import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel
{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final databaseReference = FirebaseFirestore.instance.collection("Login-Info");

  Future<void> createAccount(String username, String password) async
  {
    databaseReference.doc(username).set({"Password": password});
  }

  Future<bool> CheckAccountInfo(String username, String password) async
  {
    var docRef = db.collection("Login-Info").doc(username);
    var doc = await docRef.get();

      if(doc.exists) 
      {
        print("works");
        bool isValid = await checkPassword(username,password);
        return isValid;
      }
      else
      {
        print("Invalid Username/Password");
        return false;
      }
    }
  }

  Future<bool> checkPassword(String username, String password) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot ds = await db.collection("Login-Info").doc(username).get();
    String Password = ds.get("Password").toString();
    print(Password);
    if (Password == password) 
    { 
      print("Correct Password");
      return true;
    } 
    else 
    {
      print("Incorrect");
      return false;
    }

  }