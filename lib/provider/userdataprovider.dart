import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/model/favourite.dart';

class UserDataProvider extends ChangeNotifier {
  List<Favourite> favouritesList = [];
  late Favourite favouriteData;

  Future<void> getFavouriteData() async {
    List<Favourite> newList = [];
    var db;
    try {
      db = await FirebaseFirestore.instance
          .collection("User")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favourites")
          .get();
    } catch (e) {}

    if (db != null) {
      db.docs.forEach((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        favouriteData = Favourite(
          image: data["Image"],
          Chname: data["Channel Name"],
          Authname: data["Author Name"],
          date: data["Date"],
          title: data["Title"],
          description: data["Description"],
          webUrl: data["Web Url"],
          docId: data["DocId"],
        );
        newList.add(favouriteData);
      });
      favouritesList = newList;
    } else {
      print("Value is Null");
    }

    notifyListeners();
  }

  Future<void> deleteNews(String news) async {
    var docRef = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favourites");

    if (docRef != null) {
      docRef.doc(news).delete();
    }
    // notifyListeners();
  }

  List<Favourite> get getFavouritesList {
    return List.from(favouritesList);
  }

  int getFavouritesListLength() {
    return favouritesList.length;
  }
}
