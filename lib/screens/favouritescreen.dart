import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/provider/userdataprovider.dart';
import 'package:news_app/widgets/singlenews.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

late double _width, _height;
late UserDataProvider _dataProvider;

class _FavouriteScreenState extends State<FavouriteScreen> {
  User? user;

  String userUid = "";
  getUserId() {
    if (FirebaseAuth.instance.currentUser != null) {
      _dataProvider.getFavouriteData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // getData()

    _dataProvider = Provider.of<UserDataProvider>(
      context,
    );
    getUserId();
    return Container(
      color: kprimary,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: kprimary,
                  width: _width,
                  height: _height * 0.07,
                  child: Center(
                    child: Text(
                      "Favourite Screen",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          return Container();
                        }
                      }
                      return Container(
                        color: Colors.white,
                        //   width: _width,
                        //   // height: _height,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _dataProvider.getFavouritesListLength(),
                          itemBuilder: (context, index) {
                            print(_dataProvider.getFavouritesListLength());
                            return Singlenews(
                              content: _dataProvider
                                  .getFavouritesList[index].content,
                              index: 8,
                              isColor: true,
                              authname: _dataProvider
                                  .getFavouritesList[index].Authname,
                              chname:
                                  _dataProvider.getFavouritesList[index].Chname,
                              image:
                                  _dataProvider.getFavouritesList[index].image,
                              title:
                                  _dataProvider.getFavouritesList[index].title,
                              date: _dataProvider.getFavouritesList[index].date,
                              desc: _dataProvider
                                  .getFavouritesList[index].description,
                              webUrl:
                                  _dataProvider.getFavouritesList[index].webUrl,
                              docId:
                                  _dataProvider.getFavouritesList[index].docId,
                            );
                          },
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
