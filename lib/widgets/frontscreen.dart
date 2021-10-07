import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/provider/userdataprovider.dart';
import 'package:provider/provider.dart';
import 'package:news_app/widgets/newslist.dart';
import 'singlenews.dart';

class FrontScreen extends StatefulWidget {
  late String category;
  late String query;

  FrontScreen({required this.query, required this.category});
  @override
  _FrontScreenState createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  late double _width, _height;
  List<NewsModel> newslist = <NewsModel>[];

  bool isloading = true;
  getNews({required String category, required String query}) async {
    // setState(() {
    //   news = query;
    //   Categories = categories;
    // });
    var url;

    // if (query.contains("top-headlines")) {
    //   url =
    //       "https://newsapi.org/v2/$category?q=$query&apiKey=eb672f375cc844968196976f9c627a34";
    // } else {
    url =
        "https://newsapi.org/v2/$category?q=$query&apiKey=eb672f375cc844968196976f9c627a34";
    // }

    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["articles"].forEach((element) {
      NewsModel newsModel = NewsModel();
      newsModel = NewsModel.fromMap(element);
      newslist.add(newsModel);
    });

    setState(() {
      isloading = false;
    });
  }

  Widget customChip({required String tag}) {
    return GestureDetector(
      onTap: () {
        print("Function in Custom Chip");
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => newsList(name: "$tag"),
            ),
          );
        });
      },
      child: Chip(
        backgroundColor: Color(0xFFE1E4F3),
        padding: const EdgeInsets.symmetric(vertical: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        label: Text(
          "#$tag",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(category: widget.category, query: widget.query);
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    // User? user = FirebaseAuth.instance.currentUser;
    // print("This is Current User $user");
    // showAlertDialog(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Container(
          //   color: kprimary,
          //   width: _width,
          //   height: _height * 0.1,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       // Center(
          //       //   child: Text(
          //       //     "Infinite News",
          //       //     style: GoogleFonts.lato(
          //       //       textStyle:
          //       //           TextStyle(fontSize: 25, color: Colors.white),
          //       //     ),
          //       //   ),
          //       // ),

          //       // TabBarView(children: children)
          //     ],
          //   ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                // color: Colors.teal,
                // border: Border.symmetric(
                //   horizontal: BorderSide(color: Colors.black12, width: 2),
                // ),
                ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: _width,
            height: _height * 0.24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: _width,
                  // color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Tags",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _width,
                  height: _height * 0.19,
                  // color: Colors.indigo,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customChip(tag: "music"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "health"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "entertainment"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customChip(tag: "technology"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "apple"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "ronaldo"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customChip(tag: "rock"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "pakistan"),
                          SizedBox(
                            width: 15,
                          ),
                          customChip(tag: "pubg"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   width: _width,
          //   height: _height * 0.05,
          //   color: Colors.green,
          //   margin: EdgeInsets.symmetric(horizontal: 25),
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.thumb_up_off_alt_sharp,
          //         color: Colors.black,
          //       ),
          //       SizedBox(
          //         width: 15,
          //       ),
          //       Text(
          //         "RECOMMENDED FOR YOU",
          //         style: GoogleFonts.lato(
          //           textStyle:
          //               TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          isloading == false
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: newslist.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {},
                      child: Singlenews(
                        isColor: false,
                        index: index,
                        chname: newslist[index].chName,
                        authname: newslist[index].author,
                        date: newslist[index].date,
                        title: newslist[index].title,
                        image: newslist[index].imageUrl,
                        desc: newslist[index].desc,
                        webUrl: newslist[index].webUrl,
                      ),
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
