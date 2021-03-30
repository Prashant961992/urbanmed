import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var query;
var shopID = query.docs[0].id;
var queryResult=[];
var firebaseUser = FirebaseAuth.instance.currentUser;

class Search{
  searchProduct(String search){
    return FirebaseFirestore.instance.collection('Retailer').doc(shopID).collection("ProductData").where('productname',isEqualTo:search.substring(0,1).toUpperCase()).get();
  }
}