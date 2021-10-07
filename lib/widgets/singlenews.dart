import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/provider/userdataprovider.dart';
import 'package:news_app/screens/detailscreen.dart';
import 'package:news_app/screens/signin.dart';
import 'package:provider/provider.dart';

late double _height, _width;

class Singlenews extends StatefulWidget {
  late int index;
  late String image;
  late String chname;
  late String authname;
  late String title;
  late String date;
  late String desc;
  late String webUrl;
  bool isColor;
  late String docId;
  Singlenews({
    required this.image,
    required this.chname,
    required this.authname,
    required this.title,
    required this.date,
    required this.index,
    required this.isColor,
    required this.desc,
    required this.webUrl,
    this.docId = "",
  });
  @override
  _SinglenewsState createState() => _SinglenewsState();
}

late UserDataProvider _dataProvider;
User? user;

class _SinglenewsState extends State<Singlenews> {
  showAlertDialog(BuildContext ctx) {
    Widget continueButton = TextButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );
    Widget signin = TextButton(
      child: Text("Signin"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign In?"),
      content: Text("Login your Account to add news in favourites"),
      actions: [
        continueButton,
        signin,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  checkUser({
    required String chName,
    required String Authname,
    required String image,
    required String date,
    required String description,
    required String title,
    required String webUrl,
  }) async {
    if (user != null) {
      setState(() {
        print("Single News ${widget.index.toString()}");

        widget.isColor = true;
      });

      var randomDoc = await FirebaseFirestore.instance
          .collection("User")
          .doc(user!.uid)
          .collection("favourites")
          .doc();

      FirebaseFirestore.instance
          .collection("User")
          .doc(user!.uid)
          .collection("favourites")
          .doc(randomDoc.id)
          .set({
        "Channel Name": chName,
        "Author Name": Authname,
        "Image": image,
        "Date": date,
        "Description": description,
        "Title": title,
        "Web Url": webUrl,
        "DocId": randomDoc.id,
      });
    } else {
      showAlertDialog(context);
    }
  }

  deletefavourite() {
    // _dataProvider = Provider.of<UserDataProvider>(
    //   context,
    //   listen: false,
    // );
    if (widget.docId != "") {
      print("Doc Id ${widget.docId}");
      setState(() {
        _dataProvider.deleteNews(widget.docId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    _dataProvider = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("No User Logged In");
    }

    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (ctx) => DetailScreen(
              chName: widget.chname,
              title: widget.title,
              imageUrl: widget.image,
              authorNm: widget.authname,
              date: widget.date,
              desc: widget.desc,
              webUrl: widget.webUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.black12, width: 2),
          ),
        ),
        width: _width,
        height: _height * 0.19,
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: _width * 0.4,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.image == ""
                      ? Image.asset(
                          "assets/galleryicon.png",
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: "assets/galleryicon.png",
                          image: widget.image,
                          fit: BoxFit.cover,
                        )),
            ),
            Container(
              height: double.infinity,
              width: _width * 0.5,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chname,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.date,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      widget.isColor == false
                          ? IconButton(
                              icon: Icon(
                                Icons.favorite_border_outlined,
                              ),
                              onPressed: () {
                                checkUser(
                                  title: widget.title,
                                  image: widget.image,
                                  chName: widget.chname,
                                  Authname: widget.authname,
                                  date: widget.date,
                                  description: widget.desc,
                                  webUrl: widget.webUrl,
                                );
                              })
                          : IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deletefavourite();
                              }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
