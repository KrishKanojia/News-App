import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/widgets/singlenews.dart';

class searchScreen extends StatefulWidget {
  late String item;

  searchScreen({this.item = "sports"});
  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController searchController = TextEditingController();
  List<NewsModel> newslist = <NewsModel>[];
  Future getNews({required String query}) async {
    String tolow = query.toLowerCase();
    String name = tolow.trim();
    var url;

    url =
        "https://newsapi.org/v2/everything?q=$name&apiKey=eb672f375cc844968196976f9c627a34";

    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);

      data["articles"].forEach((element) {
        NewsModel newsModel = NewsModel();
        newsModel = NewsModel.fromMap(element);
        newslist.add(newsModel);
      });
      print("Data Fetched Easily");
      // setState(() {
      //   isloading = false;
      // });
      print("News list Length ${newslist.length}");
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    if ((searchController.text).replaceAll(" ", "") == "") {
                      print("Blank search");
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => searchScreen(
                            item: searchController.text,
                          ),
                        ),
                      );
                    }
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: Icon(Icons.clear)),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if ((searchController.text).replaceAll(" ", "") ==
                              "") {
                            print("Blank search");
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => searchScreen(
                                  item: searchController.text,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            ),
          ],
        ),
      ),

      body:
          // Stack(
          //   children: [
          //     Container(
          //       width: MediaQuery.of(context).size.width,
          //       height: MediaQuery.of(context).size.height,
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(colors: [
          //           Color(0xff213A50),
          //           Color(0xff071938),
          //         ]),
          //       ),
          //     ),
          Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 8),
                //     margin:
                //         EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(24),
                //     ),
                //     child: Row(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             if ((searchController.text).replaceAll(" ", "") ==
                //                 "") {
                //               print("Blank search");
                //             } else {
                //               Navigator.of(context).pushReplacement(
                //                 MaterialPageRoute(
                //                   builder: (context) => searchScreen(
                //                     item: searchController.text,
                //                   ),
                //                 ),
                //               );
                //             }
                //           },
                //           child: Container(
                //             child: Icon(
                //               Icons.search,
                //               color: Colors.blueAccent,
                //             ),
                //             margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                //           ),
                //         ),
                //         Expanded(
                //           child: TextField(
                //             controller: searchController,
                //             decoration: InputDecoration(
                //               border: InputBorder.none,
                //               hintText: "Let's cook Something",
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                child: FutureBuilder(
                    future: getNews(query: widget.item),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none &&
                          projectSnap.hasData == null) {
                        print('project snapshot data is: ${projectSnap.data}');
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Search Not Available"),
                          ],
                        );
                      }
                      return SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: ScrollPhysics(),
                        child:
                            // FrontScreen(),
                            Column(
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

                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: newslist.length,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Singlenews(
                                      content: newslist[index].content,
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
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      //   ],
      // ),
    );
  }
}
